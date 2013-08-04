#import <TwelveTwentyToolkit/TwelveTwentyToolkit.h>
#import "UIImage+TTTDrawing.h"

@implementation UIImage (TTTDrawing)

#define MB * (1024 * 1024)

+ (NSCache *)tttDrawingCache
{
    static NSCache *_tttDrawingCache = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        _tttDrawingCache = [[NSCache alloc] init];
        [_tttDrawingCache setTotalCostLimit:32 MB];
    });
    return _tttDrawingCache;
}

+ (void)tttSetDrawingCacheSize:(NSUInteger)bytes
{
    [[self tttDrawingCache] setTotalCostLimit:bytes];
}

+ (void)tttClearDrawingCache
{
    [[self tttDrawingCache] removeAllObjects];
}

+ (UIImage *)tttImageWithSize:(CGSize)size drawing:(TTTDrawingBlock)drawing
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

+ (UIImage *)tttImageWithIdentifier:(NSString *)identifier size:(CGSize)size drawing:(TTTDrawingBlock)drawing
{
    return [self tttImageWithIdentifier:identifier size:size drawing:drawing capInsets:UIEdgeInsetsZero];
}

+ (UIImage *)tttImageWithIdentifier:(NSString *)identifier size:(CGSize)size drawing:(TTTDrawingBlock)drawing capInsets:(UIEdgeInsets)capInsets
{
    return [self tttImageWithIdentifier:identifier size:size drawing:drawing capInsets:capInsets resizingMode:UIImageResizingModeStretch];
}

+ (UIImage *)tttImageWithIdentifier:(NSString *)identifier size:(CGSize)size drawing:(TTTDrawingBlock)drawing capInsets:(UIEdgeInsets)capInsets resizingMode:(UIImageResizingMode)resizingMode
{
    NSString *key = [NSString stringWithFormat:@"%@-%fx%f", identifier, size.width, size.height];
    UIImage *cachedImage = [[self tttDrawingCache] objectForKey:key];

    if (cachedImage == nil)
    {
        cachedImage = [self tttImageWithSize:size drawing:drawing];

        if (cachedImage)
        {
            if (!UIEdgeInsetsEqualToEdgeInsets(capInsets, UIEdgeInsetsZero))
            {
                cachedImage = [cachedImage resizableImageWithCapInsets:capInsets resizingMode:resizingMode];
            }

            NSUInteger bytesPerPixel = 32;
            NSUInteger byteCost = (NSUInteger) (size.width * size.height * bytesPerPixel);
            [[self tttDrawingCache] setObject:cachedImage forKey:key cost:byteCost];
        }
    }

    return cachedImage;
}

@end