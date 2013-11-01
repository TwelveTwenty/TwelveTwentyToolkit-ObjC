#import "TTTOperation.h"
#import "TTTOperationCenter.h"
#import "TTTInjector.h"
#import "TTTOperation.h"

@interface TTTOperationCenter ()

@property(nonatomic, strong) TTTInjector *injector;
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

- (id)initWithInjector:(TTTInjector *)injector
{
    self = [super init];

    if (self)
    {
        self.injector = injector;
        self.backgroundCommandQueue = [[NSOperationQueue alloc] init];
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
    else
    {
        [self.backgroundCommandQueue addOperation:operation];
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