#import <mach-o/loader.h>
#import <TwelveTwentyToolkit/NSFetchedResultsController+TTTEasySections.h>
#import "TTTTableViewItemController.h"
#import "TTTTableViewSection.h"
#import "TTTTableViewFetchedItem.h"
#import "TTTTableViewFetchedSection.h"

@interface TTTTableViewItemController () <TTTTableViewSectionDelegate>
@end

@implementation TTTTableViewItemController

- (id <TTTTableViewSection>)addSection:(id<TTTTableViewSection>)section
{
    [section asSection].itemController = self;
    return [super addSection:section];
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
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)sectionDidDeleteRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
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