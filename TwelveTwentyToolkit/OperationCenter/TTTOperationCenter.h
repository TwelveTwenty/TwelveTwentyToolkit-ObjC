#import <Foundation/Foundation.h>

@class EEEInjector;
@class TTTOperation;

@interface TTTOperationCenter : NSObject

@property NSInteger maxConcurrentOperationCount;

+ (TTTOperationCenter *)currentOperationCenter;

+ (TTTOperationCenter *)setCurrentOperationCenter:(TTTOperationCenter *)defaultCenter;

- (id)initWithInjector:(EEEInjector *)injector;

- (id)queueOperation:(TTTOperation *)operation;

- (id)inlineOperation:(TTTOperation *)operation withTimeout:(NSTimeInterval)seconds;

@end