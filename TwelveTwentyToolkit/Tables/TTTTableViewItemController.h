#import <Foundation/Foundation.h>
#import "TTTTableViewDataSourceItemController.h"
#import "TTTTableViewDelegateItemController.h"

@interface TTTTableViewItemController : TTTTableViewDelegateItemController

- (void)setRowAnimation:(UITableViewRowAnimation)animation forSection:(NSInteger)section;

@end
