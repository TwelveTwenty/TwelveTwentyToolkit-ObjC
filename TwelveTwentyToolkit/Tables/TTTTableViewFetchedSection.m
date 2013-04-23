#import <TwelveTwentyToolkit/TTTTableViewItem.h>
#import <CoreData/CoreData.h>
#import "TTTTableViewFetchedSection.h"
#import "NSFetchedResultsController+TTTEasySections.h"
#import "TTTTableViewFetchedItem.h"

@interface TTTTableViewFetchedSection ()

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
    if (self.controller)
    {
        [NSFetchedResultsController deleteCacheWithName:self.controller.cacheName];
        [self.controller performFetch:NULL];
    }
}

- (void)setCellClass:(Class)cellClass height:(CGFloat)height configure:(TTTConfigureItemBlock)configureBlock didSelect:(TTTDidSelectItemBlock)didSelectBlock
{
    self.cellClass = cellClass;
    self.rowHeight = height;
    self.configureBlock = configureBlock;
    self.didSelectBlock = didSelectBlock;
}

- (NSUInteger)count
{
    return [self.controller tttNumberOfObjectsInFirstSection];
}

- (TTTTableViewItem *)itemAtIndex:(NSInteger)index
{
    TTTTableViewFetchedItem *item = self.cachedItems[@(index)];
    if (!item)
    {
        item = [TTTTableViewFetchedItem itemWithCellClass:self.cellClass height:self.rowHeight configure:self.configureBlock didSelect:self.didSelectBlock];
        item.fetchedEntity = [[self.controller tttFirstSection] objects][index];
        self.cachedItems[@(index)] = item;
    }

    return item;
}

- (TTTTableViewItem *)addItem:(TTTTableViewItem *)item
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (void)addItems:(NSArray *)array
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

@end