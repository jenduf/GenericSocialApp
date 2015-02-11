//
//  FriendCollectionCell.m
//  PeggSite
//
//  Created by Jennifer Duffey on 3/30/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import "FriendCollectionCell.h"
#import "NotificationView.h"

@implementation FriendCollectionCell

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.avatarView.avatarImageView.image = nil;
    self.friendUserName.text = @"";
}

- (void)setFriend:(Friend *)friend
{
    _friend = friend;
    
    self.friendUserName.text = friend.userName;
    
    if(friend.avatarName)
    {
        [self.avatarView setAvatarURL:[NSString stringWithFormat:@"%li/%@", (long)friend.userID, friend.avatarName]];
    }
    else
    {
        [self.avatarView setAvatarURL:nil];
    }
    
    if(friend.newPostCount > 0)
    {
        self.notificationView.noteLabel.text = [NSString stringWithFormat:@"%li", (long)friend.newPostCount];
    }
    else
    {
        [self.notificationView setHidden:YES];
    }
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}


@end
