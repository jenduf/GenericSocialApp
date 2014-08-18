//
//  CommentCell.m
//  PeggSite
//
//  Created by Jennifer Duffey on 4/4/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import "CommentCell.h"
#import "Activity.h"

@implementation CommentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setActivity:(Activity *)activity
{
    _activity = activity;
    
    if(activity.avatar)
        [self.avatarView setAvatarURL:activity.avatar];
    else if(activity.activityThumbnail)
        self.commentImageView.image = activity.activityThumbnail;
    else
        [self.avatarView setAvatarURL:nil];
    
    self.userName.text = activity.userName;
    
    self.commentText.text = activity.comment;
    
    self.dateAdded.text = [Utils stringFromDate:activity.dateAdded];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
