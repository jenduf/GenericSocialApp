//
//  FacebookFriendCell.m
//  PeggSite
//
//  Created by Jennifer Duffey on 3/25/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import "ShareFriendCell.h"
#import "FacebookUser.h"
#import "TwitterUser.h"

@implementation ShareFriendCell

- (void)setUser:(FacebookUser *)user
{
    _user = user;
    
    self.friendLabel.text = user.name;
    [self.twitterImageView setHidden:YES];
    [self.pictureView setHidden:NO];
    [self.pictureView setProfileID:user.userID];
}

- (void)setTwitterUser:(TwitterUser *)twitterUser
{
    _twitterUser = twitterUser;
    
    self.friendLabel.text = twitterUser.name;
    [self.pictureView setHidden:YES];
    [self.twitterImageView setHidden:NO];
    
    NSURL *imageURL = [NSURL URLWithString:twitterUser.imageURL];
    
    __weak ShareFriendCell *weakSelf = self;
    
    [self.twitterImageView setImageWithURL:imageURL placeholderImage:nil options:SDWebImageRefreshCached completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType)
     {
         //NSLog(@"Image downloaded: %f, %f", image.size.width, image.size.height);
         
         [weakSelf setNeedsLayout];
     }];
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
