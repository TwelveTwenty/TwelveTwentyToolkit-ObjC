#import "NSFastEnumeration+TTTMapping.h"

@implementation NSArray (TTTMapping)

- (NSArray *)ttt_map:(id(^)(id obj, NSUInteger idx, BOOL *stop))mappingBlock
{
    return [self ttt_map:mappingBlock options:0];
}

- (NSArray *)ttt_map:(id(^)(id obj, NSUInteger idx, BOOL *stop))mappingBlock
             options:(NSEnumerationOptions)options
{
    NSMutableArray *map = [NSMutableArray arrayWithCapacity:self.count];

    [self enumerateObjectsWithOptions:options usingBlock:^(id innerObj, NSUInteger innerIdx, BOOL *innerStop) {
        id mapped = mappingBlock(innerObj, innerIdx, innerStop);
        if (mapped)
        {
            [map addObject:mapped];
        }
    }];

    return map;
}

@end

@implementation NSSet (TTTMapping)

- (NSSet *)ttt_map:(id(^)(id obj, BOOL *stop))mappingBlock
{
    return [self ttt_map:mappingBlock options:0];
}

- (NSSet *)ttt_map:(id(^)(id obj, BOOL *stop))mappingBlock options:(NSEnumerationOptions)options
{
    NSMutableSet *map = [NSMutableSet setWithCapacity:self.count];

    [self enumerateObjectsWithOptions:options usingBlock:^(id innerObj, BOOL *innerStop) {
        id mapped = mappingBlock(innerObj, innerStop);
        if (mapped)
        {
            [map addObject:mapped];
        }
    }];

    return map;
}

@end

@implementation NSDictionary (TTTMapping)

- (NSDictionary *)ttt_map:(id(^)(id *key, id obj))mappingBlock
{
    return [self ttt_map:mappingBlock options:0];
}

- (NSDictionary *)ttt_map:(id(^)(id *key, id obj))mappingBlock options:(NSEnumerationOptions)options
{
    NSMutableDictionary *map = [NSMutableDictionary dictionaryWithCapacity:self.count];

    [self enumerateKeysAndObjectsWithOptions:options usingBlock:^(id innerKey, id innerObj, BOOL *stop) {
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
