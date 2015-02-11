//
//  FriendListCell.m
//  PeggSite
//
//  Created by Jennifer Duffey on 3/14/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import "FriendListCell.h"

@implementation FriendListCell

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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setFriend:(Friend *)friend
{
    _friend = friend;
    
    self.friendLabel.text = friend.userName;
    
    NSURL *imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%li/%@", PEGGSITE_IMAGE_URL, (long)friend.userID, friend.avatarName]];
    
    __weak FriendListCell *weakSelf = self;
    
    [self.avatarImageView setImageWithURL:imageURL placeholderImage:nil options:SDWebImageRefreshCached completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType)
     {         // NSLog(@"Image downloaded: %f, %f", image.size.width, image.size.height);
         
         [weakSelf setNeedsLayout];
     }];
    
    if([[User currentUser] isFriend:friend])
    {
        [self.addButton setSelected:YES];
    }
    else
    {
        [self.addButton setSelected:NO];
    }
}

- (IBAction)add:(id)sender
{
    if(self.addButton.selected)
        [self.delegate friendListCellRequestedRemove:self];
    else
        [self.delegate friendListCellRequestedAdd:self];
}

@end
