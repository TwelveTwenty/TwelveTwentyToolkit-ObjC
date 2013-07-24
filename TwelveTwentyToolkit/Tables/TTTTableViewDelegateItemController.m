#import "TTTTableViewDelegateItemController.h"
#import "TTTTableViewItem.h"
#import "TTTTableViewSection.h"

typedef enum
{
    TTTDelegateOptionNone = 0,
    TTTDelegateOptionWillBeginDecelerating = 1 << 0,
    TTTDelegateOptionWillDisplayCell = 1 << 1,
    TTTDelegateOptionDidEndDisplayingCell = 1 << 2,
    TTTDelegateOptionViewForHeaderInSection = 1 << 3,
    TTTDelegateOptionViewForFooterInSection = 1 << 4,
    TTTDelegateOptionScrollViewDidScroll = 1 << 5,
    TTTDelegateOptionScrollViewWillBeginDragging = 1 << 6,
} TTTDelegateOption;

@interface TTTTableViewDelegateItemController ()

@property(nonatomic) TTTDelegateOption delegateOptions;

@property(nonatomic, weak, readwrite) id <TTTTableViewItemControllerRelayDelegate> delegate;
@end

@implementation TTTTableViewDelegateItemController

- (id)initWithTableView:(UITableView *)tableView delegate:(id <TTTTableViewItemControllerRelayDelegate>)delegate
{
    self = [super initWithTableView:tableView];

    if (self)
    {
        self.tableView.delegate = self;
        self.delegate = delegate;
    }

    return self;
}

- (void)setDelegate:(id <TTTTableViewItemControllerRelayDelegate>)delegate
{
    _delegate = delegate;

    self.delegateOptions = TTTDelegateOptionNone;

    if ([delegate respondsToSelector:@selector(scrollViewWillBeginDecelerating:)])
    {
        self.delegateOptions |= TTTDelegateOptionWillBeginDecelerating;
    }

    if ([delegate respondsToSelector:@selector(tableView:willDisplayCell:forRowAtIndexPath:)])
    {
        self.delegateOptions |= TTTDelegateOptionWillDisplayCell;
    }

    if ([delegate respondsToSelector:@selector(tableView:didEndDisplayingCell:forRowAtIndexPath:)])
    {
        self.delegateOptions |= TTTDelegateOptionDidEndDisplayingCell;
    }

    if ([delegate respondsToSelector:@selector(tableView:viewForHeaderInSection:)])
    {
        self.delegateOptions |= TTTDelegateOptionViewForHeaderInSection;
    }

    if ([delegate respondsToSelector:@selector(tableView:viewForFooterInSection:)])
    {
        self.delegateOptions |= TTTDelegateOptionViewForFooterInSection;
    }

    if ([delegate respondsToSelector:@selector(scrollViewDidScroll:)])
    {
        self.delegateOptions |= TTTDelegateOptionScrollViewDidScroll;
    }

    if ([delegate respondsToSelector:@selector(scrollViewWillBeginDragging:)])
    {
        self.delegateOptions |= TTTDelegateOptionScrollViewWillBeginDragging;
    }
}

#pragma mark - Table view delegate methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TTTTableViewItem *item = [self itemAtIndexPath:indexPath];
    CGFloat height = item.height ? item.height : tableView.rowHeight;
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TTTTableViewItem *item = [self itemAtIndexPath:indexPath];
    if (item.didSelectBlock)
    {
        item.didSelectBlock(item, indexPath);
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
        [self.delegate tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
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
        [self.delegate tableView:tableView didEndDisplayingCell:cell forRowAtIndexPath:indexPath];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat headerHeight = [[self sectionAtIndex:section] headerHeight];
    headerHeight = headerHeight >= 0 ? headerHeight : tableView.sectionHeaderHeight;
    return headerHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    TTTTableViewSection *s = [self sectionAtIndex:section];

    if (s.headerHeight)
    {
        return s.headerView;
    }

    if (self.delegateOptions & TTTDelegateOptionViewForHeaderInSection)
    {
        return [self.delegate tableView:tableView viewForHeaderInSection:section];
    }

    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    CGFloat footerHeight = [[self sectionAtIndex:section] footerHeight];
    return footerHeight >= 0 ? footerHeight : tableView.sectionFooterHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    TTTTableViewSection *s = [self sectionAtIndex:section];

    if (s.footerHeight)
    {
        return s.footerView;
    }

    if (self.delegateOptions & TTTDelegateOptionViewForFooterInSection)
    {
        return [self.delegate tableView:tableView viewForFooterInSection:section];
    }

    return nil;
}

#pragma mark - Scroll view relay delegate methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.delegateOptions & TTTDelegateOptionScrollViewDidScroll)
    {
        [self.delegate scrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (self.delegateOptions & TTTDelegateOptionScrollViewWillBeginDragging)
    {
        [self.delegate scrollViewWillBeginDragging:scrollView];
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    if (self.delegateOptions & TTTDelegateOptionWillBeginDecelerating)
    {
        [self.delegate scrollViewWillBeginDecelerating:scrollView];
    }
}

@end