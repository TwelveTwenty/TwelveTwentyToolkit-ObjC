#import "TTTDrawnView.h"

@interface TTTDrawnView ()

@property(nonatomic) CGFloat scale;

@end

@implementation TTTDrawnView

- (id)initWithFrame:(CGRect)frame drawBlock:(TTTDrawingBlock)drawBlock
{
    self = [super initWithFrame:frame];

    if (self)
    {
        self.drawBlock = drawBlock;
        self.scale = [UIScreen mainScreen].scale;
        self.contentMode = UIViewContentModeRedraw;
    }

    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    self.drawBlock(ctx, self.bounds, self.scale);
}

@end