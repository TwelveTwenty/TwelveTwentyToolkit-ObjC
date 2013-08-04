#import "TTTTableViewItem.h"
#import <CoreData/CoreData.h>
#import <TwelveTwentyToolkit/NSFetchedResultsController+TTTCacheControl.h>
#import "TTTTableViewItemController.h"
#import "TTTTableViewFetchedSection.h"
#import "NSFetchedResultsController+TTTEasySections.h"
#import "TTTTableViewFetchedItem.h"
#import "TTTLog.h"

@interface TTTTableViewFetchedSection () <NSFetchedResultsControllerDelegate>

@property(nonatomic, strong) NSCache *cachedItems;

@property(nonatomic, copy) TTTConfigureItemBlock configureBlock;
@property(nonatomic, copy) TTTDidSelectItemBlock didSelectBlock;
@property(nonatomic, copy) TTTDynamicHeightBlock dynamicHeightBlock;

@end

@implementation TTTTableViewFetchedSection

+ (id <TTTTableViewFetchedSection>)fetchedSectionWithCellClass:(Class)cellClass configureBlock:(TTTConfigureItemBlock)configureBlock
{
    TTTTableViewFetchedSection *section = [[self alloc] init];

    section.configureBlock = configureBlock;
    section.cellClass = cellClass;

    return section;
}

- (TTTTableViewFetchedSection *)asFetchedSection
{
    return self;
}

- (id)init
{
    self = [super init];

    if (self)
    {
        self.cachedItems = [[NSCache alloc] init];
    }

    return self;
}

- (void)setIndex:(NSInteger)index
{
    [super setIndex:index];

    [self.cachedItems removeAllObjects];
}

- (id <TTTTableViewFetchedSection>)fixedRowHeight:(CGFloat)fixedRowHeight
{
    self.rowHeight = fixedRowHeight;
    return self;
}

- (id <TTTTableViewFetchedSection>)dynamicRowHeight:(TTTDynamicHeightBlock)dynamicHeightBlock
{
    self.dynamicHeightBlock = dynamicHeightBlock;
    self.rowHeight = TTTUseDynamicHeight;
    return self;
}

- (id <TTTTableViewFetchedSection>)handleDidSelect:(TTTDidSelectItemBlock)didSelectBlock
{
    self.didSelectBlock = didSelectBlock;
    return self;
}

- (id <TTTTableViewFetchedSection>)configure:(TTTConfigureItemBlock)configureBlock
{
    self.configureBlock = configureBlock;
    return self;
}

- (void)setFetchedResultsController:(NSFetchedResultsController *)fetchedResultsController
{
    _fetchedResultsController = fetchedResultsController;

    [fetchedResultsController tttPerformFetch:NULL deleteCache:YES];

    [self.itemController sectionDidReload:self];

    fetchedResultsController.delegate = self;
}

- (NSUInteger)numberOfItems
{
    NSUInteger number = [self.fetchedResultsController tttNumberOfObjectsInFirstSection];

    if (number)
    {
        if (self.fetchedResultsController.fetchRequest.fetchLimit)
        {
            return MIN(self.fetchedResultsController.fetchRequest.fetchLimit, number);
        }

        return number;
    }

    return [super numberOfItems];
}

- (Class)cellClassForItemAtIndex:(NSInteger)index
{
    return self.cellClass;
}

- (TTTTableViewItem *)itemAtIndex:(NSInteger)index
{
    if ([self.fetchedResultsController tttNumberOfObjectsInFirstSection])
    {
        TTTTableViewFetchedItem *item = [self.cachedItems objectForKey:@(index)];
        if (!item)
        {
            item = [[TTTTableViewFetchedItem fetchedItemWithCellClass:[self cellClassForItemAtIndex:index] configure:self.configureBlock] asFetchedItem];
            item.indexPath = [NSIndexPath indexPathForRow:index inSection:self.index];
            [item fixedHeight:self.rowHeight];
            [item dynamicHeight:self.dynamicHeightBlock];
            [item handleDidSelect:self.didSelectBlock];

            NSArray *objects = [[self.fetchedResultsController tttFirstSection] objects];
            if (index < 0) return nil;
            if (index >= [objects count]) return nil;
            item.fetchedEntity = objects[(NSUInteger) index];
            [self.cachedItems setObject:item forKey:@(index)];
        }

        return item;
    }

    return [super itemAtIndex:index];
}

#pragma mark - NSFetchedResultsController delegate methods

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.cachedItems removeAllObjects];

    [self.itemController sectionWillBeginChanges:self];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    NSIndexPath *convertedIndexPath = indexPath ? [NSIndexPath indexPathForRow:indexPath.row inSection:self.index] : nil;
    NSIndexPath *convertedNewIndexPath = newIndexPath ? [NSIndexPath indexPathForRow:newIndexPath.row inSection:self.index] : nil;

    switch (type)
    {
        case NSFetchedResultsChangeInsert:
            if (self.fetchedResultsController.fetchRequest.fetchLimit)
            {
                NSUInteger numItems = [self numberOfItems];
                if (numItems == self.fetchedResultsController.fetchRequest.fetchLimit)
                {
                    if (convertedNewIndexPath.row < numItems)
                    {
//                        [self.itemController sectionDidDeleteRowAtIndexPath:[NSIndexPath indexPathForRow:numItems - 1 inSection:convertedNewIndexPath.section]];
                        // then continue to insert the new index path.
                    }
                    else
                    {
                        // insert would take place beyond fetch limit bounds, so it is ignored.
                        break;
                    }
                }
            }

            [self.itemController sectionDidInsertRowAtIndexPath:convertedNewIndexPath];
            break;

        case NSFetchedResultsChangeDelete:
            [self.itemController sectionDidDeleteRowAtIndexPath:convertedIndexPath];
            break;

        case NSFetchedResultsChangeUpdate:
            [self.itemController sectionDidUpdateRowAtIndexPath:convertedIndexPath];
            break;

        case NSFetchedResultsChangeMove:
        {
            [self.itemController sectionDidDeleteRowAtIndexPath:convertedIndexPath];
            [self.itemController sectionDidInsertRowAtIndexPath:convertedNewIndexPath];
            break;
        }
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.itemController sectionDidEndChanges:self];
}

@end