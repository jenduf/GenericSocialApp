//
//  FriendCellTableViewCell.m
//  PeggSite
//
//  Created by Jennifer Duffey on 3/5/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import "FriendCell.h"
#import "NotificationView.h"

@implementation FriendCell

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.avatarView.avatarImageView.image = nil;
    
    self.friendLabel.text = @"";
}

- (void)setFriend:(Friend *)friend
{
    _friend = friend;
    
    self.friendLabel.text = friend.userName;
    
    if(friend.isPrivate && !(friend.isPrivateBypass))
    {
        self.friendLabel.font = [UIFont fontWithName:FONT_PROXIMA_SEMIBOLD_ITALIC size:FONT_SIZE_BODY];
    }
    
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
        self.noteView.noteLabel.text = [NSString stringWithFormat:@"%li", (long)friend.newPostCount];
    }
    else
    {
        [self.noteView setHidden:YES];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
