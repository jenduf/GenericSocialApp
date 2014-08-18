//
//  UserCell.m
//  PeggSite
//
//  Created by Jennifer Duffey on 7/9/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import "UserCell.h"

@implementation UserCell

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.avatarView.avatarImageView.image = nil;
    
    self.userName.text = @"";
}

- (void)setUser:(User *)user
{
    _user = user;
    
    self.userName.text = user.userName;
    
    if(user.avatarName)
    {
        [self.avatarView setAvatarURL:[NSString stringWithFormat:@"%li/%@", (long)user.userID, user.avatarName]];
    }
    else
    {
        [self.avatarView setAvatarURL:nil];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
