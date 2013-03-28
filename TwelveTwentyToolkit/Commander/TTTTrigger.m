#import "TTTTrigger.h"

@implementation UIView (TTTDebugging)

- (UIResponder *)tttFindFirstResponder
{
    if (self.isFirstResponder) {
        return self;
    }
    
    for (UIView *subview in self.subviews) {
        UIResponder *responder = [subview tttFindFirstResponder];
        if (responder) return responder;
    }
    
    return nil;
}

@end

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

- (void)invoke
{
    if (![[UIApplication sharedApplication] sendAction:@selector(sender:didInvoke:) to:nil from:[UIApplication sharedApplication] forEvent:self])
    {
        [NSException raise:@"TTT_TRIGGER_EVENT_EXCEPTION" format:@"`sender:didInvoke:` action for %@ not found in responder chain.", self];
    }
}

@end