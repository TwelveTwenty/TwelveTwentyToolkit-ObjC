#import "NSFetchedResultsController+TTTEasySections.h"
#import "TTTLog.h"
#import "TTTTableViewItemController.h"
#import "TTTTableViewSection.h"
#import "TTTTableViewFetchedItem.h"
#import "TTTTableViewFetchedSection.h"

@interface TTTTableViewItemController () <TTTTableViewSectionDelegate>

@property(nonatomic, strong) NSMutableDictionary *sectionAnimations;

@end

@implementation TTTTableViewItemController

- (id <TTTTableViewSection>)addSection:(id <TTTTableViewSection>)section
{
    [section asSection].itemController = self;

    [self setRowAnimation:UITableViewRowAnimationFade forSection:[[section asSection] index]];

    return [super addSection:section];
}

- (id)initWithTableView:(UITableView *)tableView delegate:(id <TTTTableViewItemControllerRelayDelegate>)delegate
{
    self = [super initWithTableView:tableView delegate:delegate];

    if (self)
    {
        self.sectionAnimations = [NSMutableDictionary dictionary];
    }

    return self;
}

- (void)setRowAnimation:(UITableViewRowAnimation)animation forSection:(NSInteger)section
{
    NSString *key = [NSString stringWithFormat:@"%li", (long)section];
    self.sectionAnimations[key] = @(animation);
}

#pragma mark - TTTTableViewSectionDelegate methods

- (void)sectionDidReload:(TTTTableViewFetchedSection *)section
{
    [self.tableView reloadData];
}

- (void)sectionWillBeginChanges:(TTTTableViewFetchedSection *)section
{
    [self.tableView beginUpdates];
}

- (void)sectionDidInsertRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *key = [NSString stringWithFormat:@"%li", (long)indexPath.section];
    UITableViewRowAnimation animation = (UITableViewRowAnimation) [self.sectionAnimations[key] integerValue];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:animation];
}

- (void)sectionDidDeleteRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *key = [NSString stringWithFormat:@"%li", (long)indexPath.section];
    UITableViewRowAnimation animation = (UITableViewRowAnimation) [self.sectionAnimations[key] integerValue];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:animation];
}

- (void)sectionDidUpdateRowAtIndexPath:(NSIndexPath *)indexPath
{
    TTTTableViewItem *item = [self itemAtIndexPath:indexPath];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    item.configureBlock(item, cell, indexPath);
}

- (void)sectionDidEndChanges:(TTTTableViewSection *)section
{
    [self.tableView endUpdates];
}

@end