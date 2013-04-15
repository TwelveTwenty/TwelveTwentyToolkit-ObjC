#import "NSArray+TTTMapping.h"

@implementation NSArray (TTTMapping)

- (NSMutableArray *)tttMap:(id(^)(id obj, NSUInteger idx, BOOL *stop))mappingBlock
{
    NSMutableArray *map = [NSMutableArray array];
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
