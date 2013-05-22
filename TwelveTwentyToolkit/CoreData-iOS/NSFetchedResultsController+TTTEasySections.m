#import "NSFetchedResultsController+TTTEasySections.h"
#import <CoreData/CoreData.h>

@implementation NSFetchedResultsController (TTTEasySections)

- (id <NSFetchedResultsSectionInfo>)tttSectionAtIndex:(NSUInteger)sectionIndex
{
    return [self.sections count] > sectionIndex ? self.sections[sectionIndex] : nil;
}

- (id <NSFetchedResultsSectionInfo>)tttFirstSection
{
    return [self tttSectionAtIndex:0];
}

- (NSUInteger)tttNumberOfObjectsInFirstSection
{
    id <NSFetchedResultsSectionInfo> firstSection = [self tttFirstSection];
    return [firstSection numberOfObjects];
}

- (NSArray *)tttObjects
{
    id <NSFetchedResultsSectionInfo> firstSection = [self tttFirstSection];
    return [firstSection objects];
}

- (id)tttFirstObjectInFirstSection
{
    NSArray *objects = [self tttObjects];
    return [objects count] > 0 ? objects[0] : nil;
}

@end