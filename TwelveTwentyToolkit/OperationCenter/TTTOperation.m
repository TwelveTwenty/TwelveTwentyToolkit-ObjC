#import <TwelveTwentyToolkit/TTTLog.h>
#import "TTTInjector.h"
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
    [[TTTOperationCenter defaultCenter] queueOperation:self];
    return self;
}

- (instancetype)inline
{
    [[TTTOperationCenter defaultCenter] inlineOperation:self];
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