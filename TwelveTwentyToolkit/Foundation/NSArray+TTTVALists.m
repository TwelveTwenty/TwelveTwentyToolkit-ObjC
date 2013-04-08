#import "NSArray+TTTVALists.h"

@implementation NSArray (TTTVALists)

- (va_list)toVAList
{
    NSRange range = NSMakeRange(0, [self count]);

    NSMutableData* data = [NSMutableData dataWithLength: sizeof(id) * [self count]];

    [self getObjects: (__unsafe_unretained id *)data.mutableBytes range:range];

    return data.mutableBytes;
}

@end