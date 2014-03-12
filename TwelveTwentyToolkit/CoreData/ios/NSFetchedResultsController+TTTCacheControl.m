#import "NSFetchedResultsController+TTTCacheControl.h"
#import <CoreData/CoreData.h>

@implementation NSFetchedResultsController (TTTCacheControl)

- (BOOL)ttt_performFetch:(NSError **)error deleteCache:(BOOL)deleteCache
{
    if (deleteCache)
    {
        [[self class] deleteCacheWithName:self.cacheName];
    }

    return [self performFetch:error];
}

@end