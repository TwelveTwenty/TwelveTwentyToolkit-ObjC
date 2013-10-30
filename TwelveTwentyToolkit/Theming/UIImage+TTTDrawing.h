#import <Foundation/Foundation.h>
 #import <UIKit/UIKit.h>

typedef void (^TTTDrawingBlock)(CGContextRef ctx, CGRect rect, CGFloat scale);

@interface UIImage (TTTDrawing)

+ (void)ttt_setDrawingCacheSize:(NSUInteger)bytes;

+ (void)ttt_clearDrawingCache;

+ (UIImage *)ttt_imageWithSize:(CGSize)size drawing:(TTTDrawingBlock)drawing;

+ (UIImage *)ttt_imageWithIdentifier:(NSString *)identifier size:(CGSize)size drawing:(TTTDrawingBlock)drawing;

+ (UIImage *)ttt_imageWithIdentifier:(NSString *)identifier size:(CGSize)size drawing:(TTTDrawingBlock)drawing capInsets:(UIEdgeInsets)capInsets;

+ (void)ttt_clearImageWithIdentifier:(NSString *)identifier size:(CGSize)size;

+ (UIImage *)ttt_imageWithIdentifier:(NSString *)identifier size:(CGSize)size drawing:(TTTDrawingBlock)drawing
                           capInsets:(UIEdgeInsets)capInsets resizingMode:(UIImageResizingMode)resizingMode;

@end