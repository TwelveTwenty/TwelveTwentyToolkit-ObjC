#import <Foundation/Foundation.h>
#import "TTTTableViewSection.h"

@class NSFetchedResultsController;
@class TTTTableViewItemController;

@interface TTTTableViewFetchedSection : TTTTableViewSection

@property(nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property(nonatomic) CGFloat rowHeight;

- (void)setCellClass:(Class)cellClass height:(CGFloat)height configure:(TTTConfigureItemBlock)configureBlock didSelect:(TTTDidSelectItemBlock)didSelectBlock;

@end