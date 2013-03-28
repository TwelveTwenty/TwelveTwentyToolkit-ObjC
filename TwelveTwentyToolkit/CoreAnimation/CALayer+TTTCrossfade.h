#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface CALayer (TTTCrossfade)

/**
Call this method on your controller's view layer in `willAnimateRotationToInterfaceOrientation:duration:`
Wrap layoutSubviews calls to fading views in `[UIView setAnimationsEnabled:NO]` ... `[UIView setAnimationsEnabled:YES]`
*/
- (void)transitionCrossfadeWithDuration:(CFTimeInterval)duration;

@end