#import "NSObject+TTTUnless.h"
                
@implementation NSObject (TTTUnless)

- (void)tttUnlessAttributePresent:(id)attribute setValue:(id)value
{
	if ([self valueForKey:attribute] == nil)
	{
		[self setValue:value forKey:attribute];
	}
}

- (void)tttUnlessAttributePresent:(id)attribute performBlock:(void (^)())block
{
    if ([self valueForKey:attribute] == nil)
    {
        block();
    }
}

@end