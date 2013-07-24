#import <CoreGraphics/CoreGraphics.h>
#import "TTTTableViewSection.h"
#import "TTTTableViewItemController.h"

@interface TTTTableViewSection ()

@property(nonatomic, strong) NSMutableArray *items;

@end

@implementation TTTTableViewSection

+ (id)section
{
    return [[self alloc] init];
}

- (TTTTableViewSection *)asSection
{
    return self;
}

- (id)init
{
    self = [super init];

    if (self)
    {
        self.index = -1;
        self.items = [NSMutableArray array];
        self.headerHeight = 0;
    }

    return self;
}

- (void)setIndex:(NSInteger)index
{
    _index = index;

    [self.items enumerateObjectsUsingBlock:^(TTTTableViewItem *item, NSUInteger idx, BOOL *stop) {
        [item setIndexPath:[NSIndexPath indexPathForRow:idx inSection:index]];
    }];
}

- (NSIndexSet *)indexSet
{
    return [NSIndexSet indexSetWithIndex:(NSUInteger) self.index];
}

- (NSArray *)indexPaths
{
    NSUInteger numberOfItems = self.numberOfItems;
    if (!numberOfItems) return nil;

    NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:numberOfItems];

    for (NSUInteger row = 0; row < numberOfItems; ++row)
    {
        [indexPaths addObject:[NSIndexPath indexPathForRow:row inSection:self.index]];
    }

    return indexPaths;
}

- (NSUInteger)numberOfItems
{
    return [self.items count];
}

- (id <TTTTableViewItem>)addItem:(id <TTTTableViewItem>)item
{
    [self.items addObject:item];
    [(TTTTableViewItem *)item setIndexPath:[NSIndexPath indexPathForRow:[self.items count] - 1 inSection:self.index]];
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

- (CGFloat)headerHeight
{
    if (!_headerHeight)
    {
        if (_headerView)
        {
            // Not calling self.headerView, to prevent creation of the header block.
            _headerHeight = _headerView.frame.size.height;
        }
    }

    return _headerHeight;
}

- (UIView *)headerView
{
    if (!_headerView && self.headerViewBlock)
    {
        self.headerView = self.headerViewBlock(self);
    }
    
    return _headerView;
}

- (CGFloat)footerHeight
{
    if (_footerHeight) return _footerHeight;

    if (self.footerView) return self.footerView.frame.size.height;

    return 0;
}

- (UIView *)footerView
{
    if (!_footerView && self.footerViewBlock)
    {
        self.footerView = self.footerViewBlock(self);
    }

    return _footerView;
}

- (NSString *)description
{
    NSMutableString *description = [NSMutableString stringWithFormat:@"<%@:", NSStringFromClass([self class])];

    [description appendFormat:@" index=\"%i\" rows=\"%i\" title=\"%@\"", self.index, self.numberOfItems, self.title];

    [description appendFormat:@" %p>", &self];
    return description;
}

@end