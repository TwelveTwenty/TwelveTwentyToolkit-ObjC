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
    NSString *key = [NSString stringWithFormat:@"%@-%fx%f", identifier, size.width, size.height];
    UIImage *cachedImage = [[self tttDrawingCache] objectForKey:key];

    if (cachedImage == nil && (cachedImage = [self tttImageWithSize:size drawing:drawing]))
    {
        NSUInteger bytesPerPixel = 32;
        NSUInteger byteCost = (NSUInteger) (size.width * size.height * bytesPerPixel);
        [[self tttDrawingCache] setObject:cachedImage forKey:key cost:byteCost];
    }

    return cachedImage;
}

@end