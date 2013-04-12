#import <Foundation/Foundation.h>
#import "TwelveTwentyToolkit.h"

@interface TTTOperation : NSOperation

@property(nonatomic) BOOL requiresMainThread;

- (void)queue;

- (void)execute OVERRIDE_ATTRIBUTE;

@end