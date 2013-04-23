#import "UIView+TTTHitTesting.h"

@implementation UIView (TTTHitTesting)

- (BOOL)tttPointInsideSubviews:(CGPoint)point withEvent:(UIEvent *)event
{
    return [self tttPointInsideSubviews:point withEvent:event skipHiddenViews:NO];
}

- (BOOL)tttPointInsideSubviews:(CGPoint)point withEvent:(UIEvent *)event skipHiddenViews:(BOOL)skipHidden
{
    return [self tttPointInsideSubviews:point withEvent:event skipHiddenViews:skipHidden skipViewInSet:nil];
}

- (BOOL)tttPointInsideSubviews:(CGPoint)point withEvent:(UIEvent *)event skipHiddenViews:(BOOL)skipHidden skipViewInSet:(NSSet *)skipSet
{
    NSMutableSet *subviews = [NSMutableSet setWithArray:self.subviews];

    if (skipSet != nil)
    {
        [subviews minusSet:skipSet];
    }

    for (UIView *subview in subviews) {
        CGPoint localPoint = point;
        localPoint.x -= subview.frame.origin.x;
        localPoint.y -= subview.frame.origin.y;

        if (skipHidden)
        {
            if (subview.hidden == NO && subview.alpha > 0 && [subview pointInside:localPoint withEvent:event])
            {
                return YES;
            }
        }
        else {
            if ([subview pointInside:localPoint withEvent:event])
            {
                return YES;
            }
        }
    }

    return NO;
}
@end
