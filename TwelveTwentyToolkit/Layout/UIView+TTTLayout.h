#import <Foundation/Foundation.h>
#import "TTCGUtils.h"

typedef enum {
    TTTDistributeAlignLeft,
    TTTDistributeAlignCenter,
    TTTDistributeAlignRight
} TTTDistributeAlign;

@interface UIView (TTTLayout)

@property (setter = tttSetOrigin:) CGPoint tttOrigin;
@property (setter = tttSetSize:) CGSize tttSize;

- (void)tttAddSubviews:(NSArray *)array;

- (CGRect)tttResetIntrinsicContentFrame;

- (CGRect)tttIntrinsicContentFrame;

- (CGRect)tttDistributeViewsHorizontally:(NSArray *)views inFrame:(CGRect)containerFrame withSpacing:(CGFloat)spacing;

- (CGRect)tttDistributeViewsHorizontally:(NSArray *)views inFrame:(CGRect)containerFrame withSpacing:(CGFloat)spacing alignment:(TTTDistributeAlign)alignment;

- (CGRect)tttDistributeViews:(NSArray *)views asRowsInFrame:(CGRect)containerFrame withSpacing:(CGFloat)spacing horizontalAlignment:(TTTDistributeAlign)alignment rowLimit:(int)rowLimit;

- (CGRect)tttDistributeViews:(NSArray *)views asRowsInFrame:(CGRect)containerFrame withSpacing:(CGFloat)spacing horizontalAlignment:(TTTDistributeAlign)alignment rowLimit:(int)rowLimit containerAlignment:(CGAlignOption)containerAlignment;

- (NSString *)tttHierarchy:(NSString *)leading;

@end