#import <Foundation/Foundation.h>

@interface NSObject (TTTBlocks)

- (void)ttt_forKey:(id)key performBlock:(void (^)(id))block;

- (id)ttt_do:(void (^)(id object))block;

@end