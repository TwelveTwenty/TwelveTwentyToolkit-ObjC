#import "TTTTableViewItem.h"
#import <CoreData/CoreData.h>
#import <TwelveTwentyToolkit/NSFetchedResultsController+TTTCacheControl.h>
#import "TTTTableViewItemController.h"
#import "TTTTableViewFetchedSection.h"
#import "NSFetchedResultsController+TTTEasySections.h"
#import "TTTTableViewFetchedItem.h"
#import "TTTLog.h"

@interface TTTTableViewFetchedSection () <NSFetchedResultsControllerDelegate>

@property(nonatomic, strong) NSMutableDictionary *cachedItems;

@property(nonatomic, strong) Class cellClass;
@property(nonatomic, copy) TTTConfigureItemBlock configureBlock;
@property(nonatomic, copy) TTTDidSelectItemBlock didSelectBlock;

@end

@implementation TTTTableViewFetchedSection

- (id)init
{
    self = [super init];

    if (self)
    {
        [self loadSection];
    }

    return self;
}

- (void)loadSection
{
    self.cachedItems = [NSMutableDictionary dictionary];
    if (self.fetchedResultsController)
    {
        [NSFetchedResultsController deleteCacheWithName:self.fetchedResultsController.cacheName];
        [self.fetchedResultsController performFetch:NULL];
    }
}

- (void)setCellClass:(Class)cellClass height:(CGFloat)height configure:(TTTConfigureItemBlock)configureBlock didSelect:(TTTDidSelectItemBlock)didSelectBlock
{
    self.cellClass = cellClass;
    self.rowHeight = height;
    self.configureBlock = configureBlock;
    self.didSelectBlock = didSelectBlock;
}

- (void)setFetchedResultsController:(NSFetchedResultsController *)fetchedResultsController
{
    _fetchedResultsController = fetchedResultsController;

    [fetchedResultsController performFetch:NULL];

    [self.delegate sectionDidReload:self];

    fetchedResultsController.delegate = self;
}

- (NSUInteger)numberOfItems
{
    if ([self.fetchedResultsController tttNumberOfObjectsInFirstSection])
    {
        return [self.fetchedResultsController tttNumberOfObjectsInFirstSection];
    }

    return [super numberOfItems];
}

- (TTTTableViewItem *)itemAtIndex:(NSInteger)index
{
    if ([self.fetchedResultsController tttNumberOfObjectsInFirstSection])
    {
        TTTTableViewFetchedItem *item = self.cachedItems[@(index)];
        if (!item)
        {
            item = [TTTTableViewFetchedItem itemWithCellClass:self.cellClass height:self.rowHeight configure:self.configureBlock didSelect:self.didSelectBlock];
            NSArray *objects = [[self.fetchedResultsController tttFirstSection] objects];
            if (index < 0) return nil;
            if (index >= [objects count]) return nil;
            item.fetchedEntity = objects[index];
            self.cachedItems[@(index)] = item;
        }

        return item;
    }

    return [super itemAtIndex:index];
}

#pragma mark - NSFetchedResultsController delegate methods

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    self.cachedItems = [NSMutableDictionary dictionary];

    [self.delegate sectionWillBeginChanges:self];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    NSIndexPath *convertedIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:self.index];
    NSIndexPath *convertedNewIndexPath = [NSIndexPath indexPathForRow:newIndexPath.row inSection:self.index];

    switch (type)
    {

        case NSFetchedResultsChangeInsert:
            [self.delegate sectionDidInsertRowAtIndexPath:convertedNewIndexPath];
            break;

        case NSFetchedResultsChangeDelete:
            [self.delegate sectionDidDeleteRowAtIndexPath:convertedIndexPath];
            break;

        case NSFetchedResultsChangeUpdate:
            [self.delegate sectionDidUpdateRowAtIndexPath:convertedIndexPath];
            break;

        case NSFetchedResultsChangeMove:
        {
            [self.delegate sectionDidDeleteRowAtIndexPath:convertedIndexPath];
            [self.delegate sectionDidInsertRowAtIndexPath:convertedNewIndexPath];
            break;
        }
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.delegate sectionDidEndChanges:self];
}

@end