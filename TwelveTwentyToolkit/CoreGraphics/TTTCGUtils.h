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
#define LIMIT(X, A, B) MAX(A, MIN(X, B))
#endif

#ifndef CGRectWithSize
#define CGRectWithSize(WIDTH,HEIGHT)	({ __typeof__(WIDTH) __width = (WIDTH); __typeof__(HEIGHT) __height = (HEIGHT); CGRectMake(0, 0, __width, __height); })
#endif

#ifndef CGRectWithSquareSize
#define CGRectWithSquareSize(SQUARE_SIZE)	({ __typeof__(SQUARE_SIZE) __size = (SQUARE_SIZE); CGRectMake(0, 0, __size, __size); })
#endif

#ifndef CGRectWithStructSize
#define CGRectWithStructSize(STRUCT_SIZE)	({ __typeof__(STRUCT_SIZE) __size = (STRUCT_SIZE); (CGRect){{0, 0}, __size}; })
#endif

#define DEG2RAD (M_PI / 180.0)

enum {
    CGAlignNone                        = 0,
    CGAlignPreventDevicePixelRounding  = 1 << 0,
};
typedef NSInteger TTTCGOption;

enum
{
    CGAlignLeftEdge                    = 1 << 1,
    CGAlignCenterHorizontally          = 1 << 2,
    CGAlignRightEdge                   = 1 << 3,
    CGAlignTopEdge                     = 1 << 4,
    CGAlignCenterVertically            = 1 << 5,
    CGAlignBottomEdge                  = 1 << 6,
};
typedef TTTCGOption TTTCGAlignOption;

enum {
    CGPositionToTheLeft = 1 << 10,
    CGPositionToTheRight = 1 << 11,
    CGPositionAbove = 1 << 12,
    CGPositionBelow = 1 << 13,
};
typedef TTTCGAlignOption TTTCGPositionOption;

enum
{
    CGTweakNone = 0,
    CGTweakOriginX = 1 << 14,
    CGTweakOriginY = 1 << 15,
    CGTweakSizeWidth = 1 << 16,
    CGTweakSizeHeight = 1 << 17
};
typedef TTTCGOption TTTCGTweakOption;

enum
{
    CGSubtractNone = 0,
    CGSubtractFromTheLeft = CGPositionToTheLeft,
    CGSubtractFromTheRight = CGPositionToTheRight,
    CGSubtractFromTheTop = CGPositionAbove,
    CGSubtractFromTheBottom = CGPositionBelow
};
typedef TTTCGOption TTTCGSubtractOption;

/** Trim a CGRect from the top, counter clockwise. */
extern CGRect CGRectTrim(CGRect rect, CGFloat top, CGFloat left, CGFloat bottom, CGFloat right);

/** The opposite of CGRectTrim */
extern CGRect CGRectExpand(CGRect rect, CGFloat top, CGFloat left, CGFloat bottom, CGFloat right);

/** Trim a CGRect by using UIEdgeInsets. */
extern CGRect TTTRectWithInsets(CGRect rect, UIEdgeInsets insets);

/**
* Replace one or more properties of a rect with a tweaked value.
* Example: CGRectWithTweak(rect, CGTweakSizeHeight, 0.5);
*/
extern CGRect CGRectWithTweak(CGRect rect, TTTCGTweakOption tweakOption, CGFloat tweakValue);

extern CGRect CGRectTranslate(CGRect rect, CGFloat x, CGFloat y);

extern CGRect CGRectSubtractRect(CGRect subject, CGRect operator, TTTCGSubtractOption options);

/** Align one rect to another one. Will round to device pixels unless flagged with CGAlignPreventDevicePixelRounding */
extern CGRect CGRectAlignToRect(CGRect rectA, CGRect rectB, TTTCGAlignOption options);

/** Align and (optionally) place a rect next to another one. Will round to device pixels unless flagged with CGAlignPreventDevicePixelRounding */
extern CGRect CGRectAlignAndPositionNextToRect(CGRect rectA, CGRect rectB, TTTCGPositionOption options, CGFloat spacing);

/** Round the position and with of a rect so it matches actual pixels on the current device. Retina displays supported. */
extern CGRect CGRectRoundToDevicePixels(CGRect r);

/** Subtract one point from another, vector style. */
extern CGPoint CGPointSubtract(CGPoint p, CGPoint q);

/** Add one point to another, vector style. */
extern CGPoint CGPointAdd(CGPoint p, CGPoint q);

/** Get the squared length of a point */
extern CGFloat CGPointLengthSquare(CGPoint p);

/** Perform the square root over the `CGPointLengthSquare` method. */
extern CGFloat CGPointLength(CGPoint p);

/** Aspect fit */
extern CGSize CGSizeScaleToFit(CGSize sizeA, CGSize sizeB);

/** Draw rounded pill rect */
extern CGPathRef TTTCGPathCreatePill(CGRect rect);

/** Rounded rect methods by Alexsander Akers & Zachary Waldowski: https://github.com/zwaldowski/AZAppearanceKit */
extern CGPathRef TTTCGPathCreateWithRoundedRect(CGRect rect, CGFloat cornerRadius);

extern CGPathRef TTTCGPathCreateByRoundingCornersInRect(CGRect rect, CGFloat topLeftRadius, CGFloat topRightRadius, CGFloat bottomLeftRadius, CGFloat bottomRightRadius);