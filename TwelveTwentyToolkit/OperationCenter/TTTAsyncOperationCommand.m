#import "TTTAsyncOperationCommand.h"

@interface TTTAsyncOperationCommand ()
@end

@implementation TTTAsyncOperationCommand

- (id)initWithMappedOperation:(Class)operationClass completion:(TTTCompletionBlock)completion
{
    self = [super initWithMappedOperation:operationClass];

    if (self)
    {
        self.completion = completion;
    }

    return self;
}

@end