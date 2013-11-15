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

#import "TwelveTwentyToolkit.h"
#import "TTTCGUtils.h"

CGRect CGRectTrim(CGRect rect, CGFloat top, CGFloat left, CGFloat bottom, CGFloat right) {
    rect.origin.y += top;
    rect.size.height -= top;
    rect.size.height -= bottom;

    rect.origin.x += left;
    rect.size.width -= left;
    rect.size.width -= right;

    return rect;
}

CGRect CGRectExpand(CGRect rect, CGFloat top, CGFloat left, CGFloat bottom, CGFloat right) {
    return CGRectTrim(rect, -top, -left, -bottom, -right);
}

CGRect TTTRectWithInsets(CGRect rect, UIEdgeInsets insets) {
    return CGRectTrim(rect, insets.top, insets.left, insets.bottom, insets.right);
}

CGRect CGRectWithTweak(CGRect rect, TTTCGTweakOption tweakOption, CGFloat tweakValue) {
    if (tweakOption & CGTweakOriginX)
        rect.origin.x = tweakValue;

    if (tweakOption & CGTweakOriginY)
        rect.origin.y = tweakValue;

    if (tweakOption & CGTweakSizeWidth)
        rect.size.width = tweakValue;

    if (tweakOption & CGTweakSizeHeight)
        rect.size.height = tweakValue;

    return rect;
}

CGRect CGRectTranslate(CGRect rect, CGFloat x, CGFloat y) {
    rect.origin.x += x;
    rect.origin.y += y;

    return rect;
}

CGRect CGRectSubtractRect(CGRect subject, CGRect operator, TTTCGSubtractOption options) {
    CGRect subtracted = subject;

    if (options & CGSubtractFromTheLeft)
    {
        // Subtract from the left side
        CGFloat left = MAX(CGRectGetMaxX(operator) - CGRectGetMinX(subject), 0);
        subtracted = CGRectTrim(subject, 0, left, 0, 0);
    }
    else if (options & CGSubtractFromTheRight)
    {
        // Subtract from the right side
        CGFloat right = MAX(CGRectGetMaxX(subject) - CGRectGetMinX(operator), 0);
        subtracted = CGRectTrim(subject, 0, 0, 0, right);
    }

    if (options & CGSubtractFromTheTop)
    {
        // Subtract from the top side
        CGFloat top = MAX(CGRectGetMaxY(operator) - CGRectGetMinY(subject), 0);
        subtracted = CGRectTrim(subject, top, 0, 0, 0);
    }
    else if (options & CGSubtractFromTheBottom)
    {
        // Subtract from the bottom side
        CGFloat bottom = MAX(CGRectGetMaxY(subject) - CGRectGetMinY(operator), 0);
        subtracted = CGRectTrim(subject, 0, 0, bottom, 0);
    }

    return subtracted;
}

CGRect CGRectAlignToRect(CGRect rectA, CGRect rectB, TTTCGAlignOption options) {
    if (options & CGAlignLeftEdge)
    {
        rectA.origin.x = rectB.origin.x;
    }
    else if (options & CGAlignCenterHorizontally)
    {
        rectA.origin.x = rectB.origin.x + (rectB.size.width - rectA.size.width) / 2;
    }
    else if (options & CGAlignRightEdge)
    {
        rectA.origin.x = rectB.origin.x + rectB.size.width - rectA.size.width;
    }

    if (options & CGAlignTopEdge)
    {
        rectA.origin.y = rectB.origin.y;
    }
    else if (options & CGAlignCenterVertically)
    {
        rectA.origin.y = rectB.origin.y + (rectB.size.height - rectA.size.height) / 2;
    }
    else if (options & CGAlignBottomEdge)
    {
        rectA.origin.y = rectB.origin.y + rectB.size.height - rectA.size.height;
    }

    if (!(options & CGAlignPreventDevicePixelRounding))
    {
        rectA = CGRectRoundToDevicePixels(rectA);
    }

    return rectA;
}

CGRect CGRectAlignAndPositionNextToRect(CGRect rectA, CGRect rectB, TTTCGPositionOption options, CGFloat spacing) {
    // Align

    rectA = CGRectAlignToRect(rectA, rectB, options);

    // Horizontal placement

    if (options & CGPositionToTheLeft)
    {
        rectA.origin.x = CGRectGetMinX(rectB) - CGRectGetWidth(rectA) - spacing;
    }
    else if (options & CGPositionToTheRight)
    {
        rectA.origin.x = CGRectGetMaxX(rectB) + spacing;
    }

    // Vertical placement

    if (options & CGPositionAbove)
    {
        rectA.origin.y = CGRectGetMinY(rectB) - CGRectGetHeight(rectA) - spacing;
    }
    else if (options & CGPositionBelow)
    {
        rectA.origin.y = CGRectGetMaxY(rectB) + spacing;
    }

    if (!(options & CGAlignPreventDevicePixelRounding))
    {
        rectA = CGRectRoundToDevicePixels(rectA);
    }

    return rectA;
}

CGRect CGRectRoundToDevicePixels(CGRect r) {
    TTTStaticScreenScale();

    CGRect q = r;
    q.origin.x = roundf(q.origin.x * scale) / scale;
    q.origin.y = roundf(q.origin.y * scale) / scale;

    BOOL increaseX = q.origin.x < r.origin.x;
    BOOL increaseY = q.origin.y < r.origin.y;

    if (increaseX)
    {
        q.size.width += 1 / scale;
    }

    if (increaseY)
    {
        q.size.height += 1 / scale;
    }

    q.size.width = roundf(q.size.width * scale) / scale;
    q.size.height = roundf(q.size.height * scale) / scale;

    return q;
}

CGPoint CGPointSubtract(CGPoint p, CGPoint q) {
    return CGPointMake(p.x - q.x, p.y - q.y);
}

CGPoint CGPointAdd(CGPoint p, CGPoint q) {
    return CGPointMake(p.x + q.x, p.y + q.y);
}

CGFloat CGPointLengthSquare(CGPoint p) {
    return p.x * p.x + p.y * p.y;
}

CGFloat CGPointLength(CGPoint p) {
    return sqrtf(p.x * p.x + p.y * p.y);
}

CGSize CGSizeScaleToFit(CGSize sizeA, CGSize sizeB) {
    CGFloat hRatio = sizeB.width / sizeA.width;
    CGFloat vRatio = sizeB.height / sizeA.height;
    CGFloat minRatio = MIN(hRatio, vRatio);

    return CGSizeMake(sizeA.width * minRatio, sizeA.height * minRatio);
}

CGPathRef TTTCGPathCreatePill(CGRect rect) {
    return TTTCGPathCreateWithRoundedRect(rect, CGRectGetHeight(rect) / 2.0);
}

CGPathRef TTTCGPathCreateWithRoundedRect(CGRect rect, CGFloat cornerRadius) {
    return TTTCGPathCreateByRoundingCornersInRect(rect, cornerRadius, cornerRadius, cornerRadius, cornerRadius);
}

CGPathRef TTTCGPathCreateByRoundingCornersInRect(CGRect rect, CGFloat topLeftRadius, CGFloat topRightRadius, CGFloat bottomLeftRadius, CGFloat bottomRightRadius) {
    const CGPoint topLeft = rect.origin;
    const CGPoint topRight = CGPointMake(CGRectGetMaxX(rect), CGRectGetMinY(rect));
    const CGPoint bottomRight = CGPointMake(CGRectGetMaxX(rect), CGRectGetMaxY(rect));
    const CGPoint bottomLeft = CGPointMake(CGRectGetMinX(rect), CGRectGetMaxY(rect));

    CGMutablePathRef path = CGPathCreateMutable();

    CGPathMoveToPoint(path, NULL, topLeft.x + topLeftRadius, topLeft.y);

    CGPathAddLineToPoint(path, NULL, topRight.x - topRightRadius, topRight.y);
    CGPathAddCurveToPoint(path, NULL, topRight.x, topRight.y, topRight.x, topRight.y + topRightRadius, topRight.x, topRight.y + topRightRadius);

    CGPathAddLineToPoint(path, NULL, bottomRight.x, bottomRight.y - bottomRightRadius);
    CGPathAddCurveToPoint(path, NULL, bottomRight.x, bottomRight.y, bottomRight.x - bottomRightRadius, bottomRight.y, bottomRight.x - bottomRightRadius, bottomRight.y);

    CGPathAddLineToPoint(path, NULL, bottomLeft.x + bottomLeftRadius, bottomLeft.y);
    CGPathAddCurveToPoint(path, NULL, bottomLeft.x, bottomLeft.y, bottomLeft.x, bottomLeft.y - bottomLeftRadius, bottomLeft.x, bottomLeft.y - bottomLeftRadius);

    CGPathAddLineToPoint(path, NULL, topLeft.x, topLeft.y + topLeftRadius);
    CGPathAddCurveToPoint(path, NULL, topLeft.x, topLeft.y, topLeft.x + topLeftRadius, topLeft.y, topLeft.x + topLeftRadius, topLeft.y);

    CGPathCloseSubpath(path);

    return path;
}