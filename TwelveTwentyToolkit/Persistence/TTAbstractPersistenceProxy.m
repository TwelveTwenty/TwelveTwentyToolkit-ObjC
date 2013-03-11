#import "TTAbstractPersistenceProxy.h"
#import "TTTLog.h"

#define TT_PERSISTENCE_THRESHOLD_KEY @"TT_PERSISTENCE_THRESHOLD"

@interface TTAbstractPersistenceProxy ()

@property (nonatomic, strong, readwrite) NSManagedObjectContext *mainContext;
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong) NSManagedObjectContext *diskContext;
@property (nonatomic, strong) NSURL *storeURL;
@property (nonatomic) BOOL nestContexts;

@end

@implementation TTAbstractPersistenceProxy

- (id)initWithStoreName:(NSString *)storeName nestContexts:(BOOL)nestContexts resetThreshold:(int)resetThreshold
{
	self = [super init];

	if (self)
	{
		self.storeURL = [[self storeDirectory] URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite", storeName]];
		[self checkResetThreshold:resetThreshold];

		self.nestContexts = nestContexts;
	}

	return self;
}

/**
* If you pass a resetThreshold higher than 0, this method will compare it to a value in the NSUserDefaults.
* If that value does not exist, or if it's lower than the threshold, the existing persistentStore file will be
* deleted. You can use this to ensure an empty store, for example if your model has changed and you want to
* prevent the need for migrating.
*/
- (void)checkResetThreshold:(int)resetThreshold
{
	if (resetThreshold == 0)
	{
		return;
	}

	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSString *key = [NSString stringWithFormat:@"%@-%@", TT_PERSISTENCE_THRESHOLD_KEY, self.storeURL.lastPathComponent];
	BOOL reset = resetThreshold > [defaults integerForKey:key];
	if (reset && [[NSFileManager defaultManager] fileExistsAtPath:self.storeURL.path])
	{
		NSError *error = nil;
		if ([[NSFileManager defaultManager] removeItemAtURL:self.storeURL error:&error])
		{
			ILog(@"Reset store %@", self.storeURL);
			[defaults setInteger:resetThreshold forKey:key];
			[defaults synchronize];
		}
		else
		{
			ELog(@"Could not reset store: %@", error);
		}
	}
}

- (NSManagedObjectContext *)newPrivateContext
{
	NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
	context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy;
	context.parentContext = self.mainContext;
	context.undoManager = nil;

	return context;
}

- (NSManagedObjectModel *)managedObjectModel
{
	if (!_managedObjectModel)
	{
		self.managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:@[[self modelBundle]]];
	}

	return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
	if (!_persistentStoreCoordinator)
	{
		self.persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
		if (![self addStoresToPersistentStoreCoordinator:_persistentStoreCoordinator])
		{
			self.persistentStoreCoordinator = nil;
		}
	}

	return _persistentStoreCoordinator;
}

- (NSManagedObjectContext *)mainContext
{
	if (_mainContext == nil)
	{
		self.mainContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
		_mainContext.mergePolicy = NSOverwriteMergePolicy;
		_mainContext.undoManager = nil;

		if (self.nestContexts)
		{
			_mainContext.parentContext = self.diskContext;
		}
		else
		{
			_mainContext.persistentStoreCoordinator = self.persistentStoreCoordinator;
		}
	}

	return _mainContext;
}

- (NSManagedObjectContext *)diskContext
{
	NSAssert(self.nestContexts, @"Disk context only available when nestContexts is on.");

	if (!_diskContext)
	{
		self.diskContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
		_diskContext.mergePolicy = NSOverwriteMergePolicy;
		_diskContext.undoManager = nil;
		_diskContext.persistentStoreCoordinator = self.persistentStoreCoordinator;
	}

	return _diskContext;
}

- (void)saveToDisk
{
	[self.mainContext performBlockAndWait:^{
		NSAssert([[NSThread currentThread] isMainThread], @"Must run on main thread");
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

		if (self.nestContexts)
		{
			[self.diskContext performBlock:^{
				if ([self.diskContext hasChanges])
				{
					NSError *error = nil;
					BOOL saved = [self.diskContext save:&error];
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
		}
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

	if (store == nil)
	{
		ELog(@"Error adding persistent store: %@", error);
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

/**
* The reset will take place at the next launch. Use for debugging/testing only
*/
- (void)forceReset
{
	NSString *key = [NSString stringWithFormat:@"%@-%@", TT_PERSISTENCE_THRESHOLD_KEY, self.storeURL.lastPathComponent];
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults removeObjectForKey:key];
	[defaults synchronize];

	if (_diskContext == nil)
	{
		[self checkResetThreshold:1];
	}
}

@end