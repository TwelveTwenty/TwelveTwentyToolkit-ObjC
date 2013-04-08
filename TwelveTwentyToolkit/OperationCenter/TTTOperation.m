#import <TwelveTwentyToolkit/TTTOperationCommand.h>
#import "TTTOperation.h"
#import "TTTLog.h"
#import "TTTInjector.h"

@implementation TTTOperation

- (id)initWithCommand:(TTTOperationCommand *)command
{
    self = [super init];
    
    if (self)
    {
        self.command = command;
        self.requiresMainThread = YES;
    }
    
    return self;
}

- (void)setCommand:(TTTOperationCommand *)command
{
    _command = command;
}

- (TTTOperationCommand *)command
{
    return _command;
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