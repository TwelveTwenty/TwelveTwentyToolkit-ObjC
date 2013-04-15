#import <Foundation/Foundation.h>

@class TTTTableViewItem;
@class IZOBaseTableViewCell;
@class IZOTableView;
@class IZORegistrationViewController;
@class TTTTableViewSection;

typedef enum
{
    TTTTableViewSectionPositionNone,
    TTTTableViewSectionPositionTop,
    TTTTableViewSectionPositionMiddle,
    TTTTableViewSectionPositionBottom
} TTTTableViewSectionPosition;

@interface TTTTableViewItemController : NSObject <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, weak) id <UITableViewDelegate>relayDelegate;

- (TTTTableViewSection *)sectionAtIndex:(NSInteger)index;

- (TTTTableViewSection *)addSection;

- (TTTTableViewItem *)itemAtIndexPath:(NSIndexPath *)indexPath;

@end

@protocol TTTGroupedTableViewCell

- (void)setPositionInSection:(TTTTableViewSectionPosition)position;

@end