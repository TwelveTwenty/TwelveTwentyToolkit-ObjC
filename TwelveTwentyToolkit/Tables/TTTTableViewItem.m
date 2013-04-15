#import "TTTTableViewItem.h"

@implementation TTTTableViewItem

+ (TTTTableViewItem *)itemWithCellClass:(Class)cellClass height:(CGFloat)height configure:(TTTConfigureItemBlock)configureBlock didSelect:(TTTDidSelectItemBlock)didSelectBlock
{
    TTTTableViewItem *item = [[self alloc] init];
    item.cellClass = cellClass;
    item.height = height;
    item.configureBlock = configureBlock;
    item.didSelectBlock = didSelectBlock;
    return item;
}

@end