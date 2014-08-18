//
//  FollowView.h
//  PeggSite
//
//  Created by Jennifer Duffey on 3/31/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ProfileDetailViewDelegate;

@class FollowSegmentView;
@interface ProfileDetailView : UIView

@property (weak, nonatomic) IBOutlet PeggLabel *userName;
@property (weak, nonatomic) IBOutlet PeggLabel *userDescription;
@property (weak, nonatomic) IBOutlet AvatarView *avatarView;
@property (weak, nonatomic) IBOutlet PeggLabel *userLocation;
@property (weak, nonatomic) IBOutlet FollowSegmentView *followSegmentView;
@property (weak, nonatomic) IBOutlet PeggButton *favoriteButton, *actionButton;
@property (weak, nonatomic) IBOutlet id <ProfileDetailViewDelegate> delegate;

@property (nonatomic, strong) User *user;

@property (nonatomic, assign) NSInteger indexSelected;

@property (nonatomic, assign) NSInteger numberFollowing, numberFollowedBy, numberRequests;

- (IBAction)tappedFavorite:(id)sender;

@end

@protocol ProfileDetailViewDelegate

- (void)profileDetailView:(ProfileDetailView *)profileDetailView didRequestFavoritism:(BOOL)isFavorite;

@end
