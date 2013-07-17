#import "TTTLog.h"
#import "TTTAsyncOperation.h"

@interface TTTAsyncOperation ()

@property(nonatomic, getter=isFinished) BOOL finished;
@property(nonatomic, getter=isExecuting) BOOL executing;

@property(nonatomic, strong) void (^defaultSuccessBlock)(id);
@property(nonatomic, strong) void (^defaultFailureBlock)(NSError *);

@end

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
        DLog(@"Operation cancelled.");
        return;
    }

    if (!success)
    {
        NSAssert(error != nil, @"If success is NO, you must provide an error");
    }

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