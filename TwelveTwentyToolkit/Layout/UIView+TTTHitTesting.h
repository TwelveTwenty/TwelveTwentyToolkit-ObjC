//
//  UIView+Reusabilitee.h
//  wowcal
//
//  Created by Eric-Paul Lecluse on 21-10-11.
//  Copyright (c) 2011 PINCH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (TTTHitTesting)

/**
 Use this method inside a UIView's `pointInside:withEvent:` method to determine
 whether the point clicked belongs to any of the subviews, instead of merely hittesting
 the superview's frame.
 */
- (BOOL)tttPointInsideSubviews:(CGPoint)point withEvent:(UIEvent *)event;

- (BOOL)tttPointInsideSubviews:(CGPoint)point withEvent:(UIEvent *)event skipHiddenViews:(BOOL)skipHidden;

- (BOOL)tttPointInsideSubviews:(CGPoint)point withEvent:(UIEvent *)event skipHiddenViews:(BOOL)skipHidden skipViewInSet:(NSSet *)skipSet;

@end
