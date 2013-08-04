#import <TwelveTwentyToolkit/NSFetchedResultsController+TTTEasySections.h>
#import <TwelveTwentyToolkit/TTTLog.h>
#import "TTTTableViewItemController.h"
#import "TTTTableViewSection.h"
#import "TTTTableViewFetchedItem.h"
#import "TTTTableViewFetchedSection.h"

@interface TTTTableViewItemController () <TTTTableViewSectionDelegate>

@property(nonatomic, strong) NSMutableDictionary *sectionAnimations;

@end

@implementation TTTTableViewItemController
{NSMutableArray *_mirroredRowsPerSection;}

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
    NSString *key = [NSString stringWithFormat:@"%i", section];
    self.sectionAnimations[key] = @(animation);
}

#pragma mark - TTTTableViewSectionDelegate methods

- (void)mirrorRowsPerSection
{
    _mirroredRowsPerSection = [NSMutableArray array];
    for (int i = 0; i < self.tableView.numberOfSections; i++)
    {
        _mirroredRowsPerSection[i] = @([self.tableView numberOfRowsInSection:i]);
    }

    DLog(@"Mirrored: %@", [_mirroredRowsPerSection componentsJoinedByString:@","]);
}

- (void)mirrorRowAtIndexPath:(NSIndexPath *)path mode:(int)mode
{
    NSNumber *rows = _mirroredRowsPerSection[path.section];
    if (mode > 0)
    {
        _mirroredRowsPerSection[path.section] = @([rows integerValue] + 1);
        DLog(@"Added: %@", [_mirroredRowsPerSection componentsJoinedByString:@","]);
    }
    else if (mode < 0)
    {
        _mirroredRowsPerSection[path.section] = @([rows integerValue] - 1);
        DLog(@"Removed: %@", [_mirroredRowsPerSection componentsJoinedByString:@","]);
    }
}

- (void)sectionDidReload:(TTTTableViewFetchedSection *)section
{
    [self.tableView reloadData];
}

- (void)sectionWillBeginChanges:(TTTTableViewFetchedSection *)section
{
    [self mirrorRowsPerSection];
    [self.tableView beginUpdates];
}

- (void)sectionDidInsertRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self mirrorRowAtIndexPath:indexPath mode:+1];

    NSString *key = [NSString stringWithFormat:@"%i", indexPath.section];
    UITableViewRowAnimation animation = (UITableViewRowAnimation) [self.sectionAnimations[key] integerValue];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:animation];
}

- (void)sectionDidDeleteRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self mirrorRowAtIndexPath:indexPath mode:-1];

    NSString *key = [NSString stringWithFormat:@"%i", indexPath.section];
    UITableViewRowAnimation animation = (UITableViewRowAnimation) [self.sectionAnimations[key] integerValue];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:animation];
}

- (void)sectionDidUpdateRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self mirrorRowAtIndexPath:indexPath mode:0];

    TTTTableViewItem *item = [self itemAtIndexPath:indexPath];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    item.configureBlock(item, cell, indexPath);
}

- (void)sectionDidEndChanges:(TTTTableViewSection *)section
{
    [self.tableView endUpdates];
}

@end