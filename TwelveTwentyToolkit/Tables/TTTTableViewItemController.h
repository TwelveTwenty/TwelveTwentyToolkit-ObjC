#import <Foundation/Foundation.h>

@class TTTTableViewItem;
@class IZOBaseTableViewCell;
@class IZOTableView;
@class IZORegistrationViewController;
@class TTTTableViewSection;

typedef enum
{
    TTTTableViewSectionPositionNone = 0,
    TTTTableViewSectionPositionTop = 1 << 0,
    TTTTableViewSectionPositionBottom = 1 << 1
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