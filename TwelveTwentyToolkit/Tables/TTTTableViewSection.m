#import <CoreGraphics/CoreGraphics.h>
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
        self.headerHeight = 0;
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

- (CGFloat)headerHeight
{
    if (_headerHeight) return _headerHeight;

    if (self.headerView) return self.headerView.frame.size.height;

    return 0;
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

@end