/**
* Objectives of this class:
* + don't expose the managedObjectContext to the public API
* + allow persistent store flexibility (sqlite, in-memory, etc.)
*/

#import <Foundation/Foundation.h>

@interface TTAbstractCoreDataProxy : NSObject

- (id)init UNAVAILABLE_ATTRIBUTE;

@end

@protocol TTAbstractCoreDataProxyProtected

@optional // they're actually all implemented.

@property (nonatomic, strong, readonly) NSManagedObjectContext *mainContext;

- (id)initWithStoreName:(NSString *)storeName;

- (NSManagedObjectContext *)newPrivateContext;

#pragma mark - Overrideable

- (BOOL)addStoresToPersistentStoreCoordinator:(NSPersistentStoreCoordinator *)coordinator;

- (NSBundle *)modelBundle;

- (NSURL *)storeDirectory;

@end
