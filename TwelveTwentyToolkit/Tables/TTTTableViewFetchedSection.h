#import <Foundation/Foundation.h>
#import "TTTTableViewSection.h"

@class NSFetchedResultsController;
@class TTTTableViewItemController;

@protocol TTTTableViewFetchedSection <TTTTableViewSection>

- (id <TTTTableViewFetchedSection>)configure:(TTTConfigureItemBlock)configureBlock;

- (id <TTTTableViewFetchedSection>)fixedRowHeight:(CGFloat)fixedRowHeight;

- (id <TTTTableViewFetchedSection>)dynamicRowHeight:(TTTDynamicHeightBlock)heightBlock;

- (id <TTTTableViewFetchedSection>)handleDidSelect:(TTTDidSelectItemBlock)didSelectBlock;

- (TTTTableViewFetchedSection *)asFetchedSection;

- (TTTTableViewSection *)asSection UNAVAILABLE_ATTRIBUTE;

@end

@interface TTTTableViewFetchedSection : TTTTableViewSection <TTTTableViewFetchedSection>

/** If you need to alter the fetched results controller's predicate, do it BEFORE assigning to this property */
@property(nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property(nonatomic) CGFloat rowHeight;

@property(nonatomic, strong) Class cellClass;

+ (id <TTTTableViewFetchedSection>)fetchedSectionWithCellClass:(Class)cellClass configureBlock:(TTTConfigureItemBlock)configureBlock;

- (Class)cellClassForItemAtIndex:(NSInteger)index1;

+ (id)section UNAVAILABLE_ATTRIBUTE;

@end