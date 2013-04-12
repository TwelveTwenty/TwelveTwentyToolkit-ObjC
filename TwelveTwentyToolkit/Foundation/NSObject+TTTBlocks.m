#import "NSObject+TTTBlocks.h"

@implementation NSObject (TTTBlocks)

- (void)tttForKey:(id)key performBlock:(void (^)(id))block
{
    id value = [self valueForKey:key];
    if (value && value != [NSNull null])
    {
        block(value);
    }
}

- (void)tttDo:(void (^)(id object))block
{
    block(self);
}

@end