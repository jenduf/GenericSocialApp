//
//  ActivityCell.m
//  PeggSite
//
//  Created by Jennifer Duffey on 4/18/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import "ActivityCell.h"
#import "Activity.h"
#import "FollowButton.h"

@implementation ActivityCell

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    [self.postButton setBackgroundImage:nil forState:UIControlStateNormal];
    self.activityText.text = @"";
}

- (void)setActivity:(Activity *)activity
{
    _activity = activity;
    
    if(activity.avatar)
    {
        [self.avatarView setAvatarURL:[NSString stringWithFormat:@"%li/%@", (long)activity.userID, activity.avatar]];
    }
    else
    {
        [self.avatarView setAvatarURL:nil];
    }
    
    if(activity.activityType == ActivityTypeFollow)
    {
        // Only show the follow button if this was a follow
        self.followButton.hidden = NO;
        self.postButton.hidden = YES;
    }
    else
    {
        self.postButton.hidden = NO;
        self.followButton.hidden = YES;
        
        if(activity.activityThumbnail)
        {
            [self.postButton setBackgroundImage:activity.activityThumbnail forState:UIControlStateNormal];
        }
        else
        {
            [self.postButton setBackgroundImage:[UIImage imageNamed:IMAGE_DEFAULT_THUMB] forState:UIControlStateNormal];
        }
    }
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineSpacing = CAPTION_LINE_SPACING;
    paraStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;

    NSDictionary *nameAttributes = @{NSFontAttributeName : [UIFont fontWithName:FONT_PROXIMA_BOLD size:FONT_SIZE_ACTIVITY], NSForegroundColorAttributeName : [UIColor colorWithHexString:COLOR_ORANGE_BUTTON], NSParagraphStyleAttributeName : paraStyle};
    
    NSDictionary *detailAttributes = @{NSFontAttributeName : [UIFont fontWithName:FONT_PROXIMA_REGULAR size:FONT_SIZE_ACTIVITY], NSForegroundColorAttributeName : [UIColor colorWithHexString:COLOR_CAPTION_TEXT], NSParagraphStyleAttributeName : paraStyle};
    
    NSMutableAttributedString *nameAttributedString = [[NSMutableAttributedString alloc] initWithString:activity.userName attributes:nameAttributes];
    
    NSString *detailString;
    
    switch (activity.activityType)
    {
        case ActivityTypeLove:
            detailString = @" loved your post";
            break;
            
        case ActivityTypeFollow:
            detailString = @" followed you";
            break;
            
        case ActivityTypeComment:
            detailString = [NSString stringWithFormat:@" left a comment on your post: '%@'", activity.comment];
            break;
            
        case ActivityTypeMention:
            detailString = [NSString stringWithFormat:@"%@ mentioned you: %@", activity.mentionUser, activity.comment];
            break;
            
        default:
            break;
    }
    
    NSAttributedString *detailAttributedString = [[NSAttributedString alloc] initWithString:detailString attributes:detailAttributes];
    
    [nameAttributedString appendAttributedString:detailAttributedString];
    
    self.activityText.attributedText = nameAttributedString;
    
    [self.followButton setSelected:self.activity.isAuthUserFriend];
}

- (IBAction)followClicked:(id)sender
{
    [self.delegate activityCellDidRequestFollow:self];
    
    // @todo This is cheap. Much of this logic should be moved into FollowButton.m
    //      From that file, we can listen for the Notifications UserFriendDidRemove and UserFriendDidAdd
    //      and then swap the button state and properties that way. That is how it SHOULD be done.
    self.activity.isAuthUserFriend = !self.activity.isAuthUserFriend;
    [self.followButton setSelected:self.activity.isAuthUserFriend];
}

- (IBAction)postClicked:(id)sender
{
    [self.delegate activityCell:self didRequestViewActivity:self.activity];
}

- (IBAction)avatarClicked:(id)sender
{
    [self.delegate activityCell:self didRequestViewProfile:self.activity.userName];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
