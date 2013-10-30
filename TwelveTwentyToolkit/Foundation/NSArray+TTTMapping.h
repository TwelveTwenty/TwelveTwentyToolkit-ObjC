#import <Foundation/Foundation.h>

@interface NSArray (TTTMapping)

- (NSArray *)ttt_map:(id(^)(id obj, NSUInteger idx, BOOL *stop))mappingBlock;

- (NSArray *)ttt_map:(id(^)(id obj, NSUInteger idx, BOOL *stop))mappingBlock options:(NSEnumerationOptions)options;

@end

@interface NSSet (TTTMapping)

- (NSSet *)ttt_map:(id(^)(id obj, BOOL *stop))mappingBlock;

- (NSSet *)ttt_map:(id(^)(id obj, BOOL *stop))mappingBlock options:(NSEnumerationOptions)options;

@end

@interface NSDictionary (TTTMapping)

- (NSDictionary *)ttt_map:(id(^)(id *key, id obj))mappingBlock;

- (NSDictionary *)ttt_map:(id(^)(id *key, id obj))mappingBlock options:(NSEnumerationOptions)options;

@end