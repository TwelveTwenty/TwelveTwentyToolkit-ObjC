#import "UIImage+TTTDrawing.h"

@implementation UIImage (TTTDrawing)

+ (UIImage *)tttImageWithSize:(CGSize)size drawing:(TTTDrawingBlock)drawing
{
    CGFloat scale = [UIScreen mainScreen].scale;
    UIGraphicsBeginImageContextWithOptions(size, NO, scale);
    CGContextRef context = UIGraphicsGetCurrentContext();

    if (context != NULL)
    {
        drawing(context, (CGRect) {{0, 0}, size}, scale);
        UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return img;
    }

    return nil;
}

@end