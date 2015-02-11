//
//  NavButton.m
//  PeggSite
//
//  Created by Jennifer Duffey on 3/5/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import "NavButton.h"

@implementation NavButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)updateForState:(NavButtonState)state
{
    [self updateForState:state withAlignment:UIControlContentHorizontalAlignmentLeft];
}

- (void)updateForState:(NavButtonState)state withAlignment:(UIControlContentHorizontalAlignment)alignment
{
    [self setTag:state];
    
    [self setTitle:@"" forState:UIControlStateNormal];
    [self setImage:nil forState:UIControlStateNormal];
    [self setBackgroundColor:[UIColor clearColor]];
    [self setHidden:NO];
    self.contentHorizontalAlignment = alignment;
    self.layer.borderWidth = 0.0;
    self.layer.cornerRadius = 0.0;
    
    switch (state)
    {
            
        case NavButtonStateNone:
        {
            [self setHidden:YES];
        }
            break;
            
        case NavButtonStateBack:
        {
            [self setImage:[UIImage imageNamed:IMAGE_BACK_ICON] forState:UIControlStateNormal];
        }
            break;
            
        case NavButtonStateShortBack:
        {
            [self setImage:[UIImage imageNamed:IMAGE_SHORT_BACK_ICON] forState:UIControlStateNormal];
        }
            break;
            
        case NavButtonStateEdit:
        {
            [self setImage:[UIImage imageNamed:IMAGE_EDIT_ICON] forState:UIControlStateNormal];
        }
            break;
            
        case NavButtonStateForward:
        {
            [self setImage:[UIImage imageNamed:IMAGE_FORWARD_ICON] forState:UIControlStateNormal];
        }
            break;
            
        case NavButtonStateAddFriend:
        {
            [self setImage:[UIImage imageNamed:IMAGE_ADD_FRIEND_ICON] forState:UIControlStateNormal];
        }
            break;
            
        case NavButtonStatePanel:
        {
            [self setImage:[UIImage imageNamed:IMAGE_PANEL_ICON] forState:UIControlStateNormal];
        }
            break;
            
        case NavButtonStateHeart:
        {
            [self setImage:[UIImage imageNamed:IMAGE_HEART_ICON] forState:UIControlStateNormal];
        }
            break;
            
        case NavButtonStateSettings:
        {
            [self setImage:[UIImage imageNamed:IMAGE_SETTINGS_ICON] forState:UIControlStateNormal];
        }
            break;
            
        case NavButtonStateInfo:
        {
            [self setImage:[UIImage imageNamed:IMAGE_INFO_ICON] forState:UIControlStateNormal];
        }
            break;
            
        case NavButtonStateLogout:
        {
            [self setImage:[UIImage imageNamed:IMAGE_LOGOUT] forState:UIControlStateNormal];
        }
            break;
            
        case NavButtonStateShowDetail:
        {
            [self setImage:[UIImage imageNamed:IMAGE_SHOW_DETAIL] forState:UIControlStateNormal];
        }
            break;
            
        case NavButtonStateCancel:
        {
            [self setTitle:TEXT_CANCEL forState:UIControlStateNormal];
            [self setTitleColor:[UIColor colorWithHexString:COLOR_CANCEL_TEXT] forState:UIControlStateNormal];
          //  [self sizeToFit];
        }
            break;
            
        case NavButtonStateSave:
        {
            [self setTitle:TEXT_SAVE forState:UIControlStateNormal];
            [self setTitleColor:[UIColor colorWithHexString:COLOR_SAVE_TEXT] forState:UIControlStateNormal];
          //  [self sizeToFit];
        }
            break;
            
        case NavButtonStateDone:
        {
            [self setImage:[UIImage imageNamed:IMAGE_DONE_ICON] forState:UIControlStateNormal];
        }
            break;
            
        case NavButtonStateRefresh:
        {
            [self setImage:[UIImage imageNamed:IMAGE_REFRESH] forState:UIControlStateNormal];
        }
            break;
            
        default:
            break;
    }
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
