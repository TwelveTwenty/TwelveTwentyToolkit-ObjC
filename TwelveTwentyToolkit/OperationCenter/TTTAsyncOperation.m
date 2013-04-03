#import <TwelveTwentyToolkit/TTTOperationCommand.h>
#import "TTTAsyncOperation.h"

@interface TTTAsyncOperation ()

@property(nonatomic) BOOL isFinished;
@property(nonatomic) BOOL isExecuting;

@end

@implementation TTTAsyncOperation

- (id)initWithCommand:(TTTOperationCommand *)command
{
    self = [super initWithCommand:command];

    if (self)
    {
        self.isFinished = NO;
    }

    return self;
}

- (BOOL)isConcurrent
{
    return YES;
}

- (void)start
{
    [self main];
}

- (void)main
{
    self.isExecuting = YES;

    [super main];
}

- (void)dispatchSuccessfulCompletion:(TTTCompletionBlock)completionBlock withOptionalContext:(id)context
{
    [self dispatchCompletion:completionBlock withSuccess:YES context:context error:nil];
}

- (void)dispatchUnsuccessfulCompletion:(TTTCompletionBlock)completionBlock withError:(NSError *)error
{
    [self dispatchCompletion:completionBlock withSuccess:NO context:nil error:error];
}

- (void)dispatchCompletion:(TTTCompletionBlock)completionBlock withSuccess:(BOOL)success context:(id)context error:(NSError *)error
{
    if (!success)
    {
        NSAssert(error != nil, @"If success is NO, you must provide an error");
    }

    if (completionBlock == nil) return;
    dispatch_async(dispatch_get_main_queue(), ^{
        completionBlock(success, context, error);
    });

    [self willChangeValueForKey:@"isExecuting"];
    [self willChangeValueForKey:@"isFinished"];
    
    self.isExecuting = NO;
    self.isFinished = YES;
    
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
}

@end