#import "TTTDrawnView.h"

@interface TTTDrawnView ()

@property(nonatomic) CGFloat scale;

@end

@implementation TTTDrawnView

- (id)initWithFrame:(CGRect)frame drawBlock:(TTTDrawingBlock)drawBlock
{
    return [self initWithFrame:frame drawBlock:drawBlock opaque:YES];
}

- (id)initWithFrame:(CGRect)frame drawBlock:(TTTDrawingBlock)drawBlock opaque:(BOOL)opaque
{
    self = [super initWithFrame:frame];

    if (self)
    {
        self.drawBlock = drawBlock;
        self.scale = [UIScreen mainScreen].scale;
        self.contentMode = UIViewContentModeRedraw;
        self.opaque = opaque;
        if (!opaque)
        {
            self.backgroundColor = [UIColor clearColor];
        }
    }

    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    self.drawBlock(ctx, self.bounds, self.scale);
}

@end