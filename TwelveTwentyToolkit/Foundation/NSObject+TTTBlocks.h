#import <Foundation/Foundation.h>

@interface NSObject (TTTBlocks)

- (void)tttForKey:(id)key performBlock:(void (^)(id))block;

- (id)tttDo:(void (^)(id object))block;

@end