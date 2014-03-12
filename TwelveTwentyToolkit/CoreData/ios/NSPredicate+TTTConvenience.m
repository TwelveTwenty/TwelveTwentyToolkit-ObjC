#import "NSPredicate+TTTConvenience.h"

@implementation NSPredicate (TTTConvenience)

+ (NSPredicate *)ttt_predicateWithComplexFormat:(NSString *)complexFormat innerArguments:(NSArray *)innerArguments outerArguments:(NSArray *)outerArguments
{
    NSString *(^stringWithFormatArray)(NSString *, NSArray *) = ^(NSString *format, NSArray *array) {
        NSRange range = NSMakeRange(0, [array count]);
        NSMutableData *data = [NSMutableData dataWithLength:sizeof(id) * [array count]];
        [array getObjects:(__unsafe_unretained id *) data.mutableBytes range:range];
        return [[NSString alloc] initWithFormat:format arguments:data.mutableBytes];
    };

    NSString *simpleFormat = stringWithFormatArray(complexFormat, innerArguments);
    return [self predicateWithFormat:simpleFormat argumentArray:outerArguments ?: @[]];
}

@end