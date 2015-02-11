//
//  HomeViewController.m
//  PeggSite
//
//  Created by Jennifer Duffey on 3/3/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import "HomeViewController.h"
#import "BoardViewController.h"
#import "FriendCell.h"
#import "Activity.h"
#import "FriendCollectionCell.h"
#import "NSDate+PSFoundation.h"
#import "LoaderCell.h"
#import "CollectionLoaderCell.h"

@interface HomeViewController ()
<UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) IBOutlet UITableView *homeTableView;
@property (nonatomic, weak) IBOutlet UICollectionView *mateCollectionView;
@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;
@property (nonatomic, weak) IBOutlet UITextField *searchTextField;
@property (nonatomic, weak) IBOutlet UIButton *listButton, *iconButton, *searchButton;
@property (nonatomic, weak) IBOutlet UIView *headerView;
@property (nonatomic, assign) NSInteger currentViewType;
@property (nonatomic, strong) NSMutableArray *friends;

- (IBAction)viewTypeChanged:(id)sender;
- (IBAction)toggleSearch:(id)sender;

@end

@implementation HomeViewController

- (void)prepareView
{
    [super prepareView];
    
    [self reloadData];
}

- (void)animateView
{
    [Friend setCurrentFriend:nil];
}

- (void)reloadData
{
    [self.homeTableView reloadData];
    [self.mateCollectionView reloadData];
    
   // [[DataManager sharedInstance] getUser:[User currentUser].userName delegate:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.friends = [[NSMutableArray alloc] initWithArray:[User currentUser].friends];
    
    [self.homeTableView reloadData];
    [self.mateCollectionView reloadData];
    
    self.shouldHideLoader = YES;
}

- (void)setCurrentViewType:(NSInteger)currentViewType
{
    _currentViewType = currentViewType;
    
    [[NSUserDefaults standardUserDefaults] setInteger:currentViewType forKey:HOME_VIEW_STATE];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // update view to match stored state
    NSInteger storedState = [[NSUserDefaults standardUserDefaults] integerForKey:HOME_VIEW_STATE];
    [self updateForViewType:storedState];
}

- (IBAction)viewTypeChanged:(id)sender
{
    NSInteger index = [sender tag];
    
    [self updateForViewType:index];
}
       
- (void)updateForViewType:(NSInteger)viewType
{
    self.currentViewType = viewType;
    
    switch (viewType)
    {
       case 0:
           [self.listButton setSelected:YES];
           [self.iconButton setSelected:NO];
           // [self.searchButton setSelected:NO];
           [self.homeTableView setHidden:NO];
           [self.mateCollectionView setHidden:YES];
           break;
           
       case 1:
           [self.listButton setSelected:NO];
           [self.iconButton setSelected:YES];
           //  [self.searchButton setSelected:NO];
           [self.homeTableView setHidden:YES];
           [self.mateCollectionView setHidden:NO];
           break;
           
       default:
           break;
    }
}

#pragma mark -

- (IBAction)toggleSearch:(id)sender
{
    [self.navController navigateToViewControllerWithIdentifier:SEARCH_VIEW_CONTROLLER animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark -
#pragma mark - UITableView Delegate Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.friends.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Friend *friend;
    
    friend = self.friends[indexPath.row];
    
    FriendCell *cell = [tableView dequeueReusableCellWithIdentifier:PEGG_FRIEND_CELL_IDENTIFIER];
    
    [cell setFriend:friend];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Friend *friend;
    
    friend = self.friends[indexPath.row];
    
    [Friend setCurrentFriend:friend];
    BoardViewController *bvc = [self.storyboard instantiateViewControllerWithIdentifier:BOARD_VIEW_CONTROLLER];
    bvc.userName = friend.userName;
    [self.navController navigateToViewController:bvc animated:YES];
}

#pragma mark - UICollectionView Datasource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView*)cv
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView*)cv numberOfItemsInSection:(NSInteger)section
{
    return self.friends.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView*)cv cellForItemAtIndexPath:(NSIndexPath*)indexPath
{
    Friend *friend;
    
    friend = self.friends[indexPath.row];
    
    FriendCollectionCell *cell = [cv dequeueReusableCellWithReuseIdentifier:FRIEND_COLLECTION_CELL_IDENTIFIER forIndexPath:indexPath];
    
    [cell setFriend:friend];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    Friend *friend;
    
    friend = self.friends[indexPath.row];
    
    [Friend setCurrentFriend:friend];
    BoardViewController *avc = [self.storyboard instantiateViewControllerWithIdentifier:BOARD_VIEW_CONTROLLER];
    avc.userName = friend.userName;
    [self.navController navigateToViewController:avc animated:YES];
}

#pragma mark - DataManagerDelegate
- (void)dataManager:(DataManager *)dataManager didReturnData:(id)data
{
    switch (dataManager.requestType)
    {
        case RequestTypeGetUser:
        {
            // remove old data and fill with updated info
            [self.friends removeAllObjects];
            
            NSDictionary *dict = (NSDictionary *)data;
            
            User *user = [[User alloc] initWithDictionary:dict];
            
            [User setCurrentUser:user];
            
            [self.friends addObjectsFromArray:user.friends];
            
            [self.homeTableView reloadData];
            [self.mateCollectionView reloadData];
            
            if(user.activity && user.activity.count > 0)
            {
                Activity *activity = user.activity[0];
                
                if([user.dateViewedActivity isBefore:activity.dateAdded])
                {
                    [self.navController activateTabBar:YES];
                }
                
            }
            
            // update view to match stored state
            NSInteger storedState = [[NSUserDefaults standardUserDefaults] integerForKey:HOME_VIEW_STATE];
            
            [self updateForViewType:storedState];
            
        }
            break;
            
        case RequestTypeGetFriends:
        {
            [self.friends removeAllObjects];
            
            NSArray *arr = (NSArray *)data;
            NSArray *friendArray = arr[1];
            
            for(NSDictionary *dict in friendArray)
            {
                Friend *friend = [[Friend alloc] initWithDictionary:dict];
                [self.friends addObject:friend];
            }
            
            [self.homeTableView reloadData];
            [self.mateCollectionView reloadData];
        }
            break;
            
        case RequestTypeSetToken:
        {
            NSLog(@"Token set");
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
    return SpinnerTypeP;
}

#pragma mark - Nav Bar Title
- (NSString *)title
{
    return @"";
}

@end
