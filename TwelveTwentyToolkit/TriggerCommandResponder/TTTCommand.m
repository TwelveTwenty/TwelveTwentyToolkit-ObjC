#import "TTTCommand.h"
#import "TTTTriggerEvent.h"

@implementation TTTCommand

- (id)initWithTrigger:(TTTTriggerEvent *)trigger
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