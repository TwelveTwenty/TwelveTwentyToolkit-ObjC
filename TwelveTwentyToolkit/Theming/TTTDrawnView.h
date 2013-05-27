#import <Foundation/Foundation.h>
#import "UIImage+TTTDrawing.h"

@interface TTTDrawnView : UIView

@property(nonatomic, copy) TTTDrawingBlock drawBlock;

- (id)initWithFrame:(CGRect)frame drawBlock:(TTTDrawingBlock)drawBlock;

@end