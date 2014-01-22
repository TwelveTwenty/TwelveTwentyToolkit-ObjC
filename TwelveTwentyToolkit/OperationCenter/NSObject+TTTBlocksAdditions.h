//
//  TTTBlocksAdditions.h
//  PLBlocksPlayground - https://github.com/mikeash/mikeash.com-svn/tree/master/PLBlocksPlayground/
//
//  Created by Michael Ash on 8/9/09.
//  TTT-prefixes added to prevent naming collisions.
//

#import <Foundation/Foundation.h>

typedef void (^BasicBlock)(void);

void TTTRunInBackground(BasicBlock block);
void TTTRunOnMainThread(BOOL wait, BasicBlock block);
void TTTRunOnThread(NSThread *thread, BOOL wait, BasicBlock block);
void TTTRunAfterDelay(NSTimeInterval delay, BasicBlock block);
void TTTWithAutoreleasePool(BasicBlock block);

void TTTParallelized(int count, void (^block)(int i));

@interface NSLock (TTTBlocksAdditions)

- (void)ttt_whileLocked: (BasicBlock)block;

@end

@interface NSNotificationCenter (TTTBlocksAdditions)

- (void)ttt_addObserverForName:(NSString *)name object:(id)object block: (void (^)(NSNotification *note))block;

@end

@interface NSURLConnection (TTTBlocksAdditions)

+ (void)ttt_sendAsynchronousRequest:(NSURLRequest *)request completionBlock: (void (^)(NSData *data, NSURLResponse *response, NSError *error))block;

@end

