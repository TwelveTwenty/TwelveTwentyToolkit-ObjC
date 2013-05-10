#import "TTTTableViewFetchedItem.h"

@implementation TTTTableViewFetchedItem

- (NSString *)description
{
    NSMutableString *description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];

    [description appendFormat:@" entity=(%@)", self.fetchedEntity];

    [description appendFormat:@" %p>", &self];
    return description;
}

@end