#import <Foundation/Foundation.h>

@class TTTInjector;
@class TTTTrigger;

@interface TTTTriggerCommandResponder : UIResponder

@property NSInteger maxConcurrentOperationCount;

+ (TTTTriggerCommandResponder *)sharedTriggerCommandResponder;

+ (TTTTriggerCommandResponder *)setSharedTriggerCommandResponder:(TTTTriggerCommandResponder *)responder;

- (id)initWithInjector:(TTTInjector *)injector;

- (void)sender:(id)sender didInvoke:(TTTTrigger *)trigger;

@end