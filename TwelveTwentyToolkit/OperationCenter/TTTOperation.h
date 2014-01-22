#import <Foundation/Foundation.h>
#import "TwelveTwentyToolkit.h"
#import "EEEInjector.h"

@interface TTTOperation : NSOperation

@property (nonatomic, strong) EEEInjector *injector;

@property(nonatomic) BOOL requiresMainThread;

- (instancetype)queue;

- (instancetype)inline;

- (void)execute OVERRIDE_ATTRIBUTE;

@end