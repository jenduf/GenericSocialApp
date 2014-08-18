//
//  FollowButton.m
//  PeggSite
//
//  Created by Jennifer Duffey on 3/31/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import "FollowButton.h"

@implementation FollowButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    if(selected)
    {
        [self setButtonStyle:ButtonStyleGreen];
        [self setTitle:TEXT_FOLLOWING forState:UIControlStateNormal];
    }
    else
    {
        [self setButtonStyle:ButtonStyleBrown];
        [self setTitle:TEXT_FOLLOW forState:UIControlStateNormal];
    }
}


- (void)setIsFollowing:(BOOL)isFollowing
{
    _isFollowing = isFollowing;
    
    if(isFollowing)
    {
        [self setTitle:TEXT_FOLLOWING forState:UIControlStateNormal];
        [self setButtonStyle:ButtonStyleGreen];
    }
    else
    {
        [self setTitle:TEXT_FOLLOW forState:UIControlStateNormal];
        [self setButtonStyle:ButtonStyleBrown];
    }
    
    [self setNeedsDisplay];
}*/



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
