#import "EEEOperationCenter.h"
#import "EEEAsyncOperation.h"

@interface EEEOperationCenter ()

@property(nonatomic, strong) EEEInjector *injector;
@property(nonatomic, strong) NSOperationQueue *backgroundCommandQueue;
@property(nonatomic, strong) NSOperationQueue *mainCommandQueue;

@end

@implementation EEEOperationCenter

static EEEOperationCenter *_currentOperationCenter = nil;

+ (EEEOperationCenter *)currentOperationCenter
{
    return _currentOperationCenter;
}

+ (EEEOperationCenter *)setCurrentOperationCenter:(EEEOperationCenter *)defaultCenter
{
    @synchronized (self)
    {
        _currentOperationCenter = defaultCenter;
    }

    return _currentOperationCenter;
}

- (id)initWithInjector:(EEEInjector *)injector
{
    self = [super init];

    if (self)
    {
        self.injector = injector;
        self.backgroundCommandQueue = [[NSOperationQueue alloc] init];
        self.backgroundCommandQueue.name = [[[NSBundle mainBundle] bundleIdentifier] stringByAppendingString:@".backgroundCommandQueue"];
        self.mainCommandQueue = [NSOperationQueue mainQueue];
    }

    return self;
}

- (NSInteger)maxConcurrentOperationCount
{
    return self.backgroundCommandQueue.maxConcurrentOperationCount;
}

- (void)setMaxConcurrentOperationCount:(NSInteger)maxConcurrentOperationCount
{
    self.backgroundCommandQueue.maxConcurrentOperationCount = maxConcurrentOperationCount;
}

- (id)queueOperation:(EEEOperation *)operation
{
    operation.injector = self.injector;

    if (operation.requiresMainThread)
    {
        [self.mainCommandQueue addOperation:operation];
    }
    else if ([[NSThread currentThread] isMainThread])
    {
        [self.backgroundCommandQueue addOperation:operation];
    }
    else
    {
        NSString *key = @"extraCommandQueue";
        NSMutableDictionary *threadDictionary = [[NSThread currentThread] threadDictionary];
        NSOperationQueue *extraQueue = threadDictionary[key];
        if (!extraQueue)
        {
            extraQueue = threadDictionary[key] = [[NSOperationQueue alloc] init];
            extraQueue.name = [[[NSBundle mainBundle] bundleIdentifier] stringByAppendingString:[[NSThread currentThread] name]];
        }
        [extraQueue addOperation:operation];
    }

    return operation;
}

- (id)inlineOperation:(EEEOperation *)operation withTimeout:(NSTimeInterval)seconds
{
    operation.injector = self.injector;
    operation.isInline = YES;

    NSDate *timeoutDate = [NSDate dateWithTimeIntervalSinceNow:seconds];

    [operation start];

    while (operation.isExecuting)
        if (seconds > EEENever && [self timeoutReached:timeoutDate])
        {
            [operation cancel];
            break;
        }

    return operation;
}

- (BOOL)timeoutReached:(NSDate *)timeoutDate
{
    [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
    NSTimeInterval timePassed = [timeoutDate timeIntervalSinceNow];
    if (timePassed < 0.0)
    {
        return YES;
    }
    return NO;
}

@end