#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface NSFetchedResultsController (TTTCacheControl)

- (BOOL)performFetch:(NSError **)error deleteCache:(BOOL)deleteCache;

@end