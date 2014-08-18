//
//  TwitterViewController.m
//  PeggSite
//
//  Created by Jennifer Duffey on 5/28/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import "TwitterViewController.h"
#import "ShareFriendCell.h"

@interface TwitterViewController ()
<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *twitterTableView;
@property (nonatomic, strong) NSMutableArray *twitterUsers;

@end

@implementation TwitterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.shouldHideLoader = YES;
    
    self.twitterUsers = [[NSMutableArray alloc] init];
    
    [self getTwitterUsers];
}

- (void)getTwitterUsers
{
    [self.twitterUsers removeAllObjects];
    
    [[ShareManager sharedInstance] getTwitterFriendsWithCompletionBlock:^(NSArray *friends, NSError *error)
     {
         [self.twitterUsers addObjectsFromArray:friends];
         [self.twitterTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
     }];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.twitterUsers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShareFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:ADD_FRIEND_CELL_IDENTIFIER];
    
    TwitterUser *twitterUser = self.twitterUsers[indexPath.row];
    [cell setTwitterUser:twitterUser];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //  Friend *friend = self.user.friends[indexPath.row];
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
    return TEXT_TWITTER_FRIENDS;
}

@end
