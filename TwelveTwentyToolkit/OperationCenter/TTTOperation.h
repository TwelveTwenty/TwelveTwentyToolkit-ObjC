#import <Foundation/Foundation.h>
#import "TwelveTwentyToolkit.h"
#import "EEEInjector.h"

@interface TTTOperation : NSOperation

@property (nonatomic, strong) EEEInjector *injector;

@property(nonatomic) BOOL requiresMainThread;

@property(nonatomic) BOOL isInline;

- (instancetype)queue;

- (instancetype)inline;

- (void)execute OVERRIDE_ATTRIBUTE;

@end