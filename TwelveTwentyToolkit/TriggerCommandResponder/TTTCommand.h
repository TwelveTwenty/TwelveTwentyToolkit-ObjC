#import <Foundation/Foundation.h>
#import "TwelveTwentyToolkit.h"

@class TTTTrigger;

@interface TTTCommand : NSOperation

@property(nonatomic, strong) TTTTrigger *trigger;

@property(nonatomic) BOOL requiresMainThread;

/**
* Override this method to extract all the properties from the trigger event you need.
* Do not hold on to the triggerEvent itself.
*/
- (id)initWithTrigger:(TTTTrigger *)triggerEvent;
- (id)init UNAVAILABLE_ATTRIBUTE;

- (void)execute OVERRIDE_ATTRIBUTE;

@end