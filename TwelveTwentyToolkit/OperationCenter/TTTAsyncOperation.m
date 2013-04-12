#import <TwelveTwentyToolkit/TTTOperationCommand.h>
#import <TwelveTwentyToolkit/TTTAsyncOperationCommand.h>
#import <TwelveTwentyToolkit/TTTLog.h>
#import "TTTAsyncOperation.h"

@interface TTTAsyncOperation ()

@property(nonatomic, getter=isFinished) BOOL finished;
@property(nonatomic, getter=isExecuting) BOOL executing;

@property (nonatomic, readonly) TTTAsyncOperationCommand *command;

@end

@implementation TTTAsyncOperation

@dynamic command;

- (id)initWithCommand:(TTTOperationCommand *)command
{
    NSAssert([command isKindOfClass:[TTTAsyncOperationCommand class]], @"Supplied command is required to be a subclass of %@", [TTTAsyncOperationCommand class]);
    self = [super initWithCommand:command];
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
    [self dispatchCompletion:self.command.completion withSuccess:YES context:context error:nil];
}

- (void)dispatchUnsuccessfulCompletionWithError:(NSError *)error
{
    [self dispatchCompletion:self.command.completion withSuccess:NO context:nil error:error];
}

- (void)dispatchCompletion:(TTTCompletionBlock)completionBlock withSuccess:(BOOL)success context:(id)context error:(NSError *)error
{
    if (!success)
    {
        NSAssert(error != nil, @"If success is NO, you must provide an error");
        ELog(@"Operation completed unsuccessfully. Error: %@", error);
    }

    if (completionBlock != nil)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(success, context, error);
        });
    }

    self.executing = NO;
    self.finished = YES;
}

@end