#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface TTTAbstractManagedObject : NSManagedObject

+ (NSFetchedResultsController *) fetchedResultsControllerWithSortingKeys:(NSDictionary *)sortingKeysWithAscendingFlag
                                                    managedObjectContext:(NSManagedObjectContext *)context
                                                      sectionNameKeyPath:(NSString *)sectionNameKeyPath
                                                               cacheName:(NSString *)cacheName;

+ (NSFetchRequest *)fetchRequestWithSortingKeys:(NSDictionary *)sortingKeysWithAscendingFlag;

@end