#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@class TTTTableViewItem;

typedef void (^TTTConfigureItemBlock)(id item, id cell, NSIndexPath *indexPath);
typedef void (^TTTDidSelectItemBlock)(id item, NSIndexPath *indexPath);
typedef void (^TTTWillDisplayItemBlock)(id item, id cell, NSIndexPath *indexPath);
typedef void (^TTTDidEndDisplayingItemBlock)(id item, id cell, NSIndexPath *indexPath);

@interface TTTTableViewItem : NSObject

@property(nonatomic, strong) Class cellClass;
@property(nonatomic) CGFloat height;
@property(nonatomic, strong) NSIndexPath *indexPath;
@property(nonatomic, copy) TTTConfigureItemBlock configureBlock;
@property(nonatomic, copy) TTTDidSelectItemBlock didSelectBlock;
@property(nonatomic, copy) TTTWillDisplayItemBlock willDisplayBlock;
@property(nonatomic, copy) TTTDidEndDisplayingItemBlock didEndDisplayingBlock;

+ (id)itemWithCellClass:(Class)cellClass height:(CGFloat)height configure:(TTTConfigureItemBlock)configureBlock didSelect:(TTTDidSelectItemBlock)didSelectBlock;

@end