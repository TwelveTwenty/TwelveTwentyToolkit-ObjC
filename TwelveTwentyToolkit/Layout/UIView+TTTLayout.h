#import <Foundation/Foundation.h>
#import "TTTCGUtils.h"

typedef enum {
    TTTDistributeAlignLeft,
    TTTDistributeAlignCenter,
    TTTDistributeAlignRight
} TTTDistributeAlign;

@interface UIView (TTTLayout)

@property (setter = ttt_setOrigin:) CGPoint ttt_origin;
@property (setter = ttt_setSize:) CGSize ttt_size;

- (void)ttt_addSubviews:(NSArray *)array;

- (CGRect)ttt_resetIntrinsicContentFrame;

- (CGRect)ttt_intrinsicContentFrame;

- (CGRect)ttt_frameThatFitsWidth:(CGFloat)width;

- (CGRect)ttt_distributeViewsHorizontally:(NSArray *)views inFrame:(CGRect)containerFrame withSpacing:(CGFloat)spacing;

- (CGRect)ttt_distributeViewsHorizontally:(NSArray *)views inFrame:(CGRect)containerFrame withSpacing:(CGFloat)spacing alignment:(TTTDistributeAlign)alignment;

- (CGRect)ttt_distributeViews:(NSArray *)views asRowsInFrame:(CGRect)containerFrame withSpacing:(CGFloat)spacing horizontalAlignment:(TTTDistributeAlign)alignment rowLimit:(int)rowLimit;

- (CGRect)ttt_distributeViews:(NSArray *)views asRowsInFrame:(CGRect)containerFrame withSpacing:(CGFloat)spacing horizontalAlignment:(TTTDistributeAlign)alignment rowLimit:(int)rowLimit containerAlignment:(TTTCGAlignOption)containerAlignment;

- (NSString *)ttt_hierarchy:(NSString *)leading;

@end