#import "NSObject+TTTBlocks.h"

@implementation NSObject (TTTBlocks)

- (void)ttt_forKey:(id)key performBlock:(void (^)(id))block
{
    id value = [self valueForKey:key];
    if (value && value != [NSNull null])
    {
        block(value);
    }
}

- (id)ttt_do:(void (^)(id object))block
{
    block(self);
    return self;
}

@end