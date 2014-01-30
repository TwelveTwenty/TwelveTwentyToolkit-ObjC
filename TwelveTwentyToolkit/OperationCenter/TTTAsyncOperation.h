#import <Foundation/Foundation.h>
#import "TTTOperation.h"

#define ttt_returnAfterDispatchIfCancelled { \
    if (self.isCancelled) \
    { \
        [self dispatchUnsuccessfulFeedbackWithError: \
                [NSError ttt_operationCenterErrorWithCode:TTTOperationCenterErrorCodeCancelled \
                                              description:[NSString stringWithFormat:@"Operation cancelled during execution %@.m:%i", \
                                                                                     NSStringFromClass([self class]), \
                                                                                     __LINE__]]]; \
        return; \
    } \
}

/**
 * If `success` is YES, consider the completion to be flawless.
 *
 * If the async operation revolved around some kind of important object,
 * you should pass it into the `object` object, and be able to retrieve it from there.
 *
 * If `success` is NO, look at the `error` object for the reason why.
 */
typedef void (^TTTFeedbackBlock)(BOOL success, id object, NSError *error);

typedef void (^TTTRequestSuccessBlock)(id jsonResult);

typedef void (^TTTRequestFailureBlock)(NSError *error);

extern NSTimeInterval const TTTNever;

@interface TTTAsyncOperation : TTTOperation

@property(nonatomic, copy) TTTFeedbackBlock feedbackBlock;
@property(nonatomic, readonly) TTTRequestSuccessBlock defaultSuccessBlock;
@property(nonatomic, readonly) TTTRequestFailureBlock defaultFailureBlock;
@property(nonatomic) NSTimeInterval timeout;

- (id)initWithFeedback:(TTTFeedbackBlock)feedbackBlock;

- (void)dispatchSuccessfulFeedbackWithOptionalContext:(id)context;

- (void)dispatchUnsuccessfulFeedbackWithError:(NSError *)error;

@end