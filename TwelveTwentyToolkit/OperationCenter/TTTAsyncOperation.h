#import <Foundation/Foundation.h>
#import "TTTOperation.h"

/**
 * If `success` is YES, consider the completion to be flawless.
 *
 * If the async operation revolved around some kind of important object,
 * you should pass it into the `object` object, and be able to retrieve it from there.
 *
 * If `success` is NO, look at the `error` object for the reason why.
 */
typedef void (^TTTFeedbackBlock)(BOOL success, id object, NSError *error);

@interface TTTAsyncOperation : TTTOperation

@property(nonatomic, copy) TTTFeedbackBlock feedbackBlock;

- (id)initWithFeedback:(TTTFeedbackBlock)completion;

- (void)dispatchSuccessfulFeedbackWithOptionalContext:(id)context;

- (void)dispatchUnsuccessfulFeedbackWithError:(NSError *)error;

@end