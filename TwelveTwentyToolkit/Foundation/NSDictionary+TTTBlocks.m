#import "NSDictionary+TTTBlocks.h"

@implementation NSDictionary (TTTBlocks)

- (void)forAttribute:(id)attribute performBlock:(void (^)(id value))block
{
    if (self[attribute])
    {
        block(self[attribute]);
    }
}

@end