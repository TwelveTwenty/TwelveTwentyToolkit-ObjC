#import "NSFetchedResultsController+TTTEasySections.h"

@implementation NSFetchedResultsController (TTTEasySections)

- (id <NSFetchedResultsSectionInfo>)ttt_sectionAtIndex:(NSUInteger)sectionIndex
{
    return [self.sections count] > sectionIndex ? self.sections[sectionIndex] : nil;
}

- (id <NSFetchedResultsSectionInfo>)ttt_firstSection
{
    return [self ttt_sectionAtIndex:0];
}

- (NSUInteger)ttt_numberOfObjectsInFirstSection
{
    id <NSFetchedResultsSectionInfo> firstSection = [self ttt_firstSection];
    return [firstSection numberOfObjects];
}

- (NSArray *)ttt_objects
{
    id <NSFetchedResultsSectionInfo> firstSection = [self ttt_firstSection];
    return [firstSection objects];
}

- (id)ttt_firstObjectInFirstSection
{
    NSArray *objects = [self ttt_objects];
    return [objects count] > 0 ? objects[0] : nil;
}

@end