#import "TTTCommander.h"
#import "TTTInjector.h"
#import "TTTLog.h"
#import "TTTTriggerEvent.h"
#import "TTTCommand.h"

@interface TTTCommander ()

@property (nonatomic, strong) TTTInjector *injector;
@property(nonatomic, strong) NSOperationQueue *commandQueue;

@end

@implementation TTTCommander

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
    TTTCommand *command = [[trigger.commandClass alloc] initWithTriggerEvent:trigger];
    [self.commandQueue addOperation:command];
}

@end