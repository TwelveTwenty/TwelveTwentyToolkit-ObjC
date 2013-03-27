#import "TTTInjector.h"
#import "TTTTriggerEvent.h"
#import "TTTCommand.h"
#import "TTTTriggerCommandResponder.h"

@interface TTTTriggerCommandResponder ()

@property(nonatomic, strong) TTTInjector *injector;
@property(nonatomic, strong) NSOperationQueue *backgroundCommandQueue;

@end

@implementation TTTTriggerCommandResponder

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

- (void)sender:(id)sender didTrigger:(TTTTriggerEvent *)trigger
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