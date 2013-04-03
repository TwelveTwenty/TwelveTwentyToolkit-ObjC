#import <Foundation/Foundation.h>
#import "TwelveTwentyToolkit.h"

@class TTTOperationCommand;

@interface TTTOperation : NSOperation
{
    id _command;
}

@property(nonatomic) BOOL requiresMainThread;

/**
* Override this method to extract all the properties from the trigger event you need.
* Do not hold on to the triggerEvent itself.
*/
- (id)initWithCommand:(TTTOperationCommand *)command;
- (id)init UNAVAILABLE_ATTRIBUTE;

- (void)setCommand:(TTTOperationCommand *)command;
- (TTTOperationCommand *)command;

- (void)execute OVERRIDE_ATTRIBUTE;

@end