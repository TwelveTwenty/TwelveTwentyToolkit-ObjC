#import <TwelveTwentyToolkit/TTTTableViewItem.h>
#import <CoreData/CoreData.h>
#import <TwelveTwentyToolkit/TTTTableViewItemController.h>
#import "TTTTableViewFetchedSection.h"
#import "NSFetchedResultsController+TTTEasySections.h"
#import "TTTTableViewFetchedItem.h"
#import "TTTLog.h"

@interface TTTTableViewFetchedSection () <NSFetchedResultsControllerDelegate>

@property(nonatomic, strong) NSMutableDictionary *cachedItems;

@property(nonatomic, strong) Class cellClass;
@property(nonatomic) CGFloat rowHeight;
@property(nonatomic, copy) TTTConfigureItemBlock configureBlock;
@property(nonatomic, copy) TTTDidSelectItemBlock didSelectBlock;

@end

@implementation TTTTableViewFetchedSection

- (id)initWithIndex:(NSInteger)index1
{
    self = [super initWithIndex:index];

    if (self)
    {
        [self reloadData];
    }

    return self;
}

- (void)reloadData
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

    fetchedResultsController.delegate = self;
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    DLog(@"Controller first item: %@", controller.tttFirstObjectInFirstSection);
    [self.itemController reloadData];
}

- (NSUInteger)count
{
    if (self.fetchedResultsController)
    {
        return [self.fetchedResultsController tttNumberOfObjectsInFirstSection];
    }

    return [super count];
}

- (TTTTableViewItem *)itemAtIndex:(NSInteger)index
{
    if (self.fetchedResultsController)
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

@end