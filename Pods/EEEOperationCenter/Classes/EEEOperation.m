#import "EEEInjector.h"
#import "EEEOperation.h"
#import "EEEOperationCenter.h"

@implementation EEEOperation

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
    NSParameterAssert([EEEOperationCenter currentOperationCenter]);
    [[EEEOperationCenter currentOperationCenter] queueOperation:self];
    return self;
}

- (instancetype)inline
{
    NSParameterAssert([EEEOperationCenter currentOperationCenter]);
    [[EEEOperationCenter currentOperationCenter] inlineOperation:self withTimeout:0];
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

@end