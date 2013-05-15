#import <Foundation/Foundation.h>
#import "TTTTableViewDataSourceItemController.h"
#import <UIKit/UIKit.h>

@protocol TTTTableViewItemControllerRelayDelegate;

@interface TTTTableViewDelegateItemController : TTTTableViewDataSourceItemController <UITableViewDelegate>

@property(nonatomic, weak, readonly) id <TTTTableViewItemControllerRelayDelegate> delegate;

- (id)initWithTableView:(UITableView *)tableView delegate:(id <TTTTableViewItemControllerRelayDelegate>)delegate;
- (id)initWithTableView:(UITableView *)tableView UNAVAILABLE_ATTRIBUTE;

@end

@protocol TTTTableViewItemControllerRelayDelegate <UITableViewDelegate>
@end