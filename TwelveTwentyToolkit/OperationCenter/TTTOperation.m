#import "TTTOperation.h"
#import "TTTLog.h"
#import "TTTOperationCenter.h"

@implementation TTTOperation

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.requiresMainThread = YES;
    }
    
    return self;
}

- (void)queue
{
    [[TTTOperationCenter defaultCenter] queueOperation:self];
}

- (void)main
{
    DLog(@"Execute: %@", self);
    [self execute];
}

- (void)execute
{
    // override
    [self doesNotRecognizeSelector:_cmd];
}

@end