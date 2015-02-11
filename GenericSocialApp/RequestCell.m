//
//  RequestCell.m
//  PeggSite
//
//  Created by Jennifer Duffey on 5/23/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import "RequestCell.h"
#import "Request.h"

@implementation RequestCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setRequest:(Request *)request
{
    _request = request;
    
    self.friendName.text = request.userName;
    
    if(request.avatarName)
    {
        [self.avatarView setAvatarURL:[NSString stringWithFormat:@"%li/%@", (long)request.userID, request.avatarName]];
    }
    else
    {
        [self.avatarView setAvatarURL:nil];
    }
    
    [self.followButton setSelected:NO];
}


- (IBAction)choiceClicked:(id)sender
{
    NSInteger choiceIndex = [sender tag];
    
    [self.delegate requestCell:self didSelectIndex:choiceIndex];
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
