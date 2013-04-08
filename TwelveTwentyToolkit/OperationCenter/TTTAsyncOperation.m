#import <TwelveTwentyToolkit/TTTOperationCommand.h>
#import <TwelveTwentyToolkit/TTTAsyncOperationCommand.h>
#import <TwelveTwentyToolkit/TTTLog.h>
#import "TTTAsyncOperation.h"

@interface TTTAsyncOperation ()

@property(nonatomic) BOOL isFinished;
@property(nonatomic) BOOL isExecuting;

@property (nonatomic, readonly) TTTAsyncOperationCommand *command;

@end

@implementation TTTAsyncOperation

@dynamic command;

- (id)initWithCommand:(TTTOperationCommand *)command
{
    NSAssert([command isKindOfClass:[TTTAsyncOperationCommand class]], @"Supplied command is required to be a subclass of %@", [TTTAsyncOperationCommand class]);
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