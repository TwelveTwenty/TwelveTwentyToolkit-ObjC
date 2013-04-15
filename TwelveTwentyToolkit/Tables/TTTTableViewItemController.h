#import <Foundation/Foundation.h>

@class TTTTableViewItem;
@class IZOBaseTableViewCell;
@class IZOTableView;
@class IZORegistrationViewController;
@class TTTTableViewSection;

@interface TTTTableViewItemController : NSObject <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, weak) id <UITableViewDelegate>relayDelegate;

- (TTTTableViewSection *)sectionAtIndex:(NSInteger)index;

- (TTTTableViewSection *)addSection;

- (TTTTableViewItem *)itemAtIndexPath:(NSIndexPath *)indexPath;

@end