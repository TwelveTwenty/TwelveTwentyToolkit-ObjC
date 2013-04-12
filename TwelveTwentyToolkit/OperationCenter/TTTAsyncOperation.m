#import <TwelveTwentyToolkit/TTTLog.h>
#import "TTTAsyncOperation.h"

@interface TTTAsyncOperation ()

@property(nonatomic, getter=isFinished) BOOL finished;
@property(nonatomic, getter=isExecuting) BOOL executing;

@end

@implementation TTTAsyncOperation

- (id)initWithCompletion:(TTTCompletionBlock)completionBlock
{
    self = [super init];

    if (self)
    {
        self.completion = completionBlock;
        self.requiresMainThread = NO;
    }
    return self;
}

- (BOOL)isConcurrent
{
    return YES;
}

- (void)setExecuting:(BOOL)isExecuting
{
    [self willChangeValueForKey:@"isExecuting"];
    
    _executing = isExecuting;
    
    [self didChangeValueForKey:@"isExecuting"];
}

- (void)setFinished:(BOOL)isFinished
{
    [self willChangeValueForKey:@"isFinished"];
    
    _finished = isFinished;
    
    [self didChangeValueForKey:@"isFinished"];
}

- (void)start
{
    self.executing = YES;
    
    [self main];
}

- (void)dispatchSuccessfulCompletionWithOptionalContext:(id)context
{
    [self dispatchCompletion:self.completion withSuccess:YES context:context error:nil];
}

- (void)dispatchUnsuccessfulCompletionWithError:(NSError *)error
{
    [self dispatchCompletion:self.completion withSuccess:NO context:nil error:error];
}

- (void)dispatchCompletion:(TTTCompletionBlock)completion withSuccess:(BOOL)success context:(id)context error:(NSError *)error
{
    if (!success)
    {
        NSAssert(error != nil, @"If success is NO, you must provide an error");
        ELog(@"Operation completed unsuccessfully. Error: %@", error);
    }

    if (completion != nil)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(success, context, error);
        });
    }

    self.executing = NO;
    self.finished = YES;
}

@end