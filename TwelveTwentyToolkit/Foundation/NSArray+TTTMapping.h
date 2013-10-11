#import <Foundation/Foundation.h>

@interface NSArray (TTTMapping)

- (NSMutableArray *)tttMap:(id(^)(id obj, NSUInteger idx, BOOL *stop))mappingBlock;

- (NSMutableArray *)tttMap:(id(^)(id obj, NSUInteger idx, BOOL *stop))mappingBlock options:(NSEnumerationOptions)options;
@end

@interface NSDictionary (TTTMapping)

- (NSMutableDictionary *)tttMap:(id(^)(id *key, id obj))mappingBlock;

@end