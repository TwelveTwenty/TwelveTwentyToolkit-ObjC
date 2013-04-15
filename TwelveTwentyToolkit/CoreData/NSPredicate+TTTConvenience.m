#import "NSPredicate+TTTConvenience.h"
#import "NSArray+TTTVALists.h"

@implementation NSPredicate (TTTConvenience)

+ (NSPredicate *)tttPredicateWithComplexFormat:(NSString *)complexFormat innerArguments:(NSArray *)innerArguments outerArguments:(NSArray *)outerArguments
{
    NSString *simpleFormat = [[NSString alloc] initWithFormat:complexFormat arguments:[innerArguments tttToVAList]];

    return [self predicateWithFormat:simpleFormat arguments:[outerArguments tttToVAList]];
}

@end