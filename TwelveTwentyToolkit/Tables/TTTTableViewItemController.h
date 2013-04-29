#import <Foundation/Foundation.h>

@class TTTTableViewItem;
@class TTTTableViewSection;
@class TTTTableViewFetchedSection;

typedef enum
{
    TTTTableViewSectionPositionNone = 0,
    TTTTableViewSectionPositionTop = 1 << 0,
    TTTTableViewSectionPositionBottom = 1 << 1
} TTTTableViewSectionPosition;

@protocol TTTTableViewItemControllerDelegate;

@interface TTTTableViewItemController : NSObject <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, weak) id <UITableViewDelegate> relayDelegate;

@property(nonatomic, weak) id <TTTTableViewItemControllerDelegate> delegate;

@property(nonatomic) BOOL requiresReload;

- (void)reloadData;

- (TTTTableViewSection *)sectionAtIndex:(NSInteger)index;

- (TTTTableViewSection *)addSection;

- (TTTTableViewItem *)itemAtIndexPath:(NSIndexPath *)indexPath;

- (TTTTableViewFetchedSection *)addFetchedSection;

@end

@protocol TTTGroupedTableViewCell

- (void)setPositionInSection:(TTTTableViewSectionPosition)position;

@end

@protocol TTTTableViewItemControllerDelegate

- (void)tableViewItemControllerDidReloadData;

@end

