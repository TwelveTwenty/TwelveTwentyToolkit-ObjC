#import <Foundation/Foundation.h>
#import "TwelveTwentyToolkit.h"
#import "TTTInjector.h"

@interface TTTOperation : NSOperation

@property (nonatomic, strong) TTTInjector *injector;

@property(nonatomic) BOOL requiresMainThread;

- (instancetype)queue;

- (instancetype)inline;

- (void)execute OVERRIDE_ATTRIBUTE;

@end