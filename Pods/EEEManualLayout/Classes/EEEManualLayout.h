#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#ifndef LIMIT
#define LIMIT(X, A, B) MAX(A, MIN(X, B))
#endif

#ifndef EEECGRectWithSize
#define EEECGRectWithSize(WIDTH,HEIGHT)	({ __typeof__(WIDTH) __width = (WIDTH); __typeof__(HEIGHT) __height = (HEIGHT); CGRectMake(0, 0, __width, __height); })
#endif

#ifndef EEECGRectWithSquareSize
#define EEECGRectWithSquareSize(SQUARE_SIZE)	({ __typeof__(SQUARE_SIZE) __size = (SQUARE_SIZE); CGRectMake(0, 0, __size, __size); })
#endif

#ifndef EEECGRectWithStructSize
#define EEECGRectWithStructSize(STRUCT_SIZE)	({ __typeof__(STRUCT_SIZE) __size = (STRUCT_SIZE); (CGRect){{0, 0}, __size}; })
#endif

#define EEEStaticScreenScale() static CGFloat scale = 0; \
if (!scale) scale = [UIScreen mainScreen].scale;

#define EEEStaticMainScreenBounds() static CGRect mainScreenBounds = (CGRect){0,0,0,0}; \
if (CGRectEqualToRect(mainScreenBounds, CGRectZero)) mainScreenBounds = [UIScreen mainScreen].bounds;

#define DEG2RAD (M_PI / 180.0)

enum {
    EEECGAlignNone                        = 0,
    EEECGAlignPreventDevicePixelRounding  = 1 << 0,
};
typedef NSInteger EEECGOption;

enum
{
    EEECGAlignLeftEdge                    = 1 << 1,
    EEECGAlignCenterHorizontally          = 1 << 2,
    EEECGAlignRightEdge                   = 1 << 3,
    EEECGAlignTopEdge                     = 1 << 4,
    EEECGAlignCenterVertically            = 1 << 5,
    EEECGAlignBottomEdge                  = 1 << 6,
};
typedef EEECGOption EEECGAlignOption;

enum {
    EEECGPositionToTheLeft = 1 << 10,
    EEECGPositionToTheRight = 1 << 11,
    EEECGPositionAbove = 1 << 12,
    EEECGPositionBelow = 1 << 13,
};
typedef EEECGAlignOption EEECGPositionOption;

enum
{
    EEECGTweakNone = 0,
    EEECGTweakOriginX = 1 << 14,
    EEECGTweakOriginY = 1 << 15,
    EEECGTweakSizeWidth = 1 << 16,
    EEECGTweakSizeHeight = 1 << 17
};
typedef EEECGOption EEECGTweakOption;

enum
{
    EEECGSubtractNone = 0,
    EEECGSubtractFromTheLeft = EEECGPositionToTheLeft,
    EEECGSubtractFromTheRight = EEECGPositionToTheRight,
    EEECGSubtractFromTheTop = EEECGPositionAbove,
    EEECGSubtractFromTheBottom = EEECGPositionBelow
};
typedef EEECGOption EEECGSubtractOption;

/** Trim a CGRect from the top, counter clockwise. */
extern CGRect EEECGRectTrim(CGRect rect, CGFloat top, CGFloat left, CGFloat bottom, CGFloat right);

/** The opposite of CGRectTrim */
extern CGRect EEECGRectExpand(CGRect rect, CGFloat top, CGFloat left, CGFloat bottom, CGFloat right);

/** Trim a CGRect by using UIEdgeInsets. */
extern CGRect EEERectWithInsets(CGRect rect, UIEdgeInsets insets);

/**
* Replace one or more properties of a rect with a tweaked value.
* Example: CGRectWithTweak(rect, CGTweakSizeHeight, 0.5);
*/
extern CGRect EEECGRectWithTweak(CGRect rect, EEECGTweakOption tweakOption, CGFloat tweakValue);

extern CGRect EEECGRectTranslate(CGRect rect, CGFloat x, CGFloat y);

extern CGRect EEECGRectSubtractRect(CGRect subject, CGRect operator, EEECGSubtractOption options);

/** Align one rect to another one. Will round to device pixels unless flagged with EEECGAlignPreventDevicePixelRounding */
extern CGRect EEECGRectAlignToRect(CGRect rectA, CGRect rectB, EEECGAlignOption options);

/** Align and (optionally) place a rect next to another one. Will round to device pixels unless flagged with EEECGAlignPreventDevicePixelRounding */
extern CGRect EEECGRectAlignAndPositionNextToRect(CGRect rectA, CGRect rectB, EEECGPositionOption options, CGFloat spacing);

/** Round the position and with of a rect so it matches actual pixels on the current device. Retina displays supported. */
extern CGRect EEECGRectRoundToDevicePixels(CGRect r);

/** Subtract one point from another, vector style. */
extern CGPoint EEECGPointSubtract(CGPoint p, CGPoint q);

/** Add one point to another, vector style. */
extern CGPoint EEECGPointAdd(CGPoint p, CGPoint q);

/** Get the squared length of a point */
extern CGFloat EEECGPointLengthSquare(CGPoint p);

/** Perform the square root over the `CGPointLengthSquare` method. */
extern CGFloat EEECGPointLength(CGPoint p);

/** Aspect fit */
extern CGSize EEECGSizeScaleToFit(CGSize sizeA, CGSize sizeB);

/** Draw rounded pill rect */
extern CGPathRef EEECGPathCreatePill(CGRect rect);

/** Rounded rect methods by Alexsander Akers & Zachary Waldowski: https://github.com/zwaldowski/AZAppearanceKit */
extern CGPathRef EEECGPathCreateWithRoundedRect(CGRect rect, CGFloat cornerRadius);

extern CGPathRef EEECGPathCreateByRoundingCornersInRect(CGRect rect, CGFloat topLeftRadius, CGFloat topRightRadius, CGFloat bottomLeftRadius, CGFloat bottomRightRadius);