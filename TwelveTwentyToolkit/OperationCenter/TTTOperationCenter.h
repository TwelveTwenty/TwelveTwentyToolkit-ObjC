#import <Foundation/Foundation.h>

@class TTTInjector;
@class TTTOperation;

@interface TTTOperationCenter : NSObject

@property NSInteger maxConcurrentOperationCount;

+ (TTTOperationCenter *)currentOperationCenter;

+ (TTTOperationCenter *)setCurrentOperationCenter:(TTTOperationCenter *)defaultCenter;

- (id)initWithInjector:(TTTInjector *)injector;

- (id)queueOperation:(TTTOperation *)operation;

- (id)inlineOperation:(TTTOperation *)operation;

@end