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

static TTTOperationCenter *_defaultCenter = nil;

+ (TTTOperationCenter *)defaultCenter
{
    return _defaultCenter;
}

+ (TTTOperationCenter *)setDefaultCenterWithInjector:(TTTInjector *)injector
{
    if (injector)
    {
        NSAssert(_defaultCenter == nil, @"Can't setup default center if it's already set up.");
    }

    return [self setDefaultCenter:[[self alloc] initWithInjector:injector]];
}

+ (TTTOperationCenter *)setDefaultCenter:(TTTOperationCenter *)defaultCenter
{
    @synchronized (self)
    {
        _defaultCenter = defaultCenter;
    }

    return _defaultCenter;
}

- (id)initWithInjector:(TTTInjector *)injector
{
    self = [super init];

    if (self)
    {
        self.injector = injector;
        self.backgroundCommandQueue = [[NSOperationQueue alloc] init];
        self.mainCommandQueue = [NSOperationQueue mainQueue];
        self.maxConcurrentOperationCount = 2;
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

- (void)queueOperation:(TTTOperation *)operation
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
}

- (void)inlineOperation:(TTTOperation *)operation
{
    operation.injector = self.injector;

    NSAssert(operation.requiresMainThread == YES, @"Operations can only be executed in-line if they run on the main thread.");

    [operation start];
}

@end