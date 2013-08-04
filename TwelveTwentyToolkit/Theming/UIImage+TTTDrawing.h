#import <Foundation/Foundation.h>
 #import <UIKit/UIKit.h>

typedef void (^TTTDrawingBlock)(CGContextRef ctx, CGRect rect, CGFloat scale);

@interface UIImage (TTTDrawing)

+ (void)tttSetDrawingCacheSize:(NSUInteger)bytes;

+ (void)tttClearDrawingCache;

+ (UIImage *)tttImageWithSize:(CGSize)size drawing:(TTTDrawingBlock)drawing;

+ (UIImage *)tttImageWithIdentifier:(NSString *)identifier size:(CGSize)size drawing:(TTTDrawingBlock)drawing;

+ (UIImage *)tttImageWithIdentifier:(NSString *)identifier size:(CGSize)size drawing:(TTTDrawingBlock)drawing capInsets:(UIEdgeInsets)capInsets;

+ (UIImage *)tttImageWithIdentifier:(NSString *)identifier size:(CGSize)size drawing:(TTTDrawingBlock)drawing capInsets:(UIEdgeInsets)capInsets resizingMode:(UIImageResizingMode)resizingMode;

@end