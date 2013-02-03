#import <Foundation/Foundation.h>

@protocol TTCommand;
@class TTInjector;

@interface TTCommander : NSObject

@property (nonatomic) int maxUndoLevels;

- (void)invoke:(NSObject <TTCommand> *)command;

@end

@protocol TTCommand <NSObject>

- (void)execute;

@optional

- (void)undo;

// If this method is not implemented, the command will default to undo available YES
- (BOOL)undoIsAvailable;

@end;