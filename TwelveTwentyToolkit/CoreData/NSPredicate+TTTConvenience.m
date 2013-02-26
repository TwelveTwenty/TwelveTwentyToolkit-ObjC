#import "NSPredicate+TTTConvenience.h"
#import "NSArray+TTTVALists.h"

@implementation NSPredicate (TTTConvenience)

+ (NSPredicate *)predicateWithComplexFormat:(NSString *)complexFormat innerArguments:(NSArray *)innerArguments outerArguments:(NSArray *)outerArguments
{
    NSString *simpleFormat = [[NSString alloc] initWithFormat:complexFormat arguments:[innerArguments toVAList]];

    return [self predicateWithFormat:simpleFormat arguments:[outerArguments toVAList]];
}

@end