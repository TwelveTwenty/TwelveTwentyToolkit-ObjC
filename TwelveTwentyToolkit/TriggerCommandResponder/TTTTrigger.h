#import <Foundation/Foundation.h>

@interface TTTTrigger : UIEvent

@property(readonly) Class commandClass;

- (id)initWithMappedCommand:(Class)commandClass;
- (id)init UNAVAILABLE_ATTRIBUTE;

- (void)invoke;

@end