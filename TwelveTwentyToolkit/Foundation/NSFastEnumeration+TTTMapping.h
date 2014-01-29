#import <Foundation/Foundation.h>

@interface NSArray (TTTMapping)

- (NSArray *)ttt_map:(id(^)(id obj, NSUInteger idx, BOOL *stop))mappingBlock;

- (NSArray *)ttt_map:(id(^)(id obj, NSUInteger idx, BOOL *stop))mappingBlock options:(NSEnumerationOptions)options;

- (NSMutableSet *)ttt_mapToSet:(id(^)(id obj, NSUInteger idx, BOOL *stop))mappingBlock;

@end

@interface NSSet (TTTMapping)

- (NSMutableSet *)ttt_map:(id(^)(id obj, BOOL *stop))mappingBlock;

- (NSMutableSet *)ttt_map:(id(^)(id obj, BOOL *stop))mappingBlock options:(NSEnumerationOptions)options;

@end

@interface NSOrderedSet (TTTMapping)

- (NSMutableSet *)ttt_map:(id(^)(id obj, NSUInteger idx, BOOL *stop))mappingBlock;

- (NSMutableSet *)ttt_map:(id(^)(id obj, NSUInteger idx, BOOL *stop))mappingBlock options:(NSEnumerationOptions)options;

- (void)ttt_mapOntoMutableObject:(id)object withMappingBlock:(id (^)(id obj, NSUInteger idx, BOOL *stop))mappingBlock options:(NSEnumerationOptions)options;

@end

@interface NSDictionary (TTTMapping)

- (NSDictionary *)ttt_map:(id(^)(id *key, id obj))mappingBlock;

- (NSDictionary *)ttt_map:(id(^)(id *key, id obj))mappingBlock options:(NSEnumerationOptions)options;

@end