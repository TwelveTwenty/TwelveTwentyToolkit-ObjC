#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class TTTTableViewItem;
@class IZOTableSectionView;
@class TTTTableViewSection;

typedef UIView *(^TTTHeaderViewBlock)(UITableView *tableView, TTTTableViewSection *section); // ^UIView *(UITableView *tableView, TTTTableViewSection *section)

@interface TTTTableViewSection : NSObject

@property(nonatomic) NSInteger index;

@property(nonatomic, copy) NSString *title;

@property(nonatomic, copy) TTTHeaderViewBlock headerViewBlock;

- (id)initWithIndex:(NSInteger)index;
- (id)init UNAVAILABLE_ATTRIBUTE;

- (NSUInteger)count;

- (NSIndexPath *)addItem:(TTTTableViewItem *)item;

- (TTTTableViewItem *)itemAtIndex:(NSInteger)index;

- (void)addItems:(NSArray *)array;
@end