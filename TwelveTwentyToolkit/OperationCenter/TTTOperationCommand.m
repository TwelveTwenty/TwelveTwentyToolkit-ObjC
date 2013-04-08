#import "TTTOperationCommand.h"
#import "TTTOperationCenter.h"

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
    [[TTTOperationCenter defaultCenter] sender:nil didInvokeCommand:self];
}

@end