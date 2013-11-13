#import "TwelveTwentyToolkit.h"
#import "UIImage+TTTDrawing.h"

@implementation UIImage (TTTDrawing)

#define MB * (1024 * 1024)

+ (NSCache *)ttt_drawingCache
{
    static NSCache *_tttDrawingCache = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        _tttDrawingCache = [[NSCache alloc] init];
        [_tttDrawingCache setTotalCostLimit:32 MB];
    });
    return _tttDrawingCache;
}

+ (void)ttt_setDrawingCacheSize:(NSUInteger)bytes
{
    [[self ttt_drawingCache] setTotalCostLimit:bytes];
}

+ (void)ttt_clearDrawingCache
{
    [[self ttt_drawingCache] removeAllObjects];
}

+ (UIImage *)ttt_imageWithSize:(CGSize)size drawing:(TTTDrawingBlock)drawing
{
    TTTStaticScreenScale();
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

+ (UIImage *)ttt_imageWithIdentifier:(NSString *)identifier size:(CGSize)size drawing:(TTTDrawingBlock)drawing
{
    return [self ttt_imageWithIdentifier:identifier size:size drawing:drawing capInsets:UIEdgeInsetsZero];
}

+ (UIImage *)ttt_imageWithIdentifier:(NSString *)identifier size:(CGSize)size drawing:(TTTDrawingBlock)drawing capInsets:(UIEdgeInsets)capInsets
{
    return [self ttt_imageWithIdentifier:identifier size:size drawing:drawing capInsets:capInsets resizingMode:UIImageResizingModeStretch];
}

+ (void)ttt_clearImageWithIdentifier:(NSString *)identifier size:(CGSize)size
{
    NSString *key = [NSString stringWithFormat:@"%@-%fx%f", identifier, size.width, size.height];
    [[self ttt_drawingCache] removeObjectForKey:key];
}

+ (UIImage *)ttt_imageWithIdentifier:(NSString *)identifier size:(CGSize)size drawing:(TTTDrawingBlock)drawing
                           capInsets:(UIEdgeInsets)capInsets resizingMode:(UIImageResizingMode)resizingMode
{
    NSString *key = [NSString stringWithFormat:@"%@-%fx%f", identifier, size.width, size.height];
    UIImage *cachedImage = [[self ttt_drawingCache] objectForKey:key];

    if (cachedImage == nil)
    {
        cachedImage = [self ttt_imageWithSize:size drawing:drawing];

        if (cachedImage)
        {
            if (!UIEdgeInsetsEqualToEdgeInsets(capInsets, UIEdgeInsetsZero))
            {
                cachedImage = [cachedImage resizableImageWithCapInsets:capInsets resizingMode:resizingMode];
            }

            NSUInteger bytesPerPixel = 32;
            NSUInteger byteCost = (NSUInteger) (size.width * size.height * bytesPerPixel);
            [[self ttt_drawingCache] setObject:cachedImage forKey:key cost:byteCost];
        }
    }

    return cachedImage;
}

@end