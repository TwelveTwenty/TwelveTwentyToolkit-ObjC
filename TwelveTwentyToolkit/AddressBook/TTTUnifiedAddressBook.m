// Copyright (c) 2012 Twelve Twenty (http://twelvetwenty.nl)
//
// Permission is hereby granted, free of charge, to any unifiedRecord obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <CoreData/CoreData.h>
#import "TwelveTwentyToolkit.h"
#import "TTTUnifiedAddressBook.h"
#import "TTTCDLinkedRecord.h"
#import "TTTCDUnifiedRecord.h"
#import "NSManagedObjectContext+TTTBatchManipulation.h"

#ifndef OR_EMPTY
#define OR_EMPTY(VALUE)    ({ __typeof__(VALUE) __value = (VALUE); __value ? __value : @""; })
#endif

void tt_handleABExternalChange(ABAddressBookRef addressBook, CFDictionaryRef info, void *context)
	{
		NSLog(@"External change of the address book detected. Call updateAddressBookWithCompletion: to update the index.");
		[[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotificationName:object:) withObject:TT_UNIFIED_ADDRESS_BOOK_REQUEST_UPDATE_NOTIFICATION waitUntilDone:NO];
	}

@interface TTTUnifiedAddressBook ()

@property(nonatomic, strong) NSManagedObjectModel *objectModel;
@property(nonatomic, strong) NSPersistentStoreCoordinator *storeCoordinator;
@property(nonatomic, strong) NSManagedObjectContext *mainContext;
@property(nonatomic, readwrite) ABAddressBookRef addressBook;

@end

@implementation TTTUnifiedAddressBook

@synthesize objectModel = _managedObjectModel;
@synthesize storeCoordinator = _storeCoordinator;
@synthesize mainContext = _mainContext;
@synthesize addressBook = _addressBook;

+ (void)accessAddressBookWithGranted:(void (^)(ABAddressBookRef addressBook))accessGrantedBlock denied:(void (^)(BOOL restricted))accessDeniedBlock
{
	BOOL requireAccessRequest = NO;
	if (&ABAddressBookGetAuthorizationStatus != NULL)
	{
		// iOS 6+
		ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
		switch (status)
		{
			case kABAuthorizationStatusRestricted:
			case kABAuthorizationStatusDenied:
				accessDeniedBlock(status == kABAuthorizationStatusRestricted);
				return;
			case kABAuthorizationStatusNotDetermined:
				// wait for asking permission
				requireAccessRequest = YES;
				break;
			case kABAuthorizationStatusAuthorized:
				// create the address book
				break;
		}
	}
	else
	{
		// Require access not needed on iOS 5-.
	}

    
    
	__block ABAddressBookRef addressBook;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
	if (&ABAddressBookCreateWithOptions == NULL && &ABAddressBookCreate != NULL)
	{
		// iOS 5-
		addressBook = ABAddressBookCreate();
		accessGrantedBlock(addressBook);
	}
#pragma clang diagnostic pop
	else if (&ABAddressBookCreateWithOptions != NULL)
	{
		// iOS 6+
		CFErrorRef error = NULL;
		addressBook = ABAddressBookCreateWithOptions(NULL, &error);
		if (addressBook != NULL)
		{
			if (!requireAccessRequest)
			{
				accessGrantedBlock(addressBook);
			}
			else
			{
				NSLog(@"Here still on %@ thread.", [NSThread isMainThread] ? @"main" : @"background");
				ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error)
					{
						NSLog(@"Granted (error: %@", error);
						dispatch_barrier_sync(dispatch_get_main_queue(), ^
																			 {
																				 if (granted)
																				 {
																					 // Constructing a new address book, since the
																					 // background block invalidated our existing instance.
                                                                                     ABAddressBookRef ab = ABAddressBookCreateWithOptions(NULL, NULL);
																					 accessGrantedBlock(ab);
                                                                                     CFReleaseIfNotNULL(ab);
																				 }
																				 else
																				 {
																					 accessDeniedBlock(NO);
																				 }
																			 });
					});

			}
		}
		else
		{
			// Catch 22 - We checked whether access was required and it was not, yet here we are with a NULL address book. Let's pray we never get here.
			[[NSException exceptionWithName:@"TT_UNIFIED_ADDRESS_BOOK_EXCEPTION" reason:[NSString stringWithFormat:@"Could not create address book: %@", error] userInfo:nil] raise];
		}
        
        CFReleaseIfNotNULL(addressBook);
	}
}

+ (ABAddressBookRef)newAddressBookInline
{
	ABAddressBookRef addressBook = NULL;
	CFErrorRef error = NULL;

	if (&ABAddressBookCreateWithOptions == NULL)
	{
		// iOS 5-
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
		addressBook = ABAddressBookCreate();
#pragma clang diagnostic pop
	}
	else
	{
		// iOS 6+
		addressBook = ABAddressBookCreateWithOptions(NULL, &error);
	}

	if (addressBook == NULL)
	{
		// Catch 22 - We checked whether access was required and it was not, yet here we are with a NULL address book. Let's pray we never get here.
		[[NSException exceptionWithName:@"TT_UNIFIED_ADDRESS_BOOK_EXCEPTION" reason:[NSString stringWithFormat:@"Could not create address book: %@", error] userInfo:nil] raise];
	}

	return addressBook;
}

/**
 * Without an address book, this class will not initialize.
 * Use `+accessAddressBookWithGranted:denied:` to get at that address book reference.
 */
- (id)initWithAddressBook:(ABAddressBookRef)addressBook
{
	self = [super init];

	if (self)
	{
		if (addressBook == NULL)
		{
			self = nil;
			return self;
		}

		if (![self setupCoreData])
		{
			self = nil;
			return self;
		}

		self.addressBook = addressBook;
		ABAddressBookRegisterExternalChangeCallback(self.addressBook, tt_handleABExternalChange, (__bridge void *) self);
	}

	return self;
}

- (void)setAddressBook:(ABAddressBookRef)addressBook
{
    CFRetainIfNotNULL(addressBook);
    CFReleaseIfNotNULL(_addressBook);
    _addressBook = addressBook;
}

- (void)updateAddressBookWithCompletion:(void (^)())completion
{
	dispatch_queue_t backgroundQueue = dispatch_queue_create("nl.twelvetwenty.TTTUnifiedAddressBook", NULL);

	dispatch_async(backgroundQueue, ^
		{
			ABAddressBookRef addressBook = [[self class] newAddressBookInline];

			if ([self unifyAddressBook:addressBook])
			{
				// completion callback
				dispatch_async(dispatch_get_main_queue(), completion);
			}
			else
			{
				[[NSException exceptionWithName:@"TT_UNIFIED_ADDRESS_BOOK_EXCEPTION" reason:@"Could not unify address book" userInfo:nil] raise];
			}

			CFReleaseIfNotNULL(addressBook);
		});
}

#pragma - Indexing

- (BOOL)unifyAddressBook:(ABAddressBookRef)addressBook
{
	NSManagedObjectContext *context = [self newContext];

	// Set the updated flag to NO for all linked cards.
	NSError *error = nil;
    [context ttt_deleteAllEntitiesNamed:[TTTCDLinkedRecord entityName] error:&error];
    [context ttt_deleteAllEntitiesNamed:[TTTCDUnifiedRecord entityName] error:&error];

	ABRecordRef source = ABAddressBookCopyDefaultSource(addressBook);
	NSArray *records = (__bridge_transfer NSArray *) ABAddressBookCopyArrayOfAllPeopleInSource(addressBook, source);
	ABAddressBookCopyArrayOfAllPeopleInSourceWithSortOrdering(addressBook, source, ABPersonGetSortOrdering());
    CFReleaseIfNotNULL(source);

	printf("Indexing...");
	NSUInteger idx = 0;
	NSUInteger count = [records count];
	for (id untypedRecord in records)
	{
		ABRecordRef unifiedRecordRef = (__bridge ABRecordRef) untypedRecord;
		NSNumber *recordID = [NSNumber numberWithInteger:ABRecordGetRecordID(unifiedRecordRef)];

		TTTCDUnifiedRecord *unifiedRecord = [TTTCDUnifiedRecord insertInManagedObjectContext:context];
		unifiedRecord.recordID = recordID;
		unifiedRecord.sortFieldFirstName = [self createSortFieldForRecord:unifiedRecordRef sortOrdering:kABPersonSortByFirstName];
		unifiedRecord.sortFieldLastName = [self createSortFieldForRecord:unifiedRecordRef sortOrdering:kABPersonSortByLastName];
		unifiedRecord.positionValue = idx / (float)count;

		NSArray *linkedRecordsArray = (__bridge_transfer NSArray *) ABPersonCopyArrayOfAllLinkedPeople(unifiedRecordRef);
		for (id untypedLinkedRecord in linkedRecordsArray)
		{
			ABRecordRef linkedRecordRef = (__bridge ABRecordRef) untypedLinkedRecord;
			NSNumber *linkedRecordID = [NSNumber numberWithInteger:ABRecordGetRecordID(linkedRecordRef)];

			TTTCDLinkedRecord *linkedRecord = [TTTCDLinkedRecord insertInManagedObjectContext:context];
			linkedRecord.recordID = linkedRecordID;
			linkedRecord.unifiedRecord = unifiedRecord;
		}

		printf(".");
		idx++;
	}

	printf("\n");

	if (![context save:&error])
	{
		NSLog(@"Could not save background context: %@", error);
		return NO;
	} else
	{
		NSLog(@"Unified %i records", idx);
	}

	return YES;
}

- (NSString *)createSortFieldForRecord:(ABRecordRef)record sortOrdering:(ABPersonSortOrdering)sortOrdering
{
	NSString *firstName = (__bridge_transfer NSString *) ABRecordCopyValue(record, kABPersonFirstNameProperty);
	NSString *lastName = (__bridge_transfer NSString *) ABRecordCopyValue(record, kABPersonLastNameProperty);
	NSString *middleName = (__bridge_transfer NSString *) ABRecordCopyValue(record, kABPersonMiddleNameProperty);
	NSString *companyName = (__bridge_transfer NSString *) ABRecordCopyValue(record, kABPersonOrganizationProperty);
	NSString *nickName = (__bridge_transfer NSString *) ABRecordCopyValue(record, kABPersonNicknameProperty);

	switch (sortOrdering)
	{
		case kABPersonSortByFirstName:
		{
			return [@[OR_EMPTY(firstName), OR_EMPTY(lastName), OR_EMPTY(middleName), OR_EMPTY(companyName), OR_EMPTY(nickName)] componentsJoinedByString:@""];
		}
		default:
		case kABPersonSortByLastName:
		{
			return [@[OR_EMPTY(lastName), OR_EMPTY(middleName), OR_EMPTY(firstName), OR_EMPTY(companyName), OR_EMPTY(nickName)] componentsJoinedByString:@""];
		}
	}
}

#pragma - Fetching cards & searching

- (NSArray *)allCards
{
	NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:[TTTCDUnifiedRecord entityName]];
	NSString *sortKey = TTCDUnifiedRecordAttributes.position;
	request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:sortKey ascending:YES]];

	NSError *error = nil;
	NSArray *results = [self.mainContext executeFetchRequest:request error:&error];
	NSMutableArray *cards = nil;
	if (results)
	{
		cards = [NSMutableArray arrayWithCapacity:results.count];
		for (TTTCDUnifiedRecord *record in results)
		{
			[cards addObject:record.personCard];
		}
	}

	return cards;
}

- (void)cardsMatchingQuery:(NSString *)query withAsyncResults:(void (^)(NSArray *))resultsBlock
{
	dispatch_queue_t backgroundQueue = dispatch_queue_create("nl.twelvetwenty.TTTUnifiedAddressBook", NULL);

	dispatch_async(backgroundQueue, ^
		{
			NSArray *cards = [self cardsMatchingQuery:query];
			dispatch_async(dispatch_get_main_queue(), ^{resultsBlock(cards);});
		});
}

