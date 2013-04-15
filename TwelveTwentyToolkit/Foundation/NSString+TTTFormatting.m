#import "NSString+TTTFormatting.h"

@implementation NSString (TTTFormatting)

- (NSString *)formattedWith:(NSString *)arguments, ...
{
    va_list list;
    va_start(list, arguments);
    NSString *formatted = [[NSString alloc] initWithFormat:self arguments:list];
    va_end(list);
    return formatted;
}

@end