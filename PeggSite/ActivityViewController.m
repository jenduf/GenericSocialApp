//
//  ActivityViewController.m
//  PeggSite
//
//  Created by Jennifer Duffey on 4/4/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import "ActivityViewController.h"
#import "Activity.h"
#import "ActivityCell.h"
#import "LoaderCell.h"

@interface ActivityViewController ()
<UITableViewDataSource, UITableViewDelegate, ActivityCellDelegate>

@property (nonatomic, strong) NSMutableArray *activities;
@property (nonatomic, weak) IBOutlet UITableView *activityTableView;

@end

@implementation ActivityViewController

- (void)prepareView
{
    [super prepareView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.shouldHideLoader = YES;
    
    self.activities = [[NSMutableArray alloc] init];
    
    [self.navController activateTabBar:NO];
    
    [self reloadData];
}

- (void)reloadData
{
    [self.activities removeAllObjects];
    
    [[DataManager sharedInstance] getActivityForUser:[User currentUser].userName offset:0 delegate:self];
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
    return self.activities.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < [self.activities count])
    {
        Activity *activity = self.activities[indexPath.row];
        
        if(activity.activityType == ActivityTypeComment)
        {
            NSString *commentString = [NSString stringWithFormat:@"%@  left a comment on your post: '%@'", activity.userName, activity.comment];
            UIFont *activityFont = [UIFont fontWithName:FONT_PROXIMA_BOLD size:FONT_SIZE_ACTIVITY];
            
            NSDictionary *options = @{NSFontAttributeName: activityFont};
            CGRect boundingRect = [commentString boundingRectWithSize:CGSizeMake(tableView.width, NSIntegerMax) options:NSStringDrawingUsesLineFragmentOrigin attributes:options context:nil];
            
            return MAX(tableView.rowHeight + PADDING, boundingRect.size.height + BORDER_PADDING);
        }
    }
    
    return tableView.rowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Activity *activity = self.activities[indexPath.row];
    
    ActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:ACTIVITY_CELL_IDENTIFIER];
    
    [cell setActivity:activity];
    
    if(activity.activityType == ActivityTypeComment)
    {
        NSString *commentString = [NSString stringWithFormat:@"%@  left a comment on your post: '%@'", activity.userName, activity.comment];
        UIFont *activityFont = [UIFont fontWithName:FONT_PROXIMA_BOLD size:FONT_SIZE_ACTIVITY];
        
        NSDictionary *options = @{NSFontAttributeName: activityFont};
        CGRect boundingRect = [commentString boundingRectWithSize:CGSizeMake(tableView.width, NSIntegerMax) options:NSStringDrawingUsesLineFragmentOrigin attributes:options context:nil];
        
        cell.activityText.height = MAX(tableView.rowHeight, boundingRect.size.height + BORDER_PADDING);
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - ActivityCellDelegate Methods
- (void)activityCellDidRequestFollow:(ActivityCell *)activityCell
{
    if([[User currentUser] isFriendOfUserName:activityCell.activity.userName])
    {
        [[DataManager sharedInstance] removeFriend:activityCell.activity.userID delegate:self];
    }
    else
    {
        [[DataManager sharedInstance] addFriend:activityCell.activity.userID delegate:self];
    }
}

- (void)activityCell:(ActivityCell *)activityCell didRequestViewActivity:(Activity *)activity
{
    [self.navController showArticle:activity.articleID];
}

- (void)activityCell:(ActivityCell *)activityCell didRequestViewProfile:(NSString *)userName
{
    [self.navController showBoard:userName];
}

#pragma mark - DataManagerDelegate
- (void)dataManager:(DataManager *)dataManager didReturnData:(id)data
{
    switch (dataManager.requestType)
    {
        case RequestTypeGetUserActivity:
        {
            NSArray *arr = (NSArray *)data;
            
            NSArray *activityArray = arr[1];
            
            for(NSDictionary *dict in activityArray)
            {
                Activity *activity = [[Activity alloc] initWithDictionary:dict];
                [self.activities addObject:activity];
            }
            
            [self.activityTableView reloadData];
            
            [[DataManager sharedInstance] updateCurrentUserActivityWithDelegate:self];
        }
            break;
            
        case RequestTypeUpdateActivity:
        {
            NSLog(@"Activity updated");
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
    return TEXT_ACTIVITY;
}

@end
