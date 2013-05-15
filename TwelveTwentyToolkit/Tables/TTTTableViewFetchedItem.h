#import <Foundation/Foundation.h>
#import "TTTTableViewItem.h"

@class TTTTableViewFetchedItem;

@protocol TTTTableViewFetchedItem <TTTTableViewItem>

- (id<TTTTableViewFetchedItem>)dynamicHeight:(TTTDynamicHeightBlock)heightBlock;
- (id<TTTTableViewFetchedItem>)fixedHeight:(CGFloat)fixedHeight;
- (id<TTTTableViewFetchedItem>)handleDidSelect:(TTTDidSelectItemBlock)didSelectBlock;
- (id<TTTTableViewFetchedItem>)handleWillDisplay:(TTTWillDisplayItemBlock)willDisplayBlock;
- (id<TTTTableViewFetchedItem>)handleDidEndDisplaying:(TTTDidEndDisplayingItemBlock)didEndDisplayingBlock;
- (TTTTableViewFetchedItem *)asFetchedItem;

@end

@interface TTTTableViewFetchedItem : TTTTableViewItem <TTTTableViewFetchedItem>

@property(nonatomic, strong) id fetchedEntity;

+ (id<TTTTableViewFetchedItem>)fetchedItemWithCellClass:(Class)cellClass configure:(TTTConfigureItemBlock)configureBlock;
+ (id<TTTTableViewItem>)itemWithCellClass:(Class)cellClass configure:(TTTConfigureItemBlock)configureBlock UNAVAILABLE_ATTRIBUTE;

@end