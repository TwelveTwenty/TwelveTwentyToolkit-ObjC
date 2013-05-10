#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TTTTableViewItem.h"

@class TTTTableViewSection;

typedef UIView *(^TTTSectionViewBlock)(TTTTableViewSection *section); // ^UIView *(UITableView *tableView, TTTTableViewSection *section)

@protocol TTTTableViewSectionDelegate;
@class TTTTableViewFetchedSection;

@interface TTTTableViewSection : NSObject

@property(nonatomic) NSInteger index;
@property(nonatomic, readonly) NSIndexSet *indexSet;
@property(nonatomic, readonly) NSArray *indexPaths;
@property(nonatomic, copy) NSString *title;

@property(nonatomic) CGFloat headerHeight;
@property(nonatomic, copy) TTTSectionViewBlock headerViewBlock;
@property(nonatomic, strong) UIView *headerView;

@property(nonatomic) CGFloat footerHeight;
@property(nonatomic, copy) TTTSectionViewBlock footerViewBlock;
@property(nonatomic, strong) UIView *footerView;

@property(nonatomic, weak) id <TTTTableViewSectionDelegate>delegate;

+ (id)section;

- (id)init;

- (void)loadSection;

- (NSUInteger)numberOfItems;

- (TTTTableViewItem *)addItem:(TTTTableViewItem *)item;

- (TTTTableViewItem *)itemAtIndex:(NSInteger)index;

- (void)addItems:(NSArray *)array;

@end

@protocol TTTTableViewSectionDelegate

- (void)sectionDidEndChanges:(TTTTableViewSection *)section;

- (void)sectionWillBeginChanges:(TTTTableViewFetchedSection *)section;

- (void)sectionDidInsertRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)sectionDidDeleteRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)sectionDidUpdateRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)sectionDidReload:(TTTTableViewFetchedSection *)section;

@end