#import "TTTTableViewFetchedItem.h"

@implementation TTTTableViewFetchedItem

+ (id<TTTTableViewFetchedItem>)fetchedItemWithCellClass:(Class)cellClass configure:(TTTConfigureItemBlock)configureBlock
{
    return (id <TTTTableViewFetchedItem>) [super itemWithCellClass:cellClass configure:configureBlock];
}

- (TTTTableViewFetchedItem *)asFetchedItem
{
    return self;
}

- (NSString *)description
{
    NSMutableString *description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];

    [description appendFormat:@" entity=(%@)", self.fetchedEntity];

    [description appendFormat:@" %p>", &self];
    return description;
}

@end