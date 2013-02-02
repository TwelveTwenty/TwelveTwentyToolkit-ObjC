#import "TTAbstractCoreDataProxy.h"
#import "TTLog.h"

@interface TTAbstractCoreDataProxy () <TTAbstractCoreDataProxyProtected>

@property (nonatomic, strong, readwrite) NSManagedObjectContext *mainContext;
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong) NSManagedObjectContext *baseContext;
@property (nonatomic, strong) NSURL *storeURL;

@end

@implementation TTAbstractCoreDataProxy

- (id)initWithStoreName:(NSString *)storeName
{
	self = [super init];

	if (self)
	{
		self.storeURL = [[self storeDirectory] URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite", storeName]];
	}

	return self;
}

- (NSManagedObjectContext *)newPrivateContext
{
	NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
	context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy;
	context.parentContext = self.baseContext;
	context.undoManager = nil;

	return context;
}

- (NSManagedObjectContext *)mainContext
{
	if (_mainContext == nil)
	{
		self.mainContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
		_mainContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy;
		_mainContext.parentContext = self.baseContext;
		_mainContext.undoManager = nil;
	}

	return _mainContext;
}

- (NSManagedObjectContext *)baseContext
{
	if (!_baseContext)
	{
		self.managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:@[[self modelBundle]]];

		self.persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];

		if ([self addStoresToPersistentStoreCoordinator:self.persistentStoreCoordinator])
		{
			self.baseContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
			_baseContext.persistentStoreCoordinator = self.persistentStoreCoordinator;
		}
	}

	return _baseContext;
}

- (void)saveToDisk
{
	[self.mainContext performBlock:^{
		if ([self.mainContext hasChanges])
		{
			NSError *error = nil;
			BOOL saved = [self.mainContext save:&error];
			if (saved)
			{
				DLog(@"Main context saved.");
			}
			else
			{
				ELog(@"Error saving main context: %@, %@", error, [error userInfo]);
				return;
			}
		}
		else
		{
			ILog(@"Main context has no changes to save to disk");
		}

		[self.baseContext performBlock:^{
			if ([self.baseContext hasChanges])
			{
				NSError *error = nil;
				BOOL saved = [self.baseContext save:&error];
				if (saved)
				{
					DLog(@"Base context saved.");
				}
				else
				{
					ELog(@"Error saving base context %@, %@", error, [error userInfo]);
				}
			}
			else
			{
				ILog(@"Base context has no changes to save to disk.");
			}
		}];
	}];
}

- (BOOL)addStoresToPersistentStoreCoordinator:(NSPersistentStoreCoordinator *)coordinator
{
	NSString *configuration = nil;
	NSError *error = nil;
	NSPersistentStore *store = nil;

	if (self.storeURL)
	{
		// Add SQLite store
		NSDictionary *options = @{NSInferMappingModelAutomaticallyOption : @YES, NSMigratePersistentStoresAutomaticallyOption : @YES};

		store = [coordinator addPersistentStoreWithType:NSSQLiteStoreType
										  configuration:configuration
													URL:self.storeURL
												options:options
												  error:&error];
	}
	else
	{
		// Add in-memory store
		store = [coordinator addPersistentStoreWithType:NSInMemoryStoreType
										  configuration:configuration
													URL:nil options:nil error:&error];
	}

	return store != nil;
}

- (NSBundle *)modelBundle
{
	return [NSBundle mainBundle];
}

- (NSURL *)storeDirectory
{
	return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end