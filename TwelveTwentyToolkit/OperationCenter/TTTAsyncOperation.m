#import "TTTAsyncOperation.h"
#import "NSError+TTTOperationCenter.h"

@interface TTTAsyncOperation ()

@property(nonatomic, getter=isFinished) BOOL finished;
@property(nonatomic, getter=isExecuting) BOOL executing;
@property(nonatomic, strong) NSTimer *timeoutTimer;

@property(nonatomic, strong) void (^defaultSuccessBlock)(id);
@property(nonatomic, strong) void (^defaultFailureBlock)(NSError *);

@end

NSTimeInterval const TTTNever = 0;

@implementation TTTAsyncOperation

- (void)dealloc
{
}

- (id)initWithFeedback:(TTTFeedbackBlock)feedbackBlock
{
    self = [super init];

    if (self)
    {
        self.feedbackBlock = feedbackBlock;
        self.requiresMainThread = NO;

        __strong TTTAsyncOperation *dereferencedSelf = self;
        self.defaultSuccessBlock = ^(id jsonResult) {
            if (dereferencedSelf.isCancelled) return;
            [dereferencedSelf dispatchSuccessfulFeedbackWithOptionalContext:nil];
        };

        self.defaultFailureBlock = ^(NSError *error) {
            if (dereferencedSelf.isCancelled) return;
            [dereferencedSelf dispatchUnsuccessfulFeedbackWithError:error];
        };

        self.timeout = 60;
    }
    return self;
}

- (id)init
{
    self = [self initWithFeedback:nil];
    return self;
}

- (BOOL)isConcurrent
{
    return !self.requiresMainThread;
}

- (void)setExecuting:(BOOL)isExecuting
{
    if (isExecuting && self.timeout > TTTNever)
    {
        self.timeoutTimer = [NSTimer scheduledTimerWithTimeInterval:self.timeout target:self selector:@selector(didTimeout:) userInfo:nil repeats:NO];
    }

    [self willChangeValueForKey:@"isExecuting"];

    _executing = isExecuting;

    [self didChangeValueForKey:@"isExecuting"];
}

- (void)didTimeout:(id)timer
{
    self.timeoutTimer = nil;
    [self cancel];
}

- (void)setFinished:(BOOL)isFinished
{
    if (isFinished)
    {
        [self.timeoutTimer invalidate];
        self.timeoutTimer = nil;
    }

    [self willChangeValueForKey:@"isFinished"];

    _finished = isFinished;

    [self didChangeValueForKey:@"isFinished"];
}

- (void)start
{
    if (self.isCancelled)
    {
        NSError *error = [NSError tttOperationCenterErrorWithCode:TTTOperationCenterErrorCodeCancelled description:@"Async operation was cancelled before it started."];
        [self dispatchUnsuccessfulFeedbackWithError:error];
        return;
    }

    self.executing = YES;

    [self main];
}

- (void)cancel
{
    [super cancel];

    /**
    *   From Apple's developer documentation:
    *   http://developer.apple.com/library/ios/#DOCUMENTATION/Cocoa/Reference/NSOperation_class/Reference/Reference.html#//apple_ref/doc/uid/TP40004591-RH2-SW18
    *
    *   "In addition to simply exiting when an operation is cancelled, it is also important that you move a cancelled operation
    *   to the appropriate final state. Specifically, if you manage the values for the isFinished and isExecuting properties
    *   yourself (perhaps because you are implementing a concurrent operation), you must update those variables accordingly.
    *   Specifically, you must change the value returned by isFinished to YES and the value returned by isExecuting to NO.
    *   You must make these changes even if the operation was cancelled before it started executing."
    */

    self.finished = YES;
    self.executing = NO;
}

- (void)dispatchSuccessfulFeedbackWithOptionalContext:(id)context
{
    [self dispatchFeedback:self.feedbackBlock withSuccess:YES context:context error:nil];
}

- (void)dispatchUnsuccessfulFeedbackWithError:(NSError *)error
{
    [self dispatchFeedback:self.feedbackBlock withSuccess:NO context:nil error:error];
}

- (void)dispatchFeedback:(TTTFeedbackBlock)feedback withSuccess:(BOOL)success context:(id)context error:(NSError *)error
{
    if (self.isCancelled)
    {
        error = [NSError tttOperationCenterErrorWithCode:TTTOperationCenterErrorCodeCancelled description:@"Async operation was cancelled during execution."];
        success = NO;
    }

    if (!success) NSParameterAssert(error != nil);

    if (feedback != nil)
    {
        if ([[NSThread currentThread] isMainThread])
        {
            feedback(success, context, error);
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                feedback(success, context, error);
            });
        }
    }

    self.defaultSuccessBlock = nil;
    self.defaultFailureBlock = nil;

    self.executing = NO;
    self.finished = YES;
}

@end