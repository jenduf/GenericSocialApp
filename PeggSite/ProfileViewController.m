//
//  ProfileViewController.m
//  PeggSite
//
//  Created by Jennifer Duffey on 3/30/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import "ProfileViewController.h"
#import "EditProfileViewController.h"
#import "BoardViewController.h"
#import "Follower.h"
#import "Request.h"
#import "FollowCell.h"
#import "RequestCell.h"
#import "FollowButton.h"
#import "ProfileDetailView.h"
#import "FollowSegmentView.h"
#import "LoaderCell.h"

@interface ProfileViewController ()
<UITableViewDataSource, UITableViewDelegate, FollowCellDelegate, FollowSegmentViewDelegate, ProfileDetailViewDelegate>

@property (nonatomic, weak) IBOutlet ProfileDetailView *profileDetailView;
@property (nonatomic, weak) IBOutlet UITableView *profileTableView;
@property (nonatomic, assign) NSInteger indexSelected;
@property (nonatomic, strong) User *user;

- (IBAction)tappedSegment:(id)sender;
- (IBAction)tappedAction:(id)sender;

@end

@implementation ProfileViewController

- (void)prepareView
{
    [super prepareView];
}

- (void)animateView
{
    if ([User isCurrentUser:self.userName])
    {
        self.user = [User currentUser];
        [self.profileDetailView setUser:self.user];
        [self.profileTableView reloadData];
    }
    else
    {
        [self reloadData];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.indexSelected = INDEX_SELECTED_FOLLOWERS;
}

- (void)reloadData
{
    [[DataManager sharedInstance] getUser:self.userName delegate:self];
}

- (NSInteger)getRowCountForSelectedSection
{
    NSInteger rowCount = 0;
    
    switch (self.indexSelected)
    {
        case INDEX_SELECTED_FOLLOWERS:
            rowCount = self.user.followers.count;
            break;
            
        case INDEX_SELECTED_FOLLOWING:
            rowCount = self.user.friends.count;
            break;
            
        case INDEX_SELECTED_REQUESTS:
            rowCount = self.user.requests.count;
            break;
            
            
        default:
            break;
    }
    
    return rowCount;
}

- (IBAction)tappedSegment:(UIGestureRecognizer *)recognizer
{
    UIView *v = recognizer.view;
    self.indexSelected = v.tag;
    
    [self.profileDetailView setIndexSelected:self.indexSelected];
    
    [self.profileTableView reloadData];
}

- (IBAction)tappedAction:(id)sender
{
    if([User isCurrentUser:self.userName])
    {
        EditProfileViewController *epvc = [self.storyboard instantiateViewControllerWithIdentifier:EDIT_PROFILE_VIEW_CONTROLLER];
        [self.navController showModalViewController:epvc];
    }
    else
    {
        if([[User currentUser] isFriend:self.user])
        {
            [[DataManager sharedInstance] removeFriend:self.user.userID delegate:self];
        }
        else
        {
            [[DataManager sharedInstance] addFriend:self.user.userID delegate:self];
        }
    }
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
    return [self getRowCountForSelectedSection];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.indexSelected == INDEX_SELECTED_REQUESTS)
    {
        RequestCell *requestCell = [tableView dequeueReusableCellWithIdentifier:REQUEST_CELL_IDENTIFIER];
        [requestCell setRequest:self.user.requests[indexPath.row]];
        
        return requestCell;
    }
    
    FollowCell *cell = [tableView dequeueReusableCellWithIdentifier:FOLLOW_CELL_IDENTIFIER];
    
    if(self.indexSelected == INDEX_SELECTED_FOLLOWERS)
    {
        Follower *follower = self.user.followers[indexPath.row];
        [cell setFollower:follower];
    }
    else
    {
        Friend *friend = self.user.friends[indexPath.row];
        [cell setFriend:friend];
    }
    
    return cell;
}

// Navigate to the users board who was tapped
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (self.indexSelected)
    {
        case INDEX_SELECTED_REQUESTS:
        {
            Request *request = self.user.requests[indexPath.row];
            [Friend setCurrentFriend:(Friend *)request];
            [self.navController showBoard:request.userName];
        }
            break;
            
        case INDEX_SELECTED_FOLLOWERS:
        {
            Follower *follower = self.user.followers[indexPath.row];
            [Friend setCurrentFriend:(Friend *)follower];
            [self.navController showBoard:follower.userName];
        }
            break;
            
        case INDEX_SELECTED_FOLLOWING:
        {
            Friend *friend = self.user.friends[indexPath.row];
            [Friend setCurrentFriend:friend];
            [self.navController showBoard:friend.userName];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - FollowViewDelegate Methods
- (void)profileDetailView:(ProfileDetailView *)profileDetailView didRequestFavoritism:(BOOL)isFavorite
{
    [[DataManager sharedInstance] updateFavoritedFriend:self.user isFavorite:isFavorite delegate:self];
}

#pragma mark - FollowCellDelegate Methods
- (void)followCellDidRequestFollow:(FollowCell *)followCell
{
    BOOL isFriend = NO;
    NSInteger friendID = 0;
    
    switch (self.indexSelected)
    {
        case INDEX_SELECTED_FOLLOWERS:
        {
            isFriend = followCell.follower.isAuthorizedFriend;
            friendID = followCell.follower.userID;
        }
            break;
            
        case INDEX_SELECTED_FOLLOWING:
        {
            isFriend = followCell.friend.isAuthorizedFriend;
            friendID = followCell.friend.userID;
        }
            break;
            
        default:
            break;
    }
    
    if(isFriend)
    {
        [[DataManager sharedInstance] removeFriend:friendID delegate:self];
    }
    else
    {
        [[DataManager sharedInstance] addFriend:friendID delegate:self];
    }
}

- (void)requestCell:(RequestCell *)requestCell didSelectIndex:(NSInteger)index
{
    if(index == INDEX_SELECTED_ACCEPT)
    {
        [[DataManager sharedInstance] acceptRequest:requestCell.request.userID delegate:self];
    }
    else
    {
        [[DataManager sharedInstance] declineRequest:requestCell.request.userID delegate:self];
    }
}

#pragma mark - FollowSegmentViewDelegate Methods
- (void)followSegmentSelected:(NSInteger)segmentIndex
{
    self.indexSelected = segmentIndex;
    
    [self.profileTableView reloadData];
}

#pragma mark - DataManagerDelegate
- (void)dataManager:(DataManager *)dataManager didReturnData:(id)data
{
    switch (dataManager.requestType)
    {
        case RequestTypeGetUser:
        {
            NSDictionary *dict = (NSDictionary *)data;
            User *user = [[User alloc] initWithDictionary:dict];
            
            if([user.userName isEqualToString:self.userName])
            {
                self.user = user;
            }
            else
            {
                if([user.userName isEqualToString:[User currentUser].userName])
                {
                    [User setCurrentUser:user];
                }
            }
            
            [self.profileDetailView setUser:self.user];
            
            [self.profileTableView reloadData];
            
            //[[DataManager sharedInstance] getFriendsForUser:self.userName delegate:self];
        }
            break;
            /*
        case RequestTypeGetFriends:
        {
            NSArray *arr = (NSArray *)data;
            NSArray *friendArray = arr[1];
            
            NSMutableArray *allFriends = [NSMutableArray array];
            
            for(NSDictionary *dict in friendArray)
            {
                Friend *friend = [[Friend alloc] initWithDictionary:dict];
                [allFriends addObject:friend];
            }
            
            [self.profileDetailView setNumberFollowing:allFriends.count];
            
            self.friendDictionary[KEY_FOLLOWING] = allFriends;
            
            [[DataManager sharedInstance] getFriendsOfUser:self.userName delegate:self];
            
            self.shouldHideLoader = YES;
        }
            break;
            
        case RequestTypeGetFollowers:
        {
            NSArray *arr = (NSArray *)data;
            NSArray *followerArray = arr[1];
            
            NSMutableArray *allFollowers = [NSMutableArray array];
            
            for(NSDictionary *dict in followerArray)
            {
                Follower *follower = [[Follower alloc] initWithDictionary:dict];
                [allFollowers addObject:follower];
            }
            
            [self.profileDetailView setNumberFollowedBy:allFollowers.count];
            
            self.friendDictionary[KEY_FOLLOWERS] = allFollowers;
            
            [self.profileTableView reloadData];
        }
            break;
           */ 
        case RequestTypeAddFriend:
        case RequestTypeRemoveFriend:
        case RequestTypeRequestAcceptFriend:
        case RequestTypeRequestDeclineFriend:
        case RequestTypeFavoritedFriend:
        {
            [[DataManager sharedInstance] getUser:[User currentUser].userName delegate:self];
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
    return TEXT_PROFILE;
}

@end
