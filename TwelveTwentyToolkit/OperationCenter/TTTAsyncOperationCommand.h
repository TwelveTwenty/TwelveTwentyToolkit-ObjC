#import <Foundation/Foundation.h>
#import "TTTAsyncOperation.h"
#import "TTTOperationCommand.h"

@interface TTTAsyncOperationCommand : TTTOperationCommand

@property(nonatomic, copy) TTTCompletionBlock completion;

- (id)initWithMappedOperation:(Class)operationClass completion:(TTTCompletionBlock)completion;
- (id)initWithMappedOperation:(Class)operationClass UNAVAILABLE_ATTRIBUTE;
- (id)init UNAVAILABLE_ATTRIBUTE;

@end