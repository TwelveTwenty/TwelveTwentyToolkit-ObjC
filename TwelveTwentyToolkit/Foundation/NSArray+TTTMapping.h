#import <Foundation/Foundation.h>

@interface NSArray (TTTMapping)

- (NSMutableArray *)tttMap:(id(^)(id obj, NSUInteger idx, BOOL *stop))mappingBlock;

@end