#import "NSMutableDictionary+TTTUnless.h"
                
@implementation NSMutableDictionary (TTTUnless)

- (void)tttUnlessAttributePresent:(id)attribute setValue:(id)value
{
	if (self[attribute] == nil)
	{
		self[attribute] = value;
	}
}

@end