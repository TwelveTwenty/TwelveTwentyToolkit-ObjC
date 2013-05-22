#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface NSFetchedResultsController (TTTCacheControl)

- (BOOL)tttPerformFetch:(NSError **)error deleteCache:(BOOL)deleteCache;

@end