#import "TTTLog.h"
#import "EEEInjector.h"
#import "TTTOperation.h"
#import "TTTOperationCenter.h"

@implementation TTTOperation

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.requiresMainThread = YES;
    }
    
    return self;
}

- (instancetype)queue
{
    NSParameterAssert([TTTOperationCenter currentOperationCenter]);
    [[TTTOperationCenter currentOperationCenter] queueOperation:self];
    return self;
}

- (instancetype)inline
{
    NSParameterAssert([TTTOperationCenter currentOperationCenter]);
    [[TTTOperationCenter currentOperationCenter] inlineOperation:self withTimeout:0];
    return self;
}

- (void)main
{
    [self.injector injectPropertiesIntoObject:self];
    [self execute];
}

- (void)execute
{
    // override
    [self doesNotRecognizeSelector:_cmd];
}

- (void)cancel
{
    WLog(@"Operation cancelled: %@", self);

    [super cancel];
}

@end