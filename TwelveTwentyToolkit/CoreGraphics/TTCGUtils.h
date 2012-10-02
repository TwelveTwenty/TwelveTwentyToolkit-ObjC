// Copyright (c) 2012 Twelve Twenty (http://twelvetwenty.nl/)
//
// Permission is hereby granted, free of charge, to any unifiedCard obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#ifndef LIMIT
#define LIMIT(LEFT,VALUE,RIGHT)	({ __typeof__(LEFT) __left = (LEFT); __typeof__(RIGHT) __right = (RIGHT); __typeof__(VALUE) __value = (VALUE); MAX(__left, MIN(__value, __right)); })
#endif

#define DEG2RAD (M_PI / 180.0)

typedef enum {
    kCGAlignNone                = 0,
    //
    kCGAlignLeftEdge            = 1 << 0,
    kCGAlignCenterHorizontally  = 1 << 1,
    kCGAlignRightEdge           = 1 << 2,
    kCGAlignTopEdge             = 1 << 3,
    kCGAlignCenterVertically    = 1 << 4,
    kCGAlignBottomEdge          = 1 << 5,
    //
    kCGAlignPositionToTheLeft   = 1 << 6,
    kCGAlignPositionToTheRight  = 1 << 7,
    kCGAlignPositionAbove       = 1 << 8,
    kCGAlignPositionBelow       = 1 << 9
} CGAlignOption;

/** Trim a CGRect from the top, counter clockwise. */
extern CGRect CGRectTrim(CGRect rect, CGFloat top, CGFloat left, CGFloat bottom, CGFloat right);

/** Align one rect to another one */
extern CGRect CGRectAlignToRect(CGRect rectA, CGRect rectB, CGAlignOption options);

/** Align and (optionally) place a rect next to another one. */
extern CGRect CGRectAlignAndPositionNextToRect(CGRect rectA, CGRect rectB, CGAlignOption options, CGFloat spacing);

/** Round the position and with of a rect so it matches actual pixels. Retina supported. */
extern CGRect CGRectRoundToPixels(CGRect r);

/** Subtract one point from another, vector style. */
extern CGPoint CGPointSubtract(CGPoint p, CGPoint q);

/** Add one point to another, vector style. */
extern CGPoint CGPointAdd(CGPoint p, CGPoint q);

/** Get the squared length of a point */
extern CGFloat CGPointLengthSquare(CGPoint p);

/** Perform the square root over the `CGPointLengthSquare` method. */
extern CGFloat CGPointLength(CGPoint p);

