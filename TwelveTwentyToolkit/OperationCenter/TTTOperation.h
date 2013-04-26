#import <Foundation/Foundation.h>
#import "TwelveTwentyToolkit.h"

@class TTTInjector;

@interface TTTOperation : NSOperation

@property (nonatomic, strong) TTTInjector *injector;

@property(nonatomic) BOOL requiresMainThread;

- (id)queue;

- (id)inline;

- (void)execute OVERRIDE_ATTRIBUTE;

@end