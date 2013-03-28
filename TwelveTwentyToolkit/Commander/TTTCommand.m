#import "TTTCommand.h"
#import "TTTTrigger.h"

@implementation TTTCommand

- (id)initWithTrigger:(TTTTrigger *)trigger
{
    self = [super init];
    
    if (self)
    {
        self.trigger = trigger;
        self.requiresMainThread = YES;
    }
    
    return self;
}

- (void)main
{
    [self execute];
}

- (void)execute
{
    // override
    [self doesNotRecognizeSelector:_cmd];
}

@end