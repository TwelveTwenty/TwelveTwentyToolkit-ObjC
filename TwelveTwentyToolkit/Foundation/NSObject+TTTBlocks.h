#import <Foundation/Foundation.h>

@interface NSObject (TTTBlocks)

- (void)tttForKey:(id)key performBlock:(void (^)(id))block;

- (void)tttDo:(void (^)(id))block;
@end