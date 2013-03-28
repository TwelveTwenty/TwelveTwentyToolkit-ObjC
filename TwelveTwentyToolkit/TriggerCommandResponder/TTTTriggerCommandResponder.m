#import "TTTInjector.h"
#import "TTTTrigger.h"
#import "TTTCommand.h"
#import "TTTTriggerCommandResponder.h"

@interface TTTTriggerCommandResponder ()

@property(nonatomic, strong) TTTInjector *injector;
@property(nonatomic, strong) NSOperationQueue *backgroundCommandQueue;

@end

@implementation TTTTriggerCommandResponder

static TTTTriggerCommandResponder *_shared = nil;

+ (TTTTriggerCommandResponder *)sharedTriggerCommandResponder
{
	return _shared;
}

+ (TTTTriggerCommandResponder *)setSharedTriggerCommandResponder:(TTTTriggerCommandResponder *)responder
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shared = responder;
    });

    return _shared;
}

- (id)initWithInjector:(TTTInjector *)injector
{
    self = [super init];

    if (self)
    {
        self.injector = injector;
        self.backgroundCommandQueue = [[NSOperationQueue alloc] init];
        self.maxConcurrentOperationCount = 1;
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

- (void)sender:(id)sender didInvoke:(TTTTrigger *)trigger
{
    TTTCommand *command = [[trigger.commandClass alloc] initWithTrigger:trigger];
    [self.injector injectPropertiesIntoObject:(id <TTTInjectable>) command];

    if (command.requiresMainThread)
    {
        [[NSOperationQueue mainQueue] addOperation:command];
    }
    else
    {
        [self.backgroundCommandQueue addOperation:command];
    }
}

@end