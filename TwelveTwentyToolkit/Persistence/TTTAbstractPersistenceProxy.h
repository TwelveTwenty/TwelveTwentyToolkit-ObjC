/**
* Objectives of this class:
* + don't expose the managedObjectContext to the public API
* + allow persistent store flexibility (sqlite, in-memory, etc.)
* + return NSFetchedResultsControllers wherever possible, for handling store changes
*/

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface TTTAbstractPersistenceProxy : NSObject

@property (nonatomic, strong, readonly) NSURL *storeURL;
@property (nonatomic, strong, readonly) NSManagedObjectContext *mainContext;

- (id)initWithStoreName:(NSString *)storeName nestContexts:(BOOL)nestContexts resetThreshold:(int)resetThreshold;

- (id)init UNAVAILABLE_ATTRIBUTE;

- (NSManagedObjectContext *)newPrivateContext;

- (void)saveToDisk;

- (void)forceReset;

#pragma mark - Overrideable

- (void)seedDatabase;

- (BOOL)addStoresToPersistentStoreCoordinator:(NSPersistentStoreCoordinator *)coordinator;

- (NSBundle *)modelBundle;

- (NSURL *)storeDirectory;

@end
