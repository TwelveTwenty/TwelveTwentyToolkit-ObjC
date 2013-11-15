#import "NSObject+TTTUnless.h"
                
@implementation NSObject (TTTUnless)

- (void)ttt_unlessAttributePresent:(id)attribute setValue:(id)value
{
	if ([self valueForKey:attribute] == nil)
	{
		[self setValue:value forKey:attribute];
	}
}

- (void)ttt_unlessAttributePresent:(id)attribute performBlock:(void (^)())block
{
    if ([self valueForKey:attribute] == nil)
    {
        block();
    }
}

@end