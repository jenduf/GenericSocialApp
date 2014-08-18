//
//  FacebookFriendViewController.m
//  PeggSite
//
//  Created by Jennifer Duffey on 5/28/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import "FacebookFriendViewController.h"
#import "ShareFriendCell.h"
#import "FacebookUser.h"
#import <Social/Social.h>

@interface FacebookFriendViewController ()
<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *fbFriendTableView;
@property (nonatomic, strong) NSMutableDictionary *friendDictionary;

@end

@implementation FacebookFriendViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.shouldHideLoader = YES;
    
    self.friendDictionary = [[NSMutableDictionary alloc] init];
    
    [self getFacebookUsers];
}

- (void)getFacebookUsers
{
    [self.friendDictionary removeAllObjects];
    
    [[ShareManager sharedInstance] getFriendsWithCompletionBlock:^(NSDictionary *friends, NSError *error)
     {
         [self.friendDictionary addEntriesFromDictionary:friends];
         
         [self.fbFriendTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
     }];
}

#pragma mark -
#pragma mark - UITableView Delegate Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.friendDictionary.allKeys.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *key = self.friendDictionary.allKeys[section];
    NSArray *arr = self.friendDictionary[key];
    return arr.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *key = self.friendDictionary.allKeys[section];
    PeggLabel *label = [[PeggLabel alloc] initWithText:[NSString stringWithFormat:@"  %@", key] color:[UIColor whiteColor] font:[UIFont fontWithName:FONT_PROXIMA_SEMIBOLD size:FONT_SIZE_HEADER] andFrame:CGRectMake(0, 0, tableView.width, tableView.sectionHeaderHeight)];
        label.backgroundColor = [UIColor colorWithHexString:COLOR_ORANGE_BUTTON];
        return label;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShareFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:ADD_FRIEND_CELL_IDENTIFIER];
    
    NSString *key = self.friendDictionary.allKeys[indexPath.section];
    NSArray *arr = self.friendDictionary[key];
    FacebookUser *fbUser = arr[indexPath.row];
    [cell setUser:fbUser];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return FRIEND_SECTION_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *key = self.friendDictionary.allKeys[indexPath.section];
    NSArray *arr = self.friendDictionary[key];
    FacebookUser *fbUser = arr[indexPath.row];
    
    SLComposeViewController *composeVC = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    NSString *initialTextString = [NSString stringWithFormat:@"Hey %@, I'd like to invite you to PeggSite. I think you'll love it!", fbUser.name];
    [composeVC setInitialText:initialTextString];
    [self presentViewController:composeVC animated:YES completion:^
    {
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return TEXT_FACEBOOK_FRIENDS;
}

@end
