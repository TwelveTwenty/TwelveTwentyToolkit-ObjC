#import <Foundation/Foundation.h>

@class TTTInjector;

@interface TTTTriggerCommandResponder : UIResponder

@property NSInteger maxConcurrentOperationCount;

- (id)initWithInjector:(TTTInjector *)injector;

@end