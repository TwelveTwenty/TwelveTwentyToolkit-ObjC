#import <Foundation/Foundation.h>
#import "TTTTableViewDataSourceItemController.h"
#import <UIKit/UIKit.h>

@protocol TTTTableViewItemControllerRelayDelegate;

@interface TTTTableViewDelegateItemController : TTTTableViewDataSourceItemController <UITableViewDelegate>

@property(nonatomic, weak) id <TTTTableViewItemControllerRelayDelegate> delegate;

@end

@protocol TTTTableViewItemControllerRelayDelegate <UITableViewDelegate>
@end