#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@protocol TTTMogeneratorEntity

+ (NSFetchedResultsController *)tttFetchedResultsControllerWithSortingKeys:(NSDictionary *)sortingKeysWithAscendingFlag
                                                      managedObjectContext:(NSManagedObjectContext *)context
                                                        sectionNameKeyPath:(NSString *)sectionNameKeyPath
                                                                 cacheName:(NSString *)cacheName;

+ (NSFetchRequest *)tttFetchRequestWithSortingKeys:(NSDictionary *)sortingKeysWithAscendingFlag;

+ (NSString *)entityName;

@end

@interface TTTAbstractManagedObject : NSManagedObject <TTTMogeneratorEntity>

+ (NSFetchedResultsController *)tttFetchedResultsControllerWithSortingKeys:(NSDictionary *)sortingKeysWithAscendingFlag
                                                      managedObjectContext:(NSManagedObjectContext *)context
                                                        sectionNameKeyPath:(NSString *)sectionNameKeyPath
                                                                 cacheName:(NSString *)cacheName;

+ (NSFetchRequest *)tttFetchRequestWithSortingKeys:(NSDictionary *)sortingKeysWithAscendingFlag;

@end