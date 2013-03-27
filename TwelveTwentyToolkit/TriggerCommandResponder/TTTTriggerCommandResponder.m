#import "TTTInjector.h"
#import "TTTTriggerEvent.h"
#import "TTTCommand.h"
#import "TTTTriggerCommandResponder.h"

@interface TTTTriggerCommandResponder ()

@property(nonatomic, strong) TTTInjector *injector;
@property(nonatomic, strong) NSOperationQueue *commandQueue;

@end

@implementation TTTTriggerCommandResponder

- (id)initWithInjector:(TTTInjector *)injector
{
    self = [super init];

    if (self)
    {
        self.injector = injector;
        self.commandQueue = [[NSOperationQueue alloc] init];
        self.commandQueue.maxConcurrentOperationCount = 1;
    }

    return self;
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
        [self.commandQueue addOperation:command];
    }
}

@end