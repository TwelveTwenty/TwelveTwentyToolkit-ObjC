#import "NSFastEnumeration+TTTMapping.h"

@implementation NSObject (TTTMapping)

@end

@implementation NSArray (TTTMapping)

- (NSArray *)ttt_map:(id(^)(id obj, NSUInteger idx, BOOL *stop))mappingBlock
{
    return [self ttt_map:mappingBlock options:0];
}

- (NSArray *)ttt_map:(id(^)(id obj, NSUInteger idx, BOOL *stop))mappingBlock
             options:(NSEnumerationOptions)options
{
    NSMutableArray *map = [NSMutableArray arrayWithCapacity:self.count];

    [self ttt_mapOntoMutableObject:map withMappingBlock:mappingBlock options:options];

    return map;
}

- (NSMutableSet *)ttt_mapToSet:(id(^)(id obj, NSUInteger idx, BOOL *stop))mappingBlock
{
    NSMutableSet *map = [NSMutableSet set];

    [self ttt_mapOntoMutableObject:map withMappingBlock:mappingBlock options:0];

    return map;
}

- (void)ttt_mapOntoMutableObject:(id)object withMappingBlock:(id (^)(id obj, NSUInteger idx, BOOL *stop))mappingBlock options:(NSEnumerationOptions)options
{
    NSParameterAssert([(NSObject *) object respondsToSelector:@selector(addObject:)]);
    [self enumerateObjectsWithOptions:options usingBlock:^(id innerObj, NSUInteger innerIdx, BOOL *innerStop) {
        id mapped = mappingBlock(innerObj, innerIdx, innerStop);
        if (mapped)
        {
            [object addObject:mapped];
        }
    }];
}

@end

@implementation NSSet (TTTMapping)

- (NSMutableSet *)ttt_map:(id(^)(id obj, BOOL *stop))mappingBlock
{
    return [self ttt_map:mappingBlock options:0];
}

- (NSMutableSet *)ttt_map:(id(^)(id obj, BOOL *stop))mappingBlock options:(NSEnumerationOptions)options
{
    NSMutableSet *map = [NSMutableSet set];

    [self ttt_mapOntoMutableObject:map withMappingBlock:mappingBlock options:options];

    return map;
}

- (void)ttt_mapOntoMutableObject:(id)object withMappingBlock:(id (^)(id obj, BOOL *stop))mappingBlock options:(NSEnumerationOptions)options
{
    NSParameterAssert([(NSObject *) object respondsToSelector:@selector(addObject:)]);
    [self enumerateObjectsWithOptions:options usingBlock:^(id innerObj, BOOL *innerStop) {
        id mapped = mappingBlock(innerObj, innerStop);
        if (mapped)
        {
            [object addObject:mapped];
        }
    }];
}

@end

@implementation NSOrderedSet (TTTMapping)

- (NSMutableSet *)ttt_map:(id(^)(id obj, NSUInteger idx, BOOL *stop))mappingBlock
{
    return [self ttt_map:mappingBlock options:0];
}

- (NSMutableSet *)ttt_map:(id(^)(id obj, NSUInteger idx, BOOL *stop))mappingBlock options:(NSEnumerationOptions)options
{
    NSMutableSet *map = [NSMutableSet set];

    [self ttt_mapOntoMutableObject:map withMappingBlock:mappingBlock options:options];

    return map;
}

- (void)ttt_mapOntoMutableObject:(id)object withMappingBlock:(id (^)(id obj, NSUInteger idx, BOOL *stop))mappingBlock options:(NSEnumerationOptions)options
{
    NSParameterAssert([(NSObject *) object respondsToSelector:@selector(addObject:)]);
    [self enumerateObjectsWithOptions:options usingBlock:^(id innerObj, NSUInteger innerIdx, BOOL *innerStop) {
        id mapped = mappingBlock(innerObj, innerIdx, innerStop);
        if (mapped)
        {
            [object addObject:mapped];
        }
    }];
}

@end

@implementation NSDictionary (TTTMapping)

- (NSDictionary *)ttt_map:(id(^)(id *key, id obj))mappingBlock
{
    return [self ttt_map:mappingBlock options:0];
}

- (NSDictionary *)ttt_map:(id(^)(id *key, id obj))mappingBlock
                  options:(NSEnumerationOptions)options
{
    NSMutableDictionary *map = [NSMutableDictionary dictionaryWithCapacity:self.count];

    [self ttt_mapOntoMutableDictionary:map withMappingBlock:mappingBlock options:options];

    return map;
}

- (void)ttt_mapOntoMutableDictionary:(NSMutableDictionary *)object
                    withMappingBlock:(id (^)(id *key, id obj))mappingBlock
                             options:(NSEnumerationOptions)options
{
    [self enumerateKeysAndObjectsWithOptions:options usingBlock:^(id innerKey, id innerObj, BOOL *stop) {
        id copiedKey = [innerKey copy];
        id mapped = mappingBlock(&copiedKey, innerObj);
        if (mapped)
        {
            [object setObject:mapped forKey:copiedKey];
        }
    }];
}

@end
