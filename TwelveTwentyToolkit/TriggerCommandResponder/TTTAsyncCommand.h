#import <Foundation/Foundation.h>
#import "TTTCommand.h"

/**
 * If `success` is YES, consider the completion to be flawless.
 *
 * If the async operation revolved around some kind of important object,
 * you should pass it into the `object` object, and be able to retrieve it from there.
 *
 * If `success` is NO, look at the `error` object for the reason why.
 */
typedef void (^TTTCompletionBlock)(BOOL success, id object, NSError *error);

@interface TTTAsyncCommand : TTTCommand

- (void)dispatchSuccessfulCompletion:(TTTCompletionBlock)completionBlock withOptionalContext:(id)context;

- (void)dispatchUnsuccessfulCompletion:(TTTCompletionBlock)completionBlock withError:(NSError *)error;

@end