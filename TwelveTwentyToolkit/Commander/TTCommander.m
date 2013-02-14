#import "TTCommander.h"
#import "TTInjector.h"
#import "TTTLog.h"

@interface TTCommander ()

@property (nonatomic, strong) NSMutableArray *executedCommands;
@property (nonatomic, strong) TTInjector *injector;

@end

@implementation TTCommander

- (id)initWithInjector:(TTInjector *)injector
{
	self = [super init];
    
	if (self)
	{
		self.injector = injector;
		self.executedCommands = [NSMutableArray array];
		self.maxUndoLevels = 5;
	}
    
	return self;
}

- (void)invoke:(NSObject <TTCommand> *)command
{
	DLog(@"Executing %@", command);
	[[command injectWithInjector:self.injector] execute];
    
	[self.executedCommands addObject:command];
    
	while ([self.executedCommands count] > self.maxUndoLevels)
	{
		[self.executedCommands removeObjectAtIndex:0];
	}
}

- (BOOL)undoIsAvailable
{
 	id <TTCommand> lastCommand = (id <TTCommand>) [self.executedCommands lastObject];
	return ([lastCommand respondsToSelector:@selector(undoIsAvailable)] || [lastCommand undoIsAvailable]) && [lastCommand respondsToSelector:@selector(undo)];
}

- (BOOL)undo
{
    if ([self undoIsAvailable])
    {
        [(id <TTCommand>) [self.executedCommands lastObject] undo];
        [self.executedCommands removeLastObject];
        return YES;
    }
    
    return NO;
}

@end