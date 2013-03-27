#import "TTTCommand.h"
#import "TTTTriggerEvent.h"

@implementation TTTCommand

- (id)initWithTriggerEvent:(TTTTriggerEvent *)triggerEvent
{
    self = [super init];
    
    if (self)
    {
        self.triggerEvent = triggerEvent;
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