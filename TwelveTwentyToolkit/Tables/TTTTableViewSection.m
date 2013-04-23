#import "TTTTableViewSection.h"
#import "TTTTableViewItem.h"

@interface TTTTableViewSection ()

@property(nonatomic, strong) NSMutableArray *items;

@end

@implementation TTTTableViewSection

- (id)initWithIndex:(NSInteger)index
{
    self = [super init];

    if (self)
    {
        self.index = index;
        self.items = [NSMutableArray array];
        self.headerHeight = -1;
    }

    return self;
}

- (void)reloadData
{
    // void
}

- (NSUInteger)count
{
    return [self.items count];
}

- (TTTTableViewItem *)addItem:(TTTTableViewItem *)item
{
    [self.items addObject:item];
    item.indexPath = [NSIndexPath indexPathForRow:[self.items count] - 1 inSection:self.index]; 
    return item;
}

- (TTTTableViewItem *)itemAtIndex:(NSInteger)index
{
    if (index >= [self.items count]) return nil;
    if (index < 0) return nil;
    return [self.items objectAtIndex:(NSUInteger)index];
}

- (void)addItems:(NSArray *)array
{
    for (TTTTableViewItem *item in array)
    {
        [self addItem:item];
    }
}

@end