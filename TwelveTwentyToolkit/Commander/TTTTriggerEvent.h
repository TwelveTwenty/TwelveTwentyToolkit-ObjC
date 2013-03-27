#import <Foundation/Foundation.h>

@interface TTTTriggerEvent : UIEvent

@property(readonly) Class commandClass;

- (id)initWithCommandClass:(Class)class;
- (id)init UNAVAILABLE_ATTRIBUTE;

- (void)dispatch:(id)sender;

@end