//
//  SearchViewController.m
//  PeggSite
//
//  Created by Jennifer Duffey on 7/9/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import "SearchViewController.h"
#import "BoardViewController.h"
#import "UserCell.h"

@interface SearchViewController ()
<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;
@property (nonatomic, weak) IBOutlet UITableView *searchTableView;
@property (nonatomic, strong) NSMutableArray *searchResults;

@end

@implementation SearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.shouldHideLoader = YES;
    
    self.searchResults = [[NSMutableArray alloc] init];
    
    [self.searchBar becomeFirstResponder];
    
    //[[DataManager sharedInstance] searchUsersWithFilter:self.searchBar.text delegate:self];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - UITableView Delegate Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.searchResults.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    User *user = self.searchResults[indexPath.row];
    
    UserCell *cell = [tableView dequeueReusableCellWithIdentifier:SEARCH_USER_CELL_IDENTIFIER];
    
    [cell setUser:user];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.searchBar resignFirstResponder];
    
    User *user = self.searchResults[indexPath.row];
    
    [Friend setCurrentFriend:(Friend *)user];
    
    BoardViewController *bvc = [self.storyboard instantiateViewControllerWithIdentifier:BOARD_VIEW_CONTROLLER];
    bvc.userName = user.userName;
    [self.navController navigateToViewController:bvc animated:YES];
}

#pragma mark - UISearchBar Delegate Methods
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if(searchText.length > 0)
    {
        [[DataManager sharedInstance] searchUsersWithFilter:searchText delegate:self];
    }
    else
    {
        [self.searchResults removeAllObjects];
        [self.searchTableView reloadData];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.navController popViewController];
}

#pragma mark - DataManager Delegate Methods
- (void)dataManager:(DataManager *)dataManager didReturnData:(id)data
{
    switch (dataManager.requestType)
    {
        case RequestTypeSearchUsers:
        {
            [self.searchResults removeAllObjects];
            
            NSArray *arr = (NSArray *)data;
            NSArray *friendArray = arr[1];
            
            for(NSDictionary *dict in friendArray)
            {
                User *user = [[User alloc] initWithDictionary:dict];
                [self.searchResults addObject:user];
            }
            
            [self.searchTableView reloadData];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - Nav Bar Visibility
- (BOOL)showNav
{
    return NO;
}

#pragma mark - Tab Bar Visibility
- (BOOL)showTabs
{
    return YES;
}

#pragma mark - Spinner Type For View
- (SpinnerType)spinnerType
{
    return SpinnerTypeGray;
}

#pragma mark - Nav Bar Title
- (NSString *)title
{
    return @"";
}

@end