- (NSArray *)cardsMatchingQuery:(NSString *)query
{
	ABAddressBookRef addressBook = [[self class] newAddressBookInline];
	NSManagedObjectContext *context = [NSThread mainThread] ? self.mainContext : [self newContext];
	CFStringRef queryRef = (__bridge CFStringRef) query;
	NSLog(@"Searching within %li cards", ABAddressBookGetPersonCount(addressBook));
	CFArrayRef recordsRef = ABAddressBookCopyPeopleWithName(addressBook, queryRef);
	NSArray *records = (__bridge_transfer NSArray *) recordsRef;
	NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:[TTTCDUnifiedRecord entityName]];
	NSString *sortKey = TTCDUnifiedRecordAttributes.position;
	request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:sortKey ascending:YES]];

	NSError *error = nil;
	NSArray *results = [context executeFetchRequest:request error:&error];
	NSMutableArray *cards = nil;

	if (results)
	{
		if (query == nil || [query isEqualToString:@""])
		{
			cards = [NSMutableArray arrayWithCapacity:results.count];
			for (TTTCDUnifiedRecord *record in results)
			{
				[cards addObject:record.personCard];
			}
		}
		else
		{
			printf("Searching...");
			NSPredicate *filter = [NSPredicate predicateWithBlock:^BOOL(TTTCDUnifiedRecord *evaluatedObject, NSDictionary *bindings)
				{
					for (id untypedRecord in records)
					{
						ABRecordRef record = (__bridge ABRecordRef) untypedRecord;
						ABRecordID recordID = ABRecordGetRecordID(record);
						if (evaluatedObject.recordIDValue == recordID) return YES;
					}
					printf(".");
					return NO;
				}];
			NSArray *filteredResults = [results filteredArrayUsingPredicate:filter];
			printf("\n");

			cards = [NSMutableArray arrayWithCapacity:filteredResults.count];
			for (TTTCDUnifiedRecord *record in filteredResults)
			{
				[cards addObject:record.personCard];
			}
		}
	}

	CFReleaseIfNotNULL(addressBook);
	return cards;
}

#pragma - Core Data

- (BOOL)setupCoreData
{
	// Until it's possible to add an xcdatamodel in CocoaPods, the model will be written in code, not the visual modeling tool.
	//
	//    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"TTTUnifiedAddressBook" withExtension:@"momd"];
	//    self.objectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
	//
	self.objectModel = [self model];

	self.storeCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.objectModel];

	NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
												  [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
												  [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];

	if (NO)
	{
		NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
		NSURL *storeURL = [NSURL fileURLWithPath:[documentsDirectory stringByAppendingPathComponent:@"TTTUnifiedAddressBook.store"]];
		NSError *error = nil;
		BOOL giveUp = NO;
		BOOL storeAdded = NO;
		while (!giveUp && !storeAdded)
		{
			storeAdded = ([self.storeCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error] != nil);
			if (!storeAdded)
			{
				NSLog(@"Could not add store to coordinator: %@", error);
				if (!giveUp)
				{
					if ([[NSFileManager defaultManager] removeItemAtURL:storeURL error:&error])
					{
						NSLog(@"Deleted sqlite store to circumvent migration.");
					}
					else
					{
						NSLog(@"Could not delete the existing store: %@", error);
					}

					giveUp = YES;
				}
				else
				{
					// give up.
					return NO;
				}
			}
		}
	}
	else
	{
		NSError *error = nil;
		BOOL giveUp = NO;
		BOOL storeAdded = NO;
		while (!giveUp && !storeAdded)
		{
			storeAdded = ([self.storeCoordinator addPersistentStoreWithType:NSInMemoryStoreType configuration:nil URL:nil options:options error:&error] != nil);
			if (!storeAdded)
			{
				NSLog(@"Could not add store to coordinator: %@", error);
				giveUp = YES;
			}
		}
	}

	self.mainContext = [self newContext];
	return YES;
}

- (NSManagedObjectContext *)newContext
{
	NSManagedObjectContext *context = [[NSManagedObjectContext alloc] init];
	[context setPersistentStoreCoordinator:self.storeCoordinator];
	[context setMergePolicy:NSMergeByPropertyStoreTrumpMergePolicy];
	[context setUndoManager:nil];

	if (![NSThread isMainThread])
	{
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDidSaveNotification:) name:NSManagedObjectContextDidSaveNotification object:context];
	}

	return context;
}

- (void)handleDidSaveNotification:(NSNotification *)notification
{
	// bump the notification to the main thread for processing.
	[self.mainContext performSelectorOnMainThread:@selector(mergeChangesFromContextDidSaveNotification:)
									   withObject:notification
									waitUntilDone:YES];
}

- (NSManagedObjectModel *)model
{
	NSManagedObjectModel *model = [[NSManagedObjectModel alloc] init];

	NSEntityDescription *unifiedRecord = [[NSEntityDescription alloc] init];
	unifiedRecord.name = [TTTCDUnifiedRecord entityName];
	unifiedRecord.managedObjectClassName = NSStringFromClass([TTTCDUnifiedRecord class]);

	NSRelationshipDescription *rel_linkedRecord = [[NSRelationshipDescription alloc] init];
	rel_linkedRecord.name = TTCDUnifiedRecordRelationships.linkedRecord;
	rel_linkedRecord.minCount = 1;
	rel_linkedRecord.maxCount = 0;

	NSAttributeDescription *att_unifiedRecordID = [[NSAttributeDescription alloc] init];
	att_unifiedRecordID.name = TTCDUnifiedRecordAttributes.recordID;
	att_unifiedRecordID.attributeType = NSInteger32AttributeType;
	[att_unifiedRecordID setIndexed:YES];

	NSAttributeDescription *att_unifiedPosition = [[NSAttributeDescription alloc] init];
	att_unifiedPosition.name = TTCDUnifiedRecordAttributes.position;
	att_unifiedPosition.attributeType = NSFloatAttributeType;

	NSAttributeDescription *att_sortFieldFirstName = [[NSAttributeDescription alloc] init];
	att_sortFieldFirstName.name = TTCDUnifiedRecordAttributes.sortFieldFirstName;
	att_sortFieldFirstName.attributeType = NSStringAttributeType;

	NSAttributeDescription *att_sortFieldLastName = [[NSAttributeDescription alloc] init];
	att_sortFieldLastName.name = TTCDUnifiedRecordAttributes.sortFieldLastName;
	att_sortFieldLastName.attributeType = NSStringAttributeType;

	NSEntityDescription *linkedRecord = [[NSEntityDescription alloc] init];
	linkedRecord.name = [TTTCDLinkedRecord entityName];
	linkedRecord.managedObjectClassName = NSStringFromClass([TTTCDLinkedRecord class]);

	NSRelationshipDescription *rel_unifiedRecord = [[NSRelationshipDescription alloc] init];
	rel_unifiedRecord.name = TTCDLinkedRecordRelationships.unifiedRecord;
	rel_unifiedRecord.destinationEntity = unifiedRecord;
	rel_unifiedRecord.inverseRelationship = rel_linkedRecord;
	rel_unifiedRecord.minCount = 1;
	rel_unifiedRecord.maxCount = 1;

	rel_linkedRecord.destinationEntity = linkedRecord;
	rel_linkedRecord.inverseRelationship = rel_unifiedRecord;

	NSAttributeDescription *att_linkedRecordID = [[NSAttributeDescription alloc] init];
	att_linkedRecordID.name = TTCDLinkedRecordAttributes.recordID;
	att_linkedRecordID.attributeType = NSInteger32AttributeType;
	[att_linkedRecordID setIndexed:YES];

	unifiedRecord.properties = @[att_unifiedRecordID, att_sortFieldFirstName, att_sortFieldLastName, att_unifiedPosition, rel_linkedRecord];
	linkedRecord.properties = @[att_linkedRecordID, rel_unifiedRecord];

	model.entities = @[unifiedRecord, linkedRecord];

	return model;
}

@end

