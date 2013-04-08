#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@protocol TTTMogeneratorEntity

+ (NSFetchedResultsController *) fetchedResultsControllerWithSortingKeys:(NSDictionary *)sortingKeysWithAscendingFlag
                                                    managedObjectContext:(NSManagedObjectContext *)context
                                                      sectionNameKeyPath:(NSString *)sectionNameKeyPath
                                                               cacheName:(NSString *)cacheName;

+ (NSFetchRequest *)fetchRequestWithSortingKeys:(NSDictionary *)sortingKeysWithAscendingFlag;

+ (NSString *)entityName;

@end

@interface TTTAbstractManagedObject : NSManagedObject <TTTMogeneratorEntity>

+ (NSFetchedResultsController *) fetchedResultsControllerWithSortingKeys:(NSDictionary *)sortingKeysWithAscendingFlag
                                                    managedObjectContext:(NSManagedObjectContext *)context
                                                      sectionNameKeyPath:(NSString *)sectionNameKeyPath
                                                               cacheName:(NSString *)cacheName;

+ (NSFetchRequest *)fetchRequestWithSortingKeys:(NSDictionary *)sortingKeysWithAscendingFlag;

@end