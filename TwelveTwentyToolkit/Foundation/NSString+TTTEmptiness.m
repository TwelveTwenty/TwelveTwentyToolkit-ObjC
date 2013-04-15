#import "NSString+TTTEmptiness.h"

@implementation NSString (TTTEmptiness)

+ (BOOL)tttIsEmpty:(NSString *)string
{
    return (string == nil) || [@"" isEqualToString:string];
}

+ (BOOL)tttIsNotEmpty:(NSString *)string
{
    return (string != nil) && ![@"" isEqualToString:string];
}

@end
