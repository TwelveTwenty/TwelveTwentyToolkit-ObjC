#import <Foundation/Foundation.h>
#import "TwelveTwentyToolkit.h"

@class TTTTriggerEvent;

@interface TTTCommand : NSOperation

@property(nonatomic, strong) TTTTriggerEvent *trigger;

@property(nonatomic) BOOL requiresMainThread;

/**
* Override this method to extract all the properties from the trigger event you need.
* Do not hold on to the triggerEvent itself.
*/
- (id)initWithTrigger:(TTTTriggerEvent *)triggerEvent;
- (id)init UNAVAILABLE_ATTRIBUTE;

- (void)execute OVERRIDE_ATTRIBUTE;

@end