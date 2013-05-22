#import "TwelveTwentyToolkit.h"
#import "TTTAbstractPersistenceProxy.h"
#import "TTTLog.h"

#define TT_PERSISTENCE_THRESHOLD_KEY @"TT_PERSISTENCE_THRESHOLD"

@interface TTTAbstractPersistenceProxy ()

@property(nonatomic, strong, readwrite) NSManagedObjectContext *mainContext;
@property(nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property(nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property(nonatomic, strong) NSManagedObjectContext *diskContext;
@property(nonatomic, strong) NSURL *storeURL;
@property(nonatomic) BOOL nestContexts;

@property(nonatomic) BOOL requiresDatabaseSeed;
/**
 * Prevent asynchronous saving on iOS 5 with nested contexts due to Core Data bug
 * http://stackoverflow.com/questions/11786436/core-data-nested-managed-object-contexts-and-frequent-deadlocks-freezes/11900851#11900851
 */
@property(nonatomic) BOOL allowAsynchronousSaving;
@end

@implementation TTTAbstractPersistenceProxy

- (id)initWithStoreName:(NSString *)storeName nestContexts:(BOOL)nestContexts resetThreshold:(int)resetThreshold
{
    self = [super init];

    if (self)
    {
        self.storeURL = [[self storeDirectory] URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite", storeName]];
        [self checkResetThreshold:resetThreshold];

        self.nestContexts = nestContexts;
        self.allowAsynchronousSaving = TTT_SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0");
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
    BOOL reset = (resetThreshold != [defaults integerForKey:key]);
    if (reset)
    {
        [self performResetWithThreshold:resetThreshold];
    }
}

- (void)performResetWithThreshold:(int)resetThreshold
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:self.storeURL.path])
    {
        NSError *error = nil;
        if ([[NSFileManager defaultManager] removeItemAtURL:self.storeURL error:&error])
        {
            ILog(@"Reset store %@", self.storeURL);
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString *key = [NSString stringWithFormat:@"%@-%@", TT_PERSISTENCE_THRESHOLD_KEY, self.storeURL.lastPathComponent];
            [defaults setInteger:resetThreshold forKey:key];
            [defaults synchronize];
        }
        else
        {
            ELog(@"Could not reset store: %@", error);
        }
    }
}

- (NSManagedObjectContext *)threadContext
{
    if ([[NSThread currentThread] isMainThread])
    {
        return self.mainContext;
    }

    return [self newPrivateContext];
}

- (NSManagedObjectContext *)newPrivateContext
{
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy;
    context.undoManager = nil;

    if (self.nestContexts)
    {
        context.parentContext = self.mainContext;
    }
    else
    {
        context.persistentStoreCoordinator = self.persistentStoreCoordinator;
    }

    return context;
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

        if (self.requiresDatabaseSeed)
        {
            [self seedDatabase];
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

- (void)seedDatabase
{
    // override when you want to seed the database after the core data stack is set up.
}

- (BOOL)savePrivateContext:(NSManagedObjectContext *)context
{
    if (context == self.mainContext)
    {
        [self saveToDisk];
        return YES;
    }

    __block BOOL success = NO;

    [context performBlockAndWait:^{
        NSError *error = nil;
        if ([context save:&error])
        {
            [self saveToDisk];
            success = YES;
        }
        else
        {
            ELog(@"Failed to save context: %@", error);
        }
    }];

    return success;
}

- (void)saveToDisk
{
    [self.mainContext performBlockAndWait:^{
        NSAssert([[NSThread currentThread] isMainThread], @"Must run on main thread");
        if ([self.mainContext hasChanges])
        {
            NSError *error = nil;
            BOOL saved = [self.mainContext save:&error];
            if (!saved)
            {
                ELog(@"Error saving main context: %@, %@", error, [error userInfo]);
                return;
            }
        }

        if (self.nestContexts)
        {
            void (^diskSaveBlock)() = ^{
                if ([self.diskContext hasChanges])
                {
                    NSError *error = nil;
                    BOOL saved = [self.diskContext save:&error];
                    if (!saved)
                    {
                        ELog(@"Error saving base context %@, %@", error, [error userInfo]);
                    }
                }
            };

            if (self.allowAsynchronousSaving)
            {
                [self.diskContext performBlock:diskSaveBlock];
            }
            else
            {
                [self.diskContext performBlockAndWait:diskSaveBlock];
            }
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

        self.requiresDatabaseSeed = ![[NSFileManager defaultManager] fileExistsAtPath:self.storeURL.path];

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