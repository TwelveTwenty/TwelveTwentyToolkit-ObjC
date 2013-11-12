#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@class TTTTableViewItem;

typedef CGFloat (^TTTDynamicHeightBlock)(id item, NSIndexPath *indexPath);
typedef void (^TTTConfigureItemBlock)(id item, id cell, NSIndexPath *indexPath);
typedef void (^TTTDidSelectItemBlock)(id item, NSIndexPath *indexPath);
typedef void (^TTTWillDisplayItemBlock)(id item, id cell, NSIndexPath *indexPath);
typedef void (^TTTDidEndDisplayingItemBlock)(id item, id cell, NSIndexPath *indexPath);

extern CGFloat const TTTUseDynamicHeight;

@protocol TTTFixedHeight
+ (CGFloat)fixedHeight;
@end

@protocol TTTTableViewItem

#pragma mark - Linting methods
- (id<TTTTableViewItem>)dynamicHeight:(TTTDynamicHeightBlock)heightBlock;
- (id<TTTTableViewItem>)fixedHeight:(CGFloat)fixedHeight;
- (id<TTTTableViewItem>)handleDidSelect:(TTTDidSelectItemBlock)didSelectBlock;
- (id<TTTTableViewItem>)handleWillDisplay:(TTTWillDisplayItemBlock)willDisplayBlock;
- (id<TTTTableViewItem>)handleDidEndDisplaying:(TTTDidEndDisplayingItemBlock)didEndDisplayingBlock;
- (id<TTTTableViewItem>)tag:(NSInteger)tag;
- (id <TTTTableViewItem>)context:(id)context;
- (TTTTableViewItem *)asItem;

@end

@interface TTTTableViewItem : NSObject <TTTTableViewItem>

@property(nonatomic, strong) id context;
@property(nonatomic) NSInteger tag;
@property(nonatomic) CGFloat height;
@property(nonatomic, strong) NSIndexPath *indexPath;
@property(nonatomic, strong, readonly) Class cellClass;
@property(nonatomic, copy, readonly) TTTConfigureItemBlock configureBlock;
@property(nonatomic, copy, readonly) TTTDidSelectItemBlock didSelectBlock;
@property(nonatomic, copy, readonly) TTTWillDisplayItemBlock willDisplayBlock;
@property(nonatomic, copy, readonly) TTTDidEndDisplayingItemBlock didEndDisplayingBlock;

+ (id<TTTTableViewItem>)itemWithCellClass:(Class)cellClass configure:(TTTConfigureItemBlock)configureBlock;

- (id)init UNAVAILABLE_ATTRIBUTE; // Use +itemWithCellClass:configureBlock: instead.

#pragma mark - Rest

- (CGFloat)resetHeight;

@end