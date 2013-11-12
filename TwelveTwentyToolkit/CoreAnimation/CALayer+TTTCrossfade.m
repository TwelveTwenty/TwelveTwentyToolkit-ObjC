#import "CALayer+TTTCrossfade.h"

@implementation CALayer (TTTCrossfade)

- (void)ttt_transitionCrossfadeWithDuration:(CFTimeInterval)duration
{
    CATransition *transition = [CATransition animation];
    transition.duration = duration;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    [self addAnimation:transition forKey:@"transitionCrossfade"];
}

@end