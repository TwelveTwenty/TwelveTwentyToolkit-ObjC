#import <Foundation/Foundation.h>
#import "EEEOperation.h"

#define eee_returnAfterDispatchIfCancelled { \
    if (self.isCancelled) \
    { \
        [self dispatchUnsuccessfulFeedbackWithError: \
                [NSError eee_operationCenterErrorWithCode:EEEOperationCenterErrorCodeCancelled \
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
typedef void (^EEEFeedbackBlock)(BOOL success, id object, NSError *error);

typedef void (^EEERequestSuccessBlock)(id jsonResult);

typedef void (^EEERequestFailureBlock)(NSError *error);

extern NSTimeInterval const EEENever;

@interface EEEAsyncOperation : EEEOperation

@property(nonatomic, copy) EEEFeedbackBlock feedbackBlock;
@property(nonatomic, readonly) EEERequestSuccessBlock defaultSuccessBlock;
@property(nonatomic, readonly) EEERequestFailureBlock defaultFailureBlock;
@property(nonatomic) NSTimeInterval timeout;

- (id)initWithFeedback:(EEEFeedbackBlock)feedbackBlock;

- (void)dispatchSuccessfulFeedbackWithOptionalContext:(id)context;

- (void)dispatchUnsuccessfulFeedbackWithError:(NSError *)error;

@end