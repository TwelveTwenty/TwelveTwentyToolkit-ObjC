#import "NSPredicate+TTTConvenience.h"
#import "NSArray+TTTVALists.h"

@implementation NSArray (TTTVALists)

- (va_list)tttToVAList
{
    NSRange range = NSMakeRange(0, [self count]);

    NSMutableData* data = [NSMutableData dataWithLength: sizeof(id) * [self count]];

    [self getObjects: (__unsafe_unretained id *)data.mutableBytes range:range];

    return data.mutableBytes;
}

@end

@implementation NSPredicate (TTTConvenience)

+ (NSPredicate *)tttPredicateWithComplexFormat:(NSString *)complexFormat innerArguments:(NSArray *)innerArguments outerArguments:(NSArray *)outerArguments
{
    NSString *simpleFormat = [[NSString alloc] initWithFormat:complexFormat arguments:[innerArguments tttToVAList]];

    return [self predicateWithFormat:simpleFormat arguments:[outerArguments tttToVAList]];
}

@end