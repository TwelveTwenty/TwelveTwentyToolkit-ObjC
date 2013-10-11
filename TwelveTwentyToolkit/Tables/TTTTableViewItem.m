#import "TTTTableViewItem.h"

CGFloat const TTTUseDynamicHeight = 0;

@interface TTTTableViewItem ()

@property (nonatomic, copy) TTTDynamicHeightBlock heightBlock;

@property(nonatomic, copy, readwrite) TTTConfigureItemBlock configureBlock;

@property(nonatomic, copy, readwrite) TTTDidSelectItemBlock didSelectBlock;

@property(nonatomic, copy, readwrite) TTTWillDisplayItemBlock willDisplayBlock;

@property(nonatomic, copy, readwrite) TTTDidEndDisplayingItemBlock didEndDisplayingBlock;

@property(nonatomic, strong, readwrite) Class cellClass;

- (id)initWithCellClass:(Class)cellClass configureBlock:(TTTConfigureItemBlock)configureBlock;

@end

@implementation TTTTableViewItem

+ (id)itemWithCellClass:(Class)cellClass
              configure:(TTTConfigureItemBlock)configureBlock
            fixedHeight:(CGFloat)height
              didSelect:(TTTDidSelectItemBlock)didSelectBlock
{
    TTTTableViewItem *item = [[self alloc] initWithCellClass:cellClass configureBlock:configureBlock];
    item.height = height;
    item.didSelectBlock = didSelectBlock;
    return item;
}

+ (id <TTTTableViewItem>)itemWithCellClass:(Class)cellClass configure:(TTTConfigureItemBlock)configureBlock
{
    TTTTableViewItem *item = [[self alloc] initWithCellClass:cellClass configureBlock:configureBlock];
    return item;
}

- (id)initWithCellClass:(Class)cellClass configureBlock:(TTTConfigureItemBlock)configureBlock
{
    self = [super init];

    if (self)
    {
        self.cellClass = cellClass;
        self.configureBlock = configureBlock;
        self.height = TTTUseDynamicHeight;
    }

    return self;
}

- (TTTTableViewItem *)asItem
{
    return self;
}

- (CGFloat)resetHeight
{
    self.height = TTTUseDynamicHeight;
    return self.height;
}

- (CGFloat)height
{
    if (_height == TTTUseDynamicHeight && self.heightBlock)
    {
        NSAssert(self.indexPath, @"Can't call block without index path");
        return self.heightBlock(self, self.indexPath);
    }

    return _height;
}

#pragma mark - Linting methods

- (id <TTTTableViewItem>)dynamicHeight:(TTTDynamicHeightBlock)heightBlock
{
    self.heightBlock = heightBlock;
    return self;
}

- (id <TTTTableViewItem>)fixedHeight:(CGFloat)fixedHeight
{
    self.height = fixedHeight;
    return self;
}

- (id <TTTTableViewItem>)handleDidSelect:(TTTDidSelectItemBlock)didSelectBlock
{
    self.didSelectBlock = didSelectBlock;
    return self;
}

- (id <TTTTableViewItem>)handleWillDisplay:(TTTWillDisplayItemBlock)willDisplayBlock
{
    self.willDisplayBlock = willDisplayBlock;
    return self;
}

- (id <TTTTableViewItem>)handleDidEndDisplaying:(TTTDidEndDisplayingItemBlock)didEndDisplayingBlock
{
    self.didEndDisplayingBlock = didEndDisplayingBlock;
    return self;
}

- (id <TTTTableViewItem>)tag:(NSInteger)tag
{
    self.tag = tag;
    return self;
}

@end