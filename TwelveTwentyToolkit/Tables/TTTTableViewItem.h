#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@class TTTTableViewItem;

typedef void (^TTTConfigureItemBlock)(id cell, NSIndexPath *indexPath);
typedef void (^TTTDidSelectItemBlock)(TTTTableViewItem *item, NSIndexPath *indexPath);

@interface TTTTableViewItem : NSObject

@property(nonatomic, strong) Class cellClass;
@property(nonatomic) CGFloat height;
@property(nonatomic, copy) TTTConfigureItemBlock configureBlock;
@property(nonatomic, copy) TTTDidSelectItemBlock didSelectBlock;

+ (TTTTableViewItem *)itemWithCellClass:(Class)cellClass height:(CGFloat)height configure:(TTTConfigureItemBlock)configureBlock didSelect:(TTTDidSelectItemBlock)didSelectBlock;

@end