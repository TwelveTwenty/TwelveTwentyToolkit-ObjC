#import "TTTTrigger.h"

@interface TTTTrigger ()

@property(readwrite) Class commandClass;

@end

@implementation TTTTrigger

- (id)initWithMappedCommand:(Class)commandClass
{
    self = [super init];

    if (self)
    {
        self.commandClass = commandClass;
    }

    return self;
}

- (void)trigger:(id)sender
{
    if (![[UIApplication sharedApplication] sendAction:@selector(sender:didTrigger:) to:nil from:sender forEvent:self])
    {
        [NSException raise:@"TTT_TRIGGER_EVENT_EXCEPTION" format:@"`sender:didTrigger:` action for %@ not found in responder chain.", self];
    }
}

@end