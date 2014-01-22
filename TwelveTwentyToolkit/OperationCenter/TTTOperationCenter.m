#import "TTTOperation.h"
#import "TTTOperationCenter.h"

@interface TTTOperationCenter ()

@property(nonatomic, strong) EEEInjector *injector;
@property(nonatomic, strong) NSOperationQueue *backgroundCommandQueue;
@property(nonatomic, strong) NSOperationQueue *mainCommandQueue;

@end

@implementation TTTOperationCenter

static TTTOperationCenter *_currentOperationCenter = nil;

+ (TTTOperationCenter *)currentOperationCenter
{
    return _currentOperationCenter;
}

+ (TTTOperationCenter *)setCurrentOperationCenter:(TTTOperationCenter *)defaultCenter
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

- (id)queueOperation:(TTTOperation *)operation
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

- (id)inlineOperation:(TTTOperation *)operation
{
    operation.injector = self.injector;

    NSAssert(operation.requiresMainThread == YES, @"Operations can only be executed in-line if they run on the main thread.");

    [operation start];

    return operation;
}

@end