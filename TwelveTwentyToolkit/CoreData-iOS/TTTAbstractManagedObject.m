#import "TTTTimestamped.h"
#import "TTTAbstractManagedObject.h"
#import "TTTTimestamped.h"
#import "NSManagedObject+TTTUniquing.h"

const struct TTTIdentifiableAttributes TTTIdentifiableAttributes = {
        .identifier = @"identifier",
};

const struct TTTSyncStatusAttributes TTTSyncStatusAttributes = {
        .syncStatus = @"syncStatus",
};

const struct TTTSyncStatusValues TTTSyncStatusValues = {
        .synchronized = @"synchronized",
        .inserted = @"inserted",
        .updated = @"updated",
        .deleted = @"deleted",
};

@implementation TTTAbstractManagedObject

+ (id)uniqueEntityWithIdentifier:(NSNumber *)identifier inContext:(NSManagedObjectContext *)context
{
    NSAssert([self conformsToProtocol:@protocol(TTTIdentifiable)], @"Class %@ must conform to protocol TTTIdentifiable to use this method.", self);
    id entity = [self tttUniqueEntityWithValue:identifier forKey:TTTIdentifiableAttributes.identifier inContext:context];
    return entity;
}

+ (id)existingEntityWithIdentifier:(NSNumber *)identifier inContext:(NSManagedObjectContext *)context
{
    NSAssert([self conformsToProtocol:@protocol(TTTIdentifiable)], @"Class %@ must conform to protocol TTTIdentifiable to use this method.", self);
    id entity = [self tttExistingEntityWithValue:identifier forKey:TTTIdentifiableAttributes.identifier inContext:context];
    return entity;
}

+ (NSFetchRequest *)fetchRequestWithSortingKeys:(id)sortingKeysWithAscendingFlag
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[(id) self entityName]];
    request.fetchBatchSize = 100;

    if (sortingKeysWithAscendingFlag)
    {
        NSArray *arrayOfSortingKeysWithAscendingFlag = sortingKeysWithAscendingFlag;
        if (![arrayOfSortingKeysWithAscendingFlag isKindOfClass:[NSArray class]])
        {
            arrayOfSortingKeysWithAscendingFlag = @[sortingKeysWithAscendingFlag];
        }

        NSMutableArray *sortDescriptors = [NSMutableArray array];
        [arrayOfSortingKeysWithAscendingFlag enumerateObjectsUsingBlock:^(NSDictionary *sortingKeysWithAscendingFlag, NSUInteger idx, BOOL *stop) {
            NSAssert([sortingKeysWithAscendingFlag isKindOfClass:[NSDictionary class]], @"Only supports one level of nested dictionaries. Not %@", sortingKeysWithAscendingFlag);
            [sortingKeysWithAscendingFlag enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSNumber *ascending, BOOL *stop) {
                [sortDescriptors addObject:[NSSortDescriptor sortDescriptorWithKey:key ascending:[ascending boolValue]]];
            }];
        }];

        request.sortDescriptors = sortDescriptors;
    }

    request.returnsObjectsAsFaults = NO;
    request.includesPendingChanges = YES;

    return request;
}

+ (NSFetchedResultsController *)fetchedResultsControllerWithSortingKeys:(id)sortingKeysWithAscendingFlag
                                                   managedObjectContext:(NSManagedObjectContext *)context
{
    return [self fetchedResultsControllerWithSortingKeys:sortingKeysWithAscendingFlag
                                    managedObjectContext:context
                                      sectionNameKeyPath:nil];
}

+ (NSFetchedResultsController *)fetchedResultsControllerWithSortingKeys:(id)sortingKeysWithAscendingFlag
                                                   managedObjectContext:(NSManagedObjectContext *)context
                                                     sectionNameKeyPath:(NSString *)sectionNameKeyPath
{
    return [self fetchedResultsControllerWithSortingKeys:sortingKeysWithAscendingFlag
                                    managedObjectContext:context
                                      sectionNameKeyPath:sectionNameKeyPath
                                               cacheName:[@(rand()) stringValue]];
}

+ (NSFetchedResultsController *)fetchedResultsControllerWithSortingKeys:(id)sortingKeysWithAscendingFlag
                                                   managedObjectContext:(NSManagedObjectContext *)context
                                                     sectionNameKeyPath:(NSString *)sectionNameKeyPath
                                                              cacheName:(NSString *)cacheName
{
    NSFetchRequest *request = [self fetchRequestWithSortingKeys:sortingKeysWithAscendingFlag];

    NSFetchedResultsController *controller = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                                 managedObjectContext:context
                                                                                   sectionNameKeyPath:sectionNameKeyPath
                                                                                            cacheName:cacheName];

    return controller;
}

+ (id)insertInManagedObjectContext:(NSManagedObjectContext *)moc
{
    NSAssert(NO, @"This method should be overridden by a mogenerator generated entity class.");
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

+ (NSString *)entityName
{
    NSAssert(NO, @"This method should be overridden by a mogenerator generated entity class.");
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (void)awakeFromInsert
{
    [super awakeFromInsert];

    if ([self conformsToProtocol:@protocol(TTTTimestamped)])
    {
        NSDate *now = [NSDate date];
        [self setValue:now forKey:TTTTimestampedAttributes.createdAt];
        [self setValue:now forKey:TTTTimestampedAttributes.updatedAt];
    }
}

@end