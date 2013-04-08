#import "NSMutableDictionary+TTTUnless.h"
                
@implementation NSMutableDictionary (TTTUnless)

- (void)unlessAttributePresent:(id)attribute setValue:(id)value
{
	if (self[attribute] == nil)
	{
		self[attribute] = value;
	}
}

@end