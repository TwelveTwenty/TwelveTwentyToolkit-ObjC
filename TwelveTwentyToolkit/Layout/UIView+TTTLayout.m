#import <CoreGraphics/CoreGraphics.h>
#import "UIView+TTTLayout.h"
#import "TTCGUtils.h"

@implementation UIView (TTTLayout)

- (void)tttAddSubviews:(NSArray *)array
{
    [array enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        [self addSubview:view];
    }];
}

- (CGRect)tttResetIntrinsicContentFrame
{
    self.frame = (CGRect){self.frame.origin, self.intrinsicContentSize};
    return self.frame;
}

- (CGRect)tttDistributeViewsHorizontally:(NSArray *)views inFrame:(CGRect)containerFrame withSpacing:(CGFloat)spacing
{
    return [self tttDistributeViewsHorizontally:views inFrame:containerFrame withSpacing:spacing alignment:TTTDistributeAlignCenter];
}

- (CGRect)tttDistributeViewsHorizontally:(NSArray *)views inFrame:(CGRect)containerFrame withSpacing:(CGFloat)spacing alignment:(TTTDistributeAlign)alignment
{
    CGRect unionFrame = CGRectZero;
    {
        CGFloat requiredWidth = (views.count - 1) * spacing;
        for (UIView *distributeView in views)
        {
            requiredWidth += distributeView.frame.size.width;
        }

        // Before enumerating the views, the anchor frame is set to the space to the left of the row of views.
        CGRect anchorFrame = containerFrame;
        anchorFrame.origin.x -= spacing;

        switch (alignment)
        {
            case TTTDistributeAlignLeft:
                anchorFrame.size.width = 0;
                break;

            case TTTDistributeAlignCenter:
                anchorFrame.size.width = (containerFrame.size.width - requiredWidth) / 2;
                break;

            case TTTDistributeAlignRight:
                anchorFrame.size.width = (containerFrame.size.width - requiredWidth);
                break;
        }

        for (UIView *distributeView in views)
        {
            anchorFrame = distributeView.frame = CGRectAlignAndPositionNextToRect(distributeView.frame, anchorFrame, CGAlignCenterVertically | CGAlignPositionToTheRight, spacing);
            if (CGRectEqualToRect(unionFrame, CGRectZero))
            {
                unionFrame = anchorFrame;
            }
            else
            {
                unionFrame = CGRectUnion(unionFrame, anchorFrame);
            }
        }
    }

    return unionFrame;
}

- (CGRect)tttDistributeViews:(NSArray *)views asRowsInFrame:(CGRect)containerFrame withSpacing:(CGFloat)spacing horizontalAlignment:(TTTDistributeAlign)alignment rowLimit:(int)rowLimit
{
    return [self tttDistributeViews:views asRowsInFrame:containerFrame withSpacing:spacing horizontalAlignment:alignment rowLimit:rowLimit containerAlignment:CGAlignNone];
}

- (CGRect)tttDistributeViews:(NSArray *)views asRowsInFrame:(CGRect)containerFrame withSpacing:(CGFloat)spacing horizontalAlignment:(TTTDistributeAlign)alignment rowLimit:(int)rowLimit containerAlignment:(CGAlignOption)containerAlignment
{
    __block CGRect result = CGRectZero;
    NSMutableArray *rows = [NSMutableArray array];
    NSMutableArray *rowFrames = [NSMutableArray array];
    int rowItemCount = 0;
    CGRect rowFrame = (CGRect) {containerFrame.origin, CGSizeZero};
    for (UIView *subview in views)
    {
        CGRect subviewFrame = subview.frame;
        subviewFrame.origin = rowFrame.origin;

        BOOL requireNewRow = (rowFrame.size.width > 0 && CGRectGetMaxX(subviewFrame) > CGRectGetMaxX(containerFrame));
        requireNewRow |= (rowLimit > 0 && rowItemCount == rowLimit);

        if (requireNewRow)
        {
            [rows addObject:[NSMutableArray arrayWithObject:subview]];

            subviewFrame.origin.x = containerFrame.origin.x;
            subviewFrame.origin.y += spacing + rowFrame.size.height;

            rowFrame = subviewFrame;
            rowItemCount = 1;
        }
        else
        {
            NSMutableArray *row = [rows lastObject];
            if (row)
            {
                [row addObject:subview];
            }
            else
            {
                [rows addObject:[NSMutableArray arrayWithObject:subview]];
            }

            rowFrame.origin.x += subviewFrame.size.width + spacing;
            rowFrame.size.width = CGRectGetMaxX(subviewFrame) - CGRectGetMinX(containerFrame);
            rowFrame.size.height = MAX(rowFrame.size.height, subviewFrame.size.height);
            rowItemCount++;
        }

        rowFrames[[rows count] - 1] = [NSValue valueWithCGRect:rowFrame];
        subview.frame = CGRectRoundToDevicePixels(subviewFrame);

        if (CGRectEqualToRect(result, CGRectZero))
        {
            result = subview.frame;
        }
        else
        {
            result = CGRectUnion(result, subview.frame);
        }
    }

    if (alignment != TTTDistributeAlignLeft)
    {
        // re-iterate over the rows objects to align horizontally
        result = CGRectZero;

        [rows enumerateObjectsUsingBlock:^(NSArray *row, NSUInteger idx, BOOL *stop) {
            CGRect frame = [(NSValue *) rowFrames[idx] CGRectValue];
            CGFloat offsetX = 0;

            switch (alignment)
            {
                default:
                case TTTDistributeAlignCenter:
                    offsetX = (containerFrame.size.width - frame.size.width) / 2.0;
                    break;
                case TTTDistributeAlignRight:
                    offsetX = containerFrame.size.width - frame.size.width;
                    break;
            }

            for (UIView *subview in row)
            {
                CGRect subviewFrame = subview.frame;
                subviewFrame.origin.x += offsetX;
                subview.frame = CGRectRoundToDevicePixels(subviewFrame);

                if (CGRectEqualToRect(result, CGRectZero))
                {
                    result = subview.frame;
                }
                else
                {
                    result = CGRectUnion(result, subview.frame);
                }
            }
        }];
    }

    if (containerAlignment != CGAlignNone)
    {
        CGRect alignedResult = CGRectAlignToRect(result, containerFrame, containerAlignment);
        CGPoint offset = CGPointSubtract(alignedResult.origin, result.origin);
        result.origin = alignedResult.origin;

        for (UIView *view in views)
        {
            CGRect viewFrame = view.frame;
            viewFrame.origin.x += offset.x;
            viewFrame.origin.y += offset.y;
            view.frame = viewFrame;
        }
    }

    return result;
}

@end