#import "TTTAbstractJSONMapping.h"

@interface TTTAbstractJSONMapping ()
@end

@implementation TTTAbstractJSONMapping

- (NSString *)description
{
	return [NSString stringWithFormat:@"<%@: %p - %@ -> %@>", [self class], &self, self.JSONKey, self.entityKey];
}

@end