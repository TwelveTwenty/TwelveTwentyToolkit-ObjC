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

#import "TTCGUtils.h"

CGRect CGRectTrim(CGRect rect, CGFloat top, CGFloat left, CGFloat bottom, CGFloat right)
    {
        rect.origin.y += top;
        rect.size.height -= top;
        rect.size.height -= bottom;

        rect.origin.x += left;
        rect.size.width -= left;
        rect.size.width -= right;

        return rect;
    }

CGRect CGRectAlignToRect(CGRect rectA, CGRect rectB, CGAlignOption options)
    {
        if (options & kCGAlignLeftEdge)
        {
            rectA.origin.x = rectB.origin.x;
        }
        else if (options & kCGAlignCenterHorizontally)
        {
            rectA.origin.x = rectB.origin.x + (rectB.size.width - rectA.size.width) / 2;
        }
        else if (options & kCGAlignRightEdge)
        {
            rectA.origin.x = rectB.origin.x + rectB.size.width - rectA.size.width;
        }

        if (options & kCGAlignTopEdge)
        {
            rectA.origin.y = rectB.origin.y;
        }
        else if (options & kCGAlignCenterVertically)
        {
            rectA.origin.y = rectB.origin.y + (rectB.size.height - rectA.size.height) / 2;
        }
        else if (options & kCGAlignBottomEdge)
        {
            rectA.origin.y = rectB.origin.y + rectB.size.height - rectA.size.height;
        }

        return rectA;
    }

CGRect CGRectAlignAndPositionNextToRect(CGRect rectA, CGRect rectB, CGAlignOption options, CGFloat spacing)
    {
        // Align

        rectA = CGRectAlignToRect(rectA, rectB, options);

        // Horizontal placement

        if (options & kCGAlignPositionToTheLeft)
        {
            rectA.origin.x = CGRectGetMinX(rectB) - CGRectGetWidth(rectA) - spacing;
        }
        else if (options & kCGAlignPositionToTheRight)
        {
            rectA.origin.x = CGRectGetMaxX(rectB) + spacing;
        }

        // Vertical placement

        if (options & kCGAlignPositionAbove)
        {
            rectA.origin.y = CGRectGetMinY(rectB) - CGRectGetHeight(rectA) - spacing;
        }
        else if (options & kCGAlignPositionBelow)
        {
            rectA.origin.y = CGRectGetMaxY(rectB) + spacing;
        }

        return rectA;
    }

CGRect CGRectRoundToPixels(CGRect r)
    {
        CGFloat scale = [UIScreen mainScreen].scale;

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


CGPoint CGPointSubtract(CGPoint p, CGPoint q)
    {
        return CGPointMake(p.x - q.x, p.y - q.y);
    }

CGPoint CGPointAdd(CGPoint p, CGPoint q)
    {
        return CGPointMake(p.x + q.x, p.y + q.y);
    }

CGFloat CGPointLengthSquare(CGPoint p)
    {
        return p.x * p.x + p.y * p.y;
    }

CGFloat CGPointLength(CGPoint p)
    {
        return sqrtf(p.x * p.x + p.y * p.y);
    }

