#import "TTTTriggerEvent.h"

@interface TTTTriggerEvent ()

@property(readwrite) Class commandClass;

@end

@implementation TTTTriggerEvent

- (id)initWithCommandClass:(Class)class
{
    self = [super init];

    if (self)
    {
        self.commandClass = class;
    }

    return self;
}

- (void)dispatch:(id)sender
{
    if (![[UIApplication sharedApplication] sendAction:@selector(sender:didTrigger:) to:nil from:sender forEvent:self])
    {
        [NSException raise:@"TTT_TRIGGER_EVENT_EXCEPTION" format:@"`sender:didTrigger:` action for %@ not found in responder chain.", self];
    }
}

@end