#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^TTTDrawingBlock)(CGContextRef ctx, CGRect rect, CGFloat scale);

@interface UIImage (TTTDrawing)

+ (UIImage *)tttImageWithSize:(CGSize)size drawing:(TTTDrawingBlock)drawing;

@end