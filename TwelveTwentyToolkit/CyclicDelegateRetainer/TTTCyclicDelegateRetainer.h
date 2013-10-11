#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TTTCyclicDelegateRetainer : NSObject <UIAlertViewDelegate>

/// Yes, this delegate is *strongly* referenced. It keeps the original alive until you call `breakRetainCycle`
@property (nonatomic, strong, readonly) id delegate;

- (id)initWithDelegate:(id)delegate;
- (void)breakRetainCycle;

@end