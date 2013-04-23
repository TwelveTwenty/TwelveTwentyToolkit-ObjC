#import "UITableViewCell+TTTCreation.h"
#import "TTTTableViewItemController.h"
#import "TTTTableViewItem.h"
#import "TTTTableViewSection.h"

typedef enum
{
    TTTDelegateOptionNone = 0,
    TTTDelegateOptionWillBeginDecelerating = 1 << 0,
    TTTDelegateOptionWillDisplayCell = 1 << 1,
    TTTDelegateOptionDidEndDisplayingCell = 1 << 2,
    TTTDelegateOptionViewForHeaderInSection = 1 << 3,
    TTTDelegateOptionScrollViewDidScroll = 1 << 4
} TTTDelegateOption;

@interface TTTTableViewItemController ()

@property(nonatomic, strong) NSMutableArray *sections;

@property(nonatomic) TTTDelegateOption delegateOptions;

@end

@implementation TTTTableViewItemController

- (id)init
{
    self = [super init];

    if (self)
    {
        self.sections = [NSMutableArray array];
    }

    return self;
}

- (void)setRelayDelegate:(id <UITableViewDelegate>)relayDelegate
{
    _relayDelegate = relayDelegate;

    self.delegateOptions = TTTDelegateOptionNone;

    if ([_relayDelegate respondsToSelector:@selector(scrollViewWillBeginDecelerating:)])
    {
        self.delegateOptions |= TTTDelegateOptionWillBeginDecelerating;
    }

    if ([_relayDelegate respondsToSelector:@selector(tableView:willDisplayCell:forRowAtIndexPath:)])
    {
        self.delegateOptions |= TTTDelegateOptionWillDisplayCell;
    }

    if ([_relayDelegate respondsToSelector:@selector(tableView:didEndDisplayingCell:forRowAtIndexPath:)])
    {
        self.delegateOptions |= TTTDelegateOptionDidEndDisplayingCell;
    }

    if ([_relayDelegate respondsToSelector:@selector(tableView:viewForHeaderInSection:)])
    {
        self.delegateOptions |= TTTDelegateOptionViewForHeaderInSection;
    }

    if ([_relayDelegate respondsToSelector:@selector(scrollViewDidScroll:)])
    {
        self.delegateOptions |= TTTDelegateOptionScrollViewDidScroll;
    }
}

- (TTTTableViewSection *)sectionAtIndex:(NSInteger)index
{
    if (index >= [self.sections count]) return nil;
    if (index < 0) return nil;

    return [self.sections objectAtIndex:(NSUInteger) index];
}

- (TTTTableViewSection *)addSection
{
    TTTTableViewSection *section = [[TTTTableViewSection alloc] initWithIndex:[self.sections count]];
    [self.sections addObject:section];
    return section;
}

- (TTTTableViewItem *)itemAtIndexPath:(NSIndexPath *)indexPath
{
    TTTTableViewSection *section = [self sectionAtIndex:(NSUInteger) indexPath.section];
    return [section itemAtIndex:(NSUInteger) indexPath.row];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self sectionAtIndex:(NSUInteger) section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TTTTableViewItem *item = [self itemAtIndexPath:indexPath];
    return item.height ? item.height : tableView.rowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TTTTableViewItem *item = [self itemAtIndexPath:indexPath];

    UITableViewCell *cell = [item.cellClass createOrDequeueFromTable:tableView];

    if (item.configureBlock)
    {
        item.configureBlock(cell, indexPath);
    }

    if ([cell conformsToProtocol:@protocol(TTTGroupedTableViewCell)])
    {
        TTTTableViewSectionPosition position = TTTTableViewSectionPositionNone;

        if (indexPath.row == 0)
        {
            position |= TTTTableViewSectionPositionTop;
        }

        if (indexPath.row == [self tableView:tableView numberOfRowsInSection:indexPath.section] - 1)
        {
            position |= TTTTableViewSectionPositionBottom;
        }

        [(id <TTTGroupedTableViewCell>) cell setPositionInSection:position];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TTTTableViewItem *item = [self itemAtIndexPath:indexPath];
    if (item.didSelectBlock)
    {
        item.didSelectBlock(item, indexPath);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat headerHeight = [[self sectionAtIndex:section] headerHeight];
    return headerHeight >= 0 ? headerHeight : tableView.sectionHeaderHeight;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self sectionAtIndex:section].title;
}

#pragma mark - Relay delegate methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.delegateOptions & TTTDelegateOptionScrollViewDidScroll)
    {
        [self.relayDelegate scrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    if (self.delegateOptions & TTTDelegateOptionWillBeginDecelerating)
    {
        [self.relayDelegate scrollViewWillBeginDecelerating:scrollView];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    TTTTableViewItem *item = [self itemAtIndexPath:indexPath];
    if (item.willDisplayBlock)
    {
        item.willDisplayBlock(item, cell, indexPath);
    }
    else if (self.delegateOptions & TTTDelegateOptionWillDisplayCell)
    {
        [self.relayDelegate tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    TTTTableViewItem *item = [self itemAtIndexPath:indexPath];
    if (item.didEndDisplayingBlock)
    {
        item.didEndDisplayingBlock(item, cell, indexPath);
    }
    else if (self.delegateOptions & TTTDelegateOptionDidEndDisplayingCell)
    {
        [self.relayDelegate tableView:tableView didEndDisplayingCell:cell forRowAtIndexPath:indexPath];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    TTTTableViewSection *s = [self sectionAtIndex:section];
    if (s.headerViewBlock)
    {
        return s.headerViewBlock(tableView, s);
    }
    if (self.delegateOptions & TTTDelegateOptionViewForHeaderInSection)
    {
        return [self.relayDelegate tableView:tableView viewForHeaderInSection:section];
    }

    return nil;
}

@end