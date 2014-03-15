#import "NSPredicate+TTTConvenience.h"

@implementation NSPredicate (TTTConvenience)

+ (NSPredicate *)ttt_predicateWithComplexFormat:(NSString *)complexFormat innerArguments:(NSArray *)innerArguments outerArguments:(NSArray *)outerArguments
{
    NSString *simpleFormat = nil;
    switch ([innerArguments count])
    {
        case 0:
            simpleFormat = [NSString stringWithFormat:complexFormat, nil];
            break;
        case 1:
            simpleFormat = [NSString stringWithFormat:complexFormat, innerArguments[0]];
            break;
        case 2:
            simpleFormat = [NSString stringWithFormat:complexFormat, innerArguments[0], innerArguments[1]];
            break;
        case 3:
            simpleFormat = [NSString stringWithFormat:complexFormat, innerArguments[0], innerArguments[1], innerArguments[2]];
            break;
        case 4:
            simpleFormat = [NSString stringWithFormat:complexFormat, innerArguments[0], innerArguments[1], innerArguments[2], innerArguments[3]];
            break;
        case 5:
            simpleFormat = [NSString stringWithFormat:complexFormat, innerArguments[0], innerArguments[1], innerArguments[2], innerArguments[3], innerArguments[4]];
            break;
        default:
            NSParameterAssert(simpleFormat);
            return nil;
    }

    return [self predicateWithFormat:simpleFormat argumentArray:outerArguments ?: @[]];
}

@end