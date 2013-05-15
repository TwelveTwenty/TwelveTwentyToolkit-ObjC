#import <Foundation/Foundation.h>

@class TTTTableViewItem;
@class TTTTableViewSection;
@protocol TTTTableViewSection;

typedef enum
{
    TTTTableViewSectionPositionNone = 0,
    TTTTableViewSectionPositionTop = 1 << 0,
    TTTTableViewSectionPositionBottom = 1 << 1
} TTTTableViewSectionPosition;

@interface TTTTableViewDataSourceItemController : NSObject <UITableViewDataSource>

@property(nonatomic, strong) NSMutableArray *sections;
@property(nonatomic, weak) UITableView *tableView;

- (id)initWithTableView:(UITableView *)tableView;
- (id)init UNAVAILABLE_ATTRIBUTE;

- (id <TTTTableViewSection>)addSection:(id<TTTTableViewSection>)section;
- (TTTTableViewSection *)sectionAtIndex:(NSInteger)index;
- (TTTTableViewItem *)itemAtIndexPath:(NSIndexPath *)indexPath;

@end

@protocol TTTGroupedTableViewCell

- (void)setPositionInSection:(TTTTableViewSectionPosition)position;

@end