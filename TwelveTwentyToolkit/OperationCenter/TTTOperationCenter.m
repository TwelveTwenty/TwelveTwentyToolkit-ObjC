#import <TwelveTwentyToolkit/TTTOperationCommand.h>
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
        self.maxConcurrentOperationCount = 1;

        if (_defaultCenter == nil)
        {
            [[self class] setDefaultCenter:self];
        }
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

- (void)sender:(id)sender didInvokeCommand:(TTTOperationCommand *)command
{
    TTTOperation *operation = [[command.operationClass alloc] initWithCommand:command];
    [self.injector injectPropertiesIntoObject:(id <TTTInjectable>) operation];

    if (operation.requiresMainThread)
    {
        [self.mainCommandQueue addOperation:operation];
    }
    else
    {
        [self.backgroundCommandQueue addOperation:operation];
    }
}

@end