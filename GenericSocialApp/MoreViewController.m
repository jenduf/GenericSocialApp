//
//  MoreViewController.m
//  PeggSite
//
//  Created by Jennifer Duffey on 4/4/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import "MoreViewController.h"
#import "MenuCell.h"
#import "EditProfileViewController.h"

@interface MoreViewController ()
<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *moreTableView;
@property (nonatomic, strong) NSMutableArray *menuItems;

@end

@implementation MoreViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.shouldHideLoader = YES;
    
    self.menuItems = [[NSMutableArray alloc] init];
    
    NSString *pathName = [[NSBundle mainBundle] pathForResource:@"menu" ofType:@"plist"];
	NSArray *tempArray = [NSArray arrayWithContentsOfFile:pathName];
    
    [self.menuItems addObjectsFromArray:tempArray];
    
    [self.moreTableView reloadData];
}

- (void)showControllerForIndexPath:(NSIndexPath *)indexPath
{

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - UITableView Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.menuItems.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *dict = self.menuItems[section];
    NSArray *items = dict[@"items"];
    
    return items.count;
}

/*
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, SECTION_HEIGHT)];
    footerView.backgroundColor = [UIColor whiteColor];
    
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return SECTION_HEIGHT;
}
 */

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSDictionary *dict = self.menuItems[section];
    NSString *title = [NSString stringWithFormat:@"  %@", dict[@"section"]];
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, CELL_HEADER_HEIGHT)];
    v.backgroundColor = [UIColor whiteColor];
    
    PeggLabel *label = [[PeggLabel alloc] initWithText:title color:[UIColor colorWithHexString:COLOR_BUTTON_TEXT] font:[UIFont fontWithName:FONT_PROXIMA_BOLD size:FONT_SIZE_MENU_HEADER] andFrame:CGRectMake(0, 0, tableView.width, LABEL_HEIGHT)];
    [v addSubview:label];
    [label setBottom:v.height];
    
    return v;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MenuCell *cell = [tableView dequeueReusableCellWithIdentifier:MENU_CELL_IDENTIFIER];
    
    NSDictionary *dict = self.menuItems[indexPath.section];
    NSArray *items = dict[@"items"];
    
    NSDictionary *itemDict = items[indexPath.row];
    
    cell.menuLabel.text = itemDict[@"text"];
    cell.menuImageView.image = [UIImage imageNamed:itemDict[@"icon"]];
    
    if(indexPath.section == 2 && indexPath.row == (items.count - 1))
        cell.accessoryType = UITableViewCellAccessoryNone;
    else
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Response to selected row
    switch(indexPath.section)
    {
        case 0:
        {
            [self.navController navigateToViewControllerWithIdentifier:FIND_FRIENDS_VIEW_CONTROLLER animated:YES];
        }
            break;
            
        case 1:
        {
            switch (indexPath.row)
            {
                case 0:
                    [self.navController navigateToViewControllerWithIdentifier:PUSH_NOTIFICATIONS_VIEW_CONTROLLER animated:YES];
                    break;
                    
                case 1:
                    [self.navController navigateToViewControllerWithIdentifier:SHARE_SETTINGS_VIEW_CONTROLLER animated:YES];
                    break;
                    
                default:
                    break;
            }
            
        }
            break;
            
        case 2:
        {
            switch (indexPath.row)
            {
                case 0:
                    // Help
                    [[ShareManager sharedInstance] sendEmail:PEGGSITE_HELP_EMAIL emailSubject:STRING_EMAIL_HELP_SUBJECT emailBody:@"" fromController:self];
                    break;
                    
                case 1:
                    // Feedback
                    [[ShareManager sharedInstance] sendEmail:PEGGSITE_FEEDBACK_EMAIL emailSubject:STRING_EMAIL_FEEDBACK_SUBJECT emailBody:@"" fromController:self];
                    
                    
                    // @todo Delete this. Should we also kill the terms controller files?
                    // [self.navController navigateToViewControllerWithIdentifier:TERMS_VIEW_CONTROLLER animated:YES];
                    break;
                    
                case 2:
                    [self.navController navigateToViewControllerWithIdentifier:PRIVACY_VIEW_CONTROLLER animated:YES];
                    break;
                    
                case 3:
                    [self.navController navigateToViewControllerWithIdentifier:ABOUT_VIEW_CONTROLLER animated:YES];
                    break;
                    
                case 4:
                    [[DataManager sharedInstance] logoutWithDelegate:self];
                    break;
                    
                default:
                    break;
            }
        }
            break;
    }
    
    // Reset row highlight
    [tableView deselectRowAtIndexPath:indexPath animated:false];
}

#pragma mark - DataManagerDelegate
- (void)dataManager:(DataManager *)dataManager didReturnData:(id)data
{
    switch (dataManager.requestType)
    {
            
        case RequestTypeLogout:
        {
            [self.navController logout];
        }
        break;
            
        default:
            break;
    }
}

#pragma mark - Nav Bar Visibility
- (BOOL)showNav
{
    return YES;
}

#pragma mark - Tab Bar Visibility
- (BOOL)showTabs
{
    return YES;
}

#pragma mark - Spinner Type For View
- (SpinnerType)spinnerType
{
    return SpinnerTypeP;
}

#pragma mark - Nav Bar Title
- (NSString *)title
{
    return TEXT_MORE;
}

@end
