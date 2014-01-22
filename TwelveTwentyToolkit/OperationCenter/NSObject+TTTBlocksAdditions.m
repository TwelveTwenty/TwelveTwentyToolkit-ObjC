//
//  TTTBlocksAdditions.m
//  PLBlocksPlayground
//
//  Created by Michael Ash on 8/9/09.
//

#import "NSObject+TTTBlocksAdditions.h"

@implementation NSObject (BlocksAdditions)

- (void)ttt_callBlock
{
    void (^block)(void) = (id)self;
    block();
}

- (void)ttt_callBlockWithObject: (id)obj
{
    void (^block)(id obj) = (id)self;
    block(obj);
}

@end

void TTTRunInBackground(BasicBlock block)
{
    [NSThread detachNewThreadSelector:@selector(ttt_callBlock) toTarget:[block copy] withObject:nil];
}

void TTTRunOnMainThread(BOOL wait, BasicBlock block)
{
    [[block copy] performSelectorOnMainThread:@selector(ttt_callBlock) withObject:nil waitUntilDone:wait];
}

void TTTRunOnThread(NSThread *thread, BOOL wait, BasicBlock block)
{
    [[block copy] performSelector:@selector(ttt_callBlock) onThread:thread withObject:nil waitUntilDone:wait];
}

void TTTRunAfterDelay(NSTimeInterval delay, BasicBlock block)
{
    [[block copy] performSelector:@selector(ttt_callBlock) withObject:nil afterDelay:delay];
}

void TTTWithAutoreleasePool(BasicBlock block)
{
    @autoreleasepool{
        block();
    }
}

void TTTParallelized(int count, void (^block)(int i))
{
    for(int i = 0; i < count; i++)
        TTTRunInBackground(^{block(i);});
}

@implementation NSLock (TTTBlocksAdditions)

- (void)ttt_whileLocked: (BasicBlock)block
{
    [self lock];
    @try
    {
        block();
    }
    @finally
    {
        [self unlock];
    }
}

@end

@implementation NSNotificationCenter (TTTBlocksAdditions)

- (void)ttt_addObserverForName:(NSString *)name object:(id)object block: (void (^)(NSNotification *note))block
{
    [self addObserver:[block copy] selector:@selector(ttt_callBlockWithObject:) name:name object:object];
}

@end

@implementation NSURLConnection (TTTBlocksAdditions)

+ (void)ttt_sendAsynchronousRequest:(NSURLRequest *)request completionBlock: (void (^)(NSData *data, NSURLResponse *response, NSError *error))block
{
    NSThread *originalThread = [NSThread currentThread];

    TTTRunInBackground(^{
        TTTWithAutoreleasePool(^{
            NSURLResponse *response = nil;
            NSError *error = nil;
            NSData *data = [self sendSynchronousRequest:request returningResponse:&response error:&error];
            TTTRunOnThread(originalThread, NO, ^{block(data, response, error);});
        });
    });
}

@end

