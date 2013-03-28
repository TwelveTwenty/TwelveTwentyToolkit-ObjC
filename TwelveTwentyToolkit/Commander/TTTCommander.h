#import <Foundation/Foundation.h>

@class TTTInjector;
@class TTTTrigger;

@interface TTTCommander : UIResponder

@property NSInteger maxConcurrentOperationCount;

+ (TTTCommander *)sharedTriggerCommandResponder;

+ (TTTCommander *)setSharedTriggerCommandResponder:(TTTCommander *)responder;

- (id)initWithInjector:(TTTInjector *)injector;

- (void)sender:(id)sender didInvoke:(TTTTrigger *)trigger;

@end