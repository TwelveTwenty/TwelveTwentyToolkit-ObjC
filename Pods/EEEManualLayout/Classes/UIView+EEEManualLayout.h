#import <Foundation/Foundation.h>
#import "EEEManualLayout.h"

typedef enum {
    EEEDistributeAlignLeft,
    EEEDistributeAlignCenter,
    EEEDistributeAlignRight
} EEEDistributeAlign;

@interface UIView (TTTLayout)

@property (setter = eee_setOrigin:) CGPoint eee_origin;
@property (setter = eee_setSize:) CGSize eee_size;

- (void)eee_addSubviews:(NSArray *)array;

- (CGRect)eee_resetIntrinsicContentFrame;

- (CGRect)eee_intrinsicContentFrame;

- (CGRect)eee_frameThatFitsWidth:(CGFloat)width;

- (CGRect)eee_distributeViewsHorizontally:(NSArray *)views inFrame:(CGRect)containerFrame withSpacing:(CGFloat)spacing;

- (CGRect)eee_distributeViewsHorizontally:(NSArray *)views inFrame:(CGRect)containerFrame withSpacing:(CGFloat)spacing alignment:(EEEDistributeAlign)alignment;

- (CGRect)eee_distributeViews:(NSArray *)views asRowsInFrame:(CGRect)containerFrame withSpacing:(CGFloat)spacing horizontalAlignment:(EEEDistributeAlign)alignment rowLimit:(int)rowLimit;

- (CGRect)eee_distributeViews:(NSArray *)views asRowsInFrame:(CGRect)containerFrame withSpacing:(CGFloat)spacing horizontalAlignment:(EEEDistributeAlign)alignment rowLimit:(int)rowLimit containerAlignment:(EEECGAlignOption)containerAlignment;

- (NSString *)eee_hierarchy:(NSString *)leading;

@end