//
//  ActivityCell.h
//  PeggSite
//
//  Created by Jennifer Duffey on 4/18/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ActivityCellDelegate;

@class Activity, FollowButton, SpinnerView;
@interface ActivityCell : UITableViewCell

@property (nonatomic, weak) IBOutlet PeggLabel *activityText;
@property (nonatomic, weak) IBOutlet AvatarView *avatarView;
@property (nonatomic, strong) Activity *activity;
@property (nonatomic, weak) IBOutlet FollowButton *followButton;
@property (nonatomic, weak) IBOutlet UIButton *postButton;
@property (nonatomic, weak) IBOutlet id <ActivityCellDelegate> delegate;

- (IBAction)followClicked:(id)sender;
- (IBAction)postClicked:(id)sender;
- (IBAction)avatarClicked:(id)sender;

@end

@protocol ActivityCellDelegate

- (void)activityCellDidRequestFollow:(ActivityCell *)activityCell;
- (void)activityCell:(ActivityCell *)activityCell didRequestViewActivity:(Activity *)activity;
- (void)activityCell:(ActivityCell *)activityCell didRequestViewProfile:(NSString *)userName;

@end
