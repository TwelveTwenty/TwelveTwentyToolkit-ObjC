#import "UITableViewCell+TTTCreation.h"
#import "TTTTableViewDataSourceItemController.h"
#import "TTTTableViewItem.h"
#import "TTTTableViewSection.h"

@interface TTTTableViewDataSourceItemController ()
@end

@implementation TTTTableViewDataSourceItemController


- (id)initWithTableView:(UITableView *)tableView
{
    self = [super init];

    if (self)
    {
        self.tableView = tableView;
        self.sections = [NSMutableArray array];
        self.tableView.dataSource = self;
    }

    return self;
}

- (id <TTTTableViewSection>)addSection:(id<TTTTableViewSection>)section
{
    NSAssert(![self.sections containsObject:section], @"Section can't be added twice: %@", section);
    [(TTTTableViewSection *)section setIndex:[self.sections count]];
    [self.sections addObject:section];
    return section;
}

- (TTTTableViewSection *)sectionAtIndex:(NSInteger)index
{
    if (index >= [self.sections count]) return nil;
    if (index < 0) return nil;

    return [self.sections objectAtIndex:(NSUInteger) index];
}

- (TTTTableViewItem *)itemAtIndexPath:(NSIndexPath *)indexPath
{
    TTTTableViewSection *section = [self sectionAtIndex:(NSUInteger) indexPath.section];
    return [section itemAtIndex:(NSUInteger) indexPath.row];
}

- (NSUInteger)numberOfSections
{
    NSUInteger numberOfSections = [self.sections count];
    return numberOfSections;
}

#pragma mark - Table view data source methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfItems = [[self sectionAtIndex:(NSUInteger) section] numberOfItems];
    return numberOfItems;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TTTTableViewItem *item = [self itemAtIndexPath:indexPath];

    UITableViewCell *cell = [item.cellClass createOrDequeueFromTable:tableView];

    if (item.didSelectBlock)
    {
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    else
    {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }


    if (item.configureBlock)
    {
        item.configureBlock(item, cell, indexPath);
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

    if (!cell)
    {
        NSAssert(cell, @"Cell can't be nil for index path %@. Check who's owning this controller.", indexPath);
    }
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self sectionAtIndex:section].title;
}

@end