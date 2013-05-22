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

@property(nonatomic, copy) TTTConfigureItemBlock configureBlock;
@property(nonatomic, copy) TTTDidSelectItemBlock didSelectBlock;

@property(nonatomic, copy) TTTDynamicHeightBlock dynamicHeightBlock;
@end

@implementation TTTTableViewFetchedSection

+ (id <TTTTableViewFetchedSection>)fetchedSectionWithCellClass:(Class)cellClass configureBlock:(TTTConfigureItemBlock)configureBlock
{
    return [[self alloc] initWithCellClass:cellClass configureBlock:configureBlock];
}

- (TTTTableViewFetchedSection *)asFetchedSection
{
    return self;
}

- (id)initWithCellClass:(Class)cellClass configureBlock:(TTTConfigureItemBlock)configureBlock
{
    self = [self init];

    if (self)
    {
        self.configureBlock = configureBlock;
        self.cellClass = cellClass;
    }

    return self;
}

- (id)init
{
    self = [super init];

    if (self)
    {
        self.cachedItems = [NSMutableDictionary dictionary];
    }

    return self;
}

- (void)setIndex:(NSInteger)index
{
    [super setIndex:index];

    self.cachedItems = [NSMutableDictionary dictionary];
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
            item = [[TTTTableViewFetchedItem fetchedItemWithCellClass:self.cellClass configure:self.configureBlock] asFetchedItem];
            [item fixedHeight:self.rowHeight];
            [item dynamicHeight:self.dynamicHeightBlock];
            [item handleDidSelect:self.didSelectBlock];

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

    [self.itemController sectionWillBeginChanges:self];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    NSIndexPath *convertedIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:self.index];
    NSIndexPath *convertedNewIndexPath = [NSIndexPath indexPathForRow:newIndexPath.row inSection:self.index];

    switch (type)
    {

        case NSFetchedResultsChangeInsert:
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