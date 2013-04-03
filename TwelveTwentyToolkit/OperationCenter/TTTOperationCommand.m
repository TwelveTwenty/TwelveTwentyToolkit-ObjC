#import "TTTOperationCommand.h"

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

@interface TTTOperationCommand ()

@property(readwrite) Class operationClass;

@end

@implementation TTTOperationCommand

- (id)initWithMappedOperation:(Class)operationClass
{
    self = [super init];

    if (self)
    {
        self.operationClass = operationClass;
    }

    return self;
}

- (void)invoke
{
    if (![[UIApplication sharedApplication] sendAction:@selector(sender:didInvokeCommand:) to:nil from:[UIApplication sharedApplication] forEvent:self])
    {
        [NSException raise:@"TTT_TRIGGER_EVENT_EXCEPTION" format:@"`sender:didInvoke:` action for %@ not found in responder chain.", self];
    }
}

@end