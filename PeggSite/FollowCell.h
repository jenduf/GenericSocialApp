//
//  FollowCell.h
//  PeggSite
//
//  Created by Jennifer Duffey on 3/30/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FollowButton.h"

@protocol FollowCellDelegate;

@class Follower, RequestCell;
@interface FollowCell : UITableViewCell

@property (nonatomic, strong) Friend *friend;
@property (nonatomic, strong) Follower *follower;


@property (nonatomic, weak) IBOutlet AvatarView *avatarView;
@property (nonatomic, weak) IBOutlet PeggLabel *friendName;
@property (nonatomic, weak) IBOutlet FollowButton *followButton;

@property (nonatomic, weak) IBOutlet id <FollowCellDelegate> delegate;

- (IBAction)followClicked:(id)sender;

@end

@protocol FollowCellDelegate

- (void)followCellDidRequestFollow:(FollowCell *)followCell;
- (void)requestCell:(RequestCell *)requestCell didSelectIndex:(NSInteger)index;

@end
