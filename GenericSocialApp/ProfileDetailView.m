//
//  FollowView.m
//  PeggSite
//
//  Created by Jennifer Duffey on 3/31/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import "ProfileDetailView.h"
#import "FollowButtonView.h"
#import "FollowSegmentView.h"

@implementation ProfileDetailView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        
    }
    
    return self;
}

- (void)setNumberFollowing:(NSInteger)numberFollowing
{
    _numberFollowing = numberFollowing;
    
    FollowButtonView *followButtonView = (FollowButtonView *)[self.followSegmentView viewWithTag:INDEX_SELECTED_FOLLOWING];
    
    followButtonView.countLabel.text = [NSString stringWithFormat:@"%lu \n FOLLOWING", (unsigned long)numberFollowing];
}

- (void)setNumberFollowedBy:(NSInteger)numberFollowedBy
{
    _numberFollowedBy = numberFollowedBy;
    
    FollowButtonView *followButtonView = (FollowButtonView *)[self.followSegmentView viewWithTag:INDEX_SELECTED_FOLLOWERS];
    
    followButtonView.countLabel.text = [NSString stringWithFormat:@"%lu \n FOLLOWERS", (unsigned long)numberFollowedBy];
}

- (void)setNumberOfRequests:(NSInteger)numberOfRequests
{
    _numberRequests = numberOfRequests;
    
    FollowButtonView *followButtonView = (FollowButtonView *)[self.followSegmentView viewWithTag:INDEX_SELECTED_REQUESTS];
    
    followButtonView.countLabel.text = [NSString stringWithFormat:@"%lu \n REQUESTS", (unsigned long)numberOfRequests];
}

- (void)setUser:(User *)user
{
    _user = user;
    
    if([User isCurrentUser:user.userName])
    {
        [self.actionButton setBackgroundImage:[UIImage imageNamed:IMAGE_EDIT_PROFILE] forState:UIControlStateNormal];
        
        [self.favoriteButton setHidden:YES];
    }
    else
    {
        if([[User currentUser] isFriend:user])
        {
            [self.actionButton setBackgroundImage:[UIImage imageNamed:IMAGE_ADD_FRIEND] forState:UIControlStateNormal];
        }
        else
        {
            [self.actionButton setBackgroundImage:[UIImage imageNamed:IMAGE_PROFILE_ADD] forState:UIControlStateNormal];
        }
        
       // [self.favoriteButton setHidden:NO];
        
        [self.favoriteButton setSelected:[[User currentUser] isFavorite:user]];
    }
    
    self.userName.text = user.userName;
    
    [self.userName sizeToFit];
    
    [self.favoriteButton setLeft:(self.userName.right + PADDING)];
    
    self.userDescription.text = user.shortBio;
    
    [self.userDescription sizeToFit];
    
    self.userLocation.text = user.location;
    
    if(user.avatarName)
    {
        [self.avatarView setAvatarURL:[NSString stringWithFormat:@"%li/%@", (long)user.userID, user.avatarName]];
    }
    else
    {
        [self.avatarView setAvatarURL:nil];
    }
    
    FollowButtonView *followerButtonView = (FollowButtonView *)[self.followSegmentView viewWithTag:INDEX_SELECTED_FOLLOWERS];
    
    FollowButtonView *followingButtonView = (FollowButtonView *)[self.followSegmentView viewWithTag:INDEX_SELECTED_FOLLOWING];
    
    FollowButtonView *requestButtonView = (FollowButtonView *)[self.followSegmentView viewWithTag:INDEX_SELECTED_REQUESTS];
    
    if(user.requests.count > 0)
    {
        [requestButtonView setHidden:NO];
        [followerButtonView setWidth:(self.followSegmentView.width / 3)];
        [followingButtonView setWidth:(self.followSegmentView.width / 3)];
        [followingButtonView setLeft:followerButtonView.right];
        [requestButtonView setWidth:(self.followSegmentView.width / 3)];
        [requestButtonView setLeft:followingButtonView.right];
        
        [self setNumberOfRequests:user.requests.count];
    }
    else
    {
        [followerButtonView setWidth:(self.followSegmentView.width / 2)];
        [followingButtonView setWidth:(self.followSegmentView.width / 2)];
        [followingButtonView setLeft:followerButtonView.right];
        [requestButtonView setHidden:YES];
    }
}

- (IBAction)tappedFavorite:(id)sender
{
    [self.favoriteButton setSelected:!self.favoriteButton.selected];
    
    [self.delegate profileDetailView:self didRequestFavoritism:self.favoriteButton.selected];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
