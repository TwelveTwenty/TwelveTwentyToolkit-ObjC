#import "NSString+TTTEmptiness.h"

@implementation NSString (TTTEmptiness)

+ (BOOL)ttt_isEmpty:(NSString *)string
{
    return (string == nil) || [@"" isEqualToString:string];
}

+ (BOOL)ttt_isNotEmpty:(NSString *)string
{
    return (string != nil) && ![@"" isEqualToString:string];
}

@end
