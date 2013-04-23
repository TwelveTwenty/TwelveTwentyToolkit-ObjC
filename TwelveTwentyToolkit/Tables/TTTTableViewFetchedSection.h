#import <Foundation/Foundation.h>
#import <TwelveTwentyToolkit/TTTTableViewSection.h>

@class NSFetchedResultsController;

@interface TTTTableViewFetchedSection : TTTTableViewSection

@property(nonatomic, strong) NSFetchedResultsController *controller;

- (void)setCellClass:(Class)cellClass height:(CGFloat)height configure:(TTTConfigureItemBlock)configureBlock didSelect:(TTTDidSelectItemBlock)didSelectBlock;

@end