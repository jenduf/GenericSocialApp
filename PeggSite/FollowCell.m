//
//  FollowCell.m
//  PeggSite
//
//  Created by Jennifer Duffey on 3/30/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import "FollowCell.h"
#import "Follower.h"

@implementation FollowCell

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.avatarView.avatarImageView.image = nil;
    self.friendName.text = @"";
}

- (void)setFriend:(Friend *)friend
{
    _friend = friend;
    
    self.friendName.text = friend.userName;
    
    if(friend.avatarName)
    {
        [self.avatarView setAvatarURL:[NSString stringWithFormat:@"%li/%@", (long)friend.userID, friend.avatarName]];
    }
    else
    {
        [self.avatarView setAvatarURL:nil];
    }
    
    [self.avatarView setEditable:NO];
    
    [self.followButton setSelected:friend.isAuthorizedFriend];
    
    if([User isCurrentUser:friend.userName])
        [self.followButton setHidden:YES];
    else
        [self.followButton setHidden:NO];
}

- (void)setFollower:(Follower *)follower
{
    _follower = follower;
    
    self.friendName.text = follower.userName;
    
    if(follower.avatarName)
    {
        [self.avatarView setAvatarURL:[NSString stringWithFormat:@"%li/%@", (long)follower.userID, follower.avatarName]];
    }
    else
    {
        [self.avatarView setAvatarURL:nil];
    }
        
    [self.followButton setSelected:follower.isAuthorizedFriend];
    
    if([User isCurrentUser:follower.userName])
        [self.followButton setHidden:YES];
    else
        [self.followButton setHidden:NO];
}

- (IBAction)followClicked:(id)sender
{
    [self.followButton setSelected:!self.followButton.selected];
    
    [self.delegate followCellDidRequestFollow:self];
}

@end
