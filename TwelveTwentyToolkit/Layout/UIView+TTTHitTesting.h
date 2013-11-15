#import <UIKit/UIKit.h>

@interface UIView (TTTHitTesting)

/**
 Use this method inside a UIView's `pointInside:withEvent:` method to determine
 whether the point clicked belongs to any of the subviews, instead of merely hittesting
 the superview's frame.
 */
- (BOOL)ttt_pointInsideSubviews:(CGPoint)point withEvent:(UIEvent *)event;

- (BOOL)ttt_pointInsideSubviews:(CGPoint)point withEvent:(UIEvent *)event skipHiddenViews:(BOOL)skipHidden;

- (BOOL)ttt_pointInsideSubviews:(CGPoint)point withEvent:(UIEvent *)event skipHiddenViews:(BOOL)skipHidden skipViewInSet:(NSSet *)skipSet;

@end
