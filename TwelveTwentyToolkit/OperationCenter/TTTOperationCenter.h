#import <Foundation/Foundation.h>

@class TTTInjector;
@class TTTOperationCommand;

@interface TTTOperationCenter : UIResponder

@property NSInteger maxConcurrentOperationCount;

+ (TTTOperationCenter *)defaultCenter;

+ (TTTOperationCenter *)setDefaultCenter:(TTTOperationCenter *)defaultCenter;

- (id)initWithInjector:(TTTInjector *)injector;

- (void)sender:(id)sender didInvokeCommand:(TTTOperationCommand *)command;

@end