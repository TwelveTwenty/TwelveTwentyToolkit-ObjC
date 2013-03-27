#import <Foundation/Foundation.h>

@interface TTTTriggerEvent : UIEvent

@property(readonly) Class commandClass;

- (id)initWithMappedCommand:(Class)commandClass;
- (id)init UNAVAILABLE_ATTRIBUTE;

- (void)trigger:(id)sender;

@end