#import "EEEManualLayout.h"

CGRect EEECGRectTrim(CGRect rect, CGFloat top, CGFloat left, CGFloat bottom, CGFloat right) {
    rect.origin.y += top;
    rect.size.height -= top;
    rect.size.height -= bottom;

    rect.origin.x += left;
    rect.size.width -= left;
    rect.size.width -= right;

    return rect;
}

CGRect EEECGRectExpand(CGRect rect, CGFloat top, CGFloat left, CGFloat bottom, CGFloat right) {
    return EEECGRectTrim(rect, -top, -left, -bottom, -right);
}

CGRect EEECGRectWithInsets(CGRect rect, UIEdgeInsets insets) {
    return EEECGRectTrim(rect, insets.top, insets.left, insets.bottom, insets.right);
}

CGRect EEECGRectWithTweak(CGRect rect, EEECGTweakOption tweakOption, CGFloat tweakValue) {
    if (tweakOption & EEECGTweakOriginX)
        rect.origin.x = tweakValue;

    if (tweakOption & EEECGTweakOriginY)
        rect.origin.y = tweakValue;

    if (tweakOption & EEECGTweakSizeWidth)
        rect.size.width = tweakValue;

    if (tweakOption & EEECGTweakSizeHeight)
        rect.size.height = tweakValue;

    return rect;
}

CGRect EEECGRectTranslate(CGRect rect, CGFloat x, CGFloat y) {
    rect.origin.x += x;
    rect.origin.y += y;

    return rect;
}

CGRect EEECGRectSubtractRect(CGRect subject, CGRect operator, EEECGSubtractOption options) {
    CGRect subtracted = subject;

    if (options & EEECGSubtractFromTheLeft)
    {
        // Subtract from the left side
        CGFloat left = MAX(CGRectGetMaxX(operator) - CGRectGetMinX(subject), 0);
        subtracted = EEECGRectTrim(subject, 0, left, 0, 0);
    }
    else if (options & EEECGSubtractFromTheRight)
    {
        // Subtract from the right side
        CGFloat right = MAX(CGRectGetMaxX(subject) - CGRectGetMinX(operator), 0);
        subtracted = EEECGRectTrim(subject, 0, 0, 0, right);
    }

    if (options & EEECGSubtractFromTheTop)
    {
        // Subtract from the top side
        CGFloat top = MAX(CGRectGetMaxY(operator) - CGRectGetMinY(subject), 0);
        subtracted = EEECGRectTrim(subject, top, 0, 0, 0);
    }
    else if (options & EEECGSubtractFromTheBottom)
    {
        // Subtract from the bottom side
        CGFloat bottom = MAX(CGRectGetMaxY(subject) - CGRectGetMinY(operator), 0);
        subtracted = EEECGRectTrim(subject, 0, 0, bottom, 0);
    }

    return subtracted;
}

CGRect EEECGRectAlignToRect(CGRect rectA, CGRect rectB, EEECGAlignOption options) {
    if (options & EEECGAlignLeftEdge)
    {
        rectA.origin.x = rectB.origin.x;
    }
    else if (options & EEECGAlignCenterHorizontally)
    {
        rectA.origin.x = rectB.origin.x + (rectB.size.width - rectA.size.width) / 2;
    }
    else if (options & EEECGAlignRightEdge)
    {
        rectA.origin.x = rectB.origin.x + rectB.size.width - rectA.size.width;
    }

    if (options & EEECGAlignTopEdge)
    {
        rectA.origin.y = rectB.origin.y;
    }
    else if (options & EEECGAlignCenterVertically)
    {
        rectA.origin.y = rectB.origin.y + (rectB.size.height - rectA.size.height) / 2;
    }
    else if (options & EEECGAlignBottomEdge)
    {
        rectA.origin.y = rectB.origin.y + rectB.size.height - rectA.size.height;
    }

    if (!(options & EEECGAlignPreventDevicePixelRounding))
    {
        rectA = EEECGRectRoundToDevicePixels(rectA);
    }

    return rectA;
}

CGRect EEECGRectAlignAndPositionNextToRect(CGRect rectA, CGRect rectB, EEECGPositionOption options, CGFloat spacing) {
    // Align

    rectA = EEECGRectAlignToRect(rectA, rectB, options);

    // Horizontal placement

    if (options & EEECGPositionToTheLeft)
    {
        rectA.origin.x = CGRectGetMinX(rectB) - CGRectGetWidth(rectA) - spacing;
    }
    else if (options & EEECGPositionToTheRight)
    {
        rectA.origin.x = CGRectGetMaxX(rectB) + spacing;
    }

    // Vertical placement

    if (options & EEECGPositionAbove)
    {
        rectA.origin.y = CGRectGetMinY(rectB) - CGRectGetHeight(rectA) - spacing;
    }
    else if (options & EEECGPositionBelow)
    {
        rectA.origin.y = CGRectGetMaxY(rectB) + spacing;
    }

    if (!(options & EEECGAlignPreventDevicePixelRounding))
    {
        rectA = EEECGRectRoundToDevicePixels(rectA);
    }

    return rectA;
}

CGRect EEECGRectRoundToDevicePixels(CGRect r) {
    EEEStaticScreenScale();

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

CGPoint EEECGPointSubtract(CGPoint p, CGPoint q) {
    return CGPointMake(p.x - q.x, p.y - q.y);
}

CGPoint EEECGPointAdd(CGPoint p, CGPoint q) {
    return CGPointMake(p.x + q.x, p.y + q.y);
}

CGFloat EEECGPointLengthSquare(CGPoint p) {
    return p.x * p.x + p.y * p.y;
}

CGFloat EEECGPointLength(CGPoint p) {
    return sqrtf(p.x * p.x + p.y * p.y);
}

CGSize EEECGSizeScaleToFit(CGSize sizeA, CGSize sizeB) {
    CGFloat hRatio = sizeB.width / sizeA.width;
    CGFloat vRatio = sizeB.height / sizeA.height;
    CGFloat minRatio = MIN(hRatio, vRatio);

    return CGSizeMake(sizeA.width * minRatio, sizeA.height * minRatio);
}

CGPathRef EEECGPathCreatePill(CGRect rect) {
    return EEECGPathCreateWithRoundedRect(rect, CGRectGetHeight(rect) / 2.0);
}

CGPathRef EEECGPathCreateWithRoundedRect(CGRect rect, CGFloat cornerRadius) {
    return EEECGPathCreateByRoundingCornersInRect(rect, cornerRadius, cornerRadius, cornerRadius, cornerRadius);
}

CGPathRef EEECGPathCreateByRoundingCornersInRect(CGRect rect, CGFloat topLeftRadius, CGFloat topRightRadius, CGFloat bottomLeftRadius, CGFloat bottomRightRadius) {
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