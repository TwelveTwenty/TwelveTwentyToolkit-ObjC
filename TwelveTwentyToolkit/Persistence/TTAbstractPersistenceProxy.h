/**
* Objectives of this class:
* + don't expose the managedObjectContext to the public API
* + allow persistent store flexibility (sqlite, in-memory, etc.)
* + return NSFetchedResultsControllers wherever possible, for handling store changes
*/

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@protocol TTAbstractPersistenceProxy <NSObject>


@end


@interface TTAbstractPersistenceProxy : NSObject <TTAbstractPersistenceProxy>

- (id)initWithStoreName:(NSString *)storeName nestContexts:(BOOL)nestContexts resetThreshold:(int)resetThreshold;

- (id)init UNAVAILABLE_ATTRIBUTE;

- (void)saveToDisk;

- (void)forceReset;

#pragma mark - private API

@property (nonatomic, strong, readonly) NSURL *storeURL;
@property (nonatomic, strong, readonly) NSManagedObjectContext *mainContext;

- (NSManagedObjectContext *)newPrivateContext;

#pragma mark - Overrideable

- (BOOL)addStoresToPersistentStoreCoordinator:(NSPersistentStoreCoordinator *)coordinator;

- (NSBundle *)modelBundle;

- (NSURL *)storeDirectory;

@end
