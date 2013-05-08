#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class TTTTableViewItem;
@class IZOTableSectionView;
@class TTTTableViewSection;

typedef UIView *(^TTTSectionViewBlock)(TTTTableViewSection *section); // ^UIView *(UITableView *tableView, TTTTableViewSection *section)

@interface TTTTableViewSection : NSObject

@property(nonatomic) NSInteger index;
@property(nonatomic, copy) NSString *title;

@property(nonatomic) CGFloat headerHeight;
@property(nonatomic, copy) TTTSectionViewBlock headerViewBlock;
@property(nonatomic, strong) UIView *headerView;

@property(nonatomic) CGFloat footerHeight;
@property(nonatomic, copy) TTTSectionViewBlock footerViewBlock;
@property(nonatomic, strong) UIView *footerView;

- (id)initWithIndex:(NSInteger)index;

- (void)reloadData;

- (id)init UNAVAILABLE_ATTRIBUTE;

- (NSUInteger)count;

- (TTTTableViewItem *)addItem:(TTTTableViewItem *)item;

- (TTTTableViewItem *)itemAtIndex:(NSInteger)index;

- (void)addItems:(NSArray *)array;

@end