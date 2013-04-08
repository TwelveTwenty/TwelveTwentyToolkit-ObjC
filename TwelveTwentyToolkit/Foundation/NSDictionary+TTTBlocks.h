#import <Foundation/Foundation.h>

@interface NSDictionary (TTTBlocks)

- (void)forAttribute:(id)attribute performBlock:(void (^)(id value))block;

@end