#import "NSArray+TTTMapping.h"

@implementation NSArray (TTTMapping)

- (NSMutableArray *)tttMap:(id(^)(id obj, NSUInteger idx, BOOL *stop))mappingBlock
{
    NSMutableArray *map = [NSMutableArray arrayWithCapacity:self.count];

    [self enumerateObjectsUsingBlock:^(id outerObj, NSUInteger outerIdx, BOOL *outerStop) {
        id mapped = mappingBlock(outerObj, outerIdx, outerStop);
        if (mapped)
        {
            [map addObject:mapped];
        }
    }];

    return map;
}

@end

@implementation NSDictionary (TTTMapping)

- (NSMutableDictionary *)tttMap:(id(^)(id *key, id obj))mappingBlock
{
    NSMutableDictionary *map = [NSMutableDictionary dictionaryWithCapacity:self.count];

    [self enumerateKeysAndObjectsUsingBlock:^(id innerKey, id innerObj, BOOL *stop) {
        id copiedKey = [innerKey copy];
        id mapped = mappingBlock(&copiedKey, innerObj);
        if (mapped)
        {
            [map setObject:mapped forKey:copiedKey];
        }
    }];

    return map;
}

@end
