#import <Foundation/Foundation.h>

@interface TTTOperationCommand : UIEvent

@property(readonly) Class operationClass;

- (id)initWithMappedOperation:(Class)operationClass;
- (id)init UNAVAILABLE_ATTRIBUTE;

- (void)invoke;

@end