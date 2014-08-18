//
//  NavBarView.m
//  PeggSite
//
//  Created by Jennifer Duffey on 3/5/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import "NavBarView.h"
#import "NavButton.h"
#import "TitleView.h"
#import "Divider.h"

@implementation NavBarView

- (void)setEditMode:(BOOL)editMode
{
    _editMode = editMode;
    
    if([User isCurrentUser:self.user.userName])
    {
        [self.leftButton updateForState:NavButtonStateNone];
        
        if(self.addMode)
        {
            [self.rightButton updateForState:NavButtonStateNone];
        }
        else
        {
            if(editMode)
            {
                [self.rightButton updateForState:NavButtonStateDone withAlignment:UIControlContentHorizontalAlignmentRight];
            }
            else
            {
                [self.rightButton updateForState:NavButtonStateEdit withAlignment:UIControlContentHorizontalAlignmentRight];
            }
        }
    }
}

- (void)setAddMode:(BOOL)addMode
{
    _addMode = addMode;
    
    if(self.currentNavState == NavStateBoard)
    {
        if(addMode)
        {
            [self.rightButton updateForState:NavButtonStateNone];
        }
        else
        {
            if(self.editMode)
            {
                [self.rightButton updateForState:NavButtonStateDone withAlignment:UIControlContentHorizontalAlignmentRight];
            }
            else
            {
                [self.rightButton updateForState:NavButtonStateEdit withAlignment:UIControlContentHorizontalAlignmentRight];
            }
        }
    }
    
}

- (void)setUser:(User *)user
{
    _user = user;
    
    if([User isCurrentUser:user.userName])
    {
        if(!self.addMode)
            [self setEditMode:NO];
    }
    else
    {
        [self.rightButton updateForState:NavButtonStatePanel withAlignment:UIControlContentHorizontalAlignmentRight];
    }
    
    if(user.avatarName)
    {
        [self.titleView.avatarView setAvatarURL:[NSString stringWithFormat:@"%li/%@", (long)user.userID, user.avatarName]];
    }
    else
    {
        [self.titleView.avatarView setAvatarURL:nil];
    }
    
    self.titleView.titleLabel.text = user.userName;
    
    //[self setTitle:user.userName forState:self.currentNavState];
}

- (void)updateForState:(NavState)navState
{
    // most common settings
    [self setHidden:NO];
    [self.titleView.avatarView setHidden:YES];
    [self.divider setHidden:YES];
    [self setBackgroundColor:[UIColor whiteColor]];
    self.titleView.titleLabel.font = [UIFont fontWithName:FONT_PROXIMA_BOLD size:FONT_SIZE_HEADER];
    self.titleView.gestureRecognizers = nil;
    [self.titleView.titleLabel setLeft:0];
    self.titleView.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    switch(navState)
    {
        case NavStateNone:
            [self setHidden:YES];
            break;
            
        case NavStateIntro:
            break;
            
        case NavStateLogin:
        {
            self.titleView.titleLabel.font = [UIFont fontWithName:FONT_PROXIMA_BOLD size:FONT_SIZE_LOGIN_HEADER];
            
            [self.titleView centerInSuperView];
            [self.titleView.titleLabel centerInSuperView];
            
            [self.leftButton setOrigin:CGPointMake(HEADER_PADDING, SMALL_PADDING)];
            [self.rightButton setTop:SMALL_PADDING];
            [self.rightButton setRight:(self.right - HEADER_PADDING)];
            
            [self.leftButton updateForState:NavButtonStateBack];
            [self.rightButton updateForState:NavButtonStateForward  withAlignment:UIControlContentHorizontalAlignmentRight];
        }
            break;
            
        case NavStateForgotPassword:
        case NavStateJoin:
        {
            self.titleView.titleLabel.font = [UIFont fontWithName:FONT_PROXIMA_BOLD size:FONT_SIZE_CREATE_HEADER];
            
            [self.titleView centerInSuperView];
            [self.titleView.titleLabel centerInSuperView];
            
            [self.leftButton setOrigin:CGPointMake(HEADER_PADDING, SMALL_PADDING)];
            [self.rightButton setTop:SMALL_PADDING];
            [self.rightButton setRight:(self.right - HEADER_PADDING)];
            
            [self.leftButton updateForState:NavButtonStateBack];
            [self.rightButton updateForState:NavButtonStateForward  withAlignment:UIControlContentHorizontalAlignmentRight];
        }
            break;
            
        case NavStateHome:
        {
            //self.titleLabel.text = TEXT_ARTICLES;
            //[self.leftButton updateForState:NavButtonStateSettings];
            //[self.rightButton updateForState:NavButtonStateFriends];
        }
            break;
            
        case NavStateBoard:
        {
            self.titleView.titleLabel.textAlignment = NSTextAlignmentLeft;
            [self.titleView.titleLabel setLeft:(self.titleView.avatarView.right + PADDING)];
            [self.titleView setTop:TITLE_TOP];
            [self.titleView.titleLabel centerVerticallyInSuperView];
            [self.leftButton updateForState:NavButtonStateShortBack];
            [self setBackgroundColor:[UIColor clearColor]];
            [self.titleView.avatarView setHidden:NO];
            
            [self.leftButton setOrigin:CGPointMake(PADDING, PADDING)];
            [self.rightButton setTop:TITLE_TOP];
            [self.rightButton setRight:(APP_WIDTH - PADDING_RIGHT)];
            
            UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedTitle:)];
            [self.titleView addGestureRecognizer:tapRecognizer];
        }
            break;
            
        case NavStateArticleEdit:
        {
            self.titleView.titleLabel.font = [UIFont fontWithName:FONT_PROXIMA_BOLD size:FONT_SIZE_BODY];
           // [self.leftButton updateForState:NavButtonStateBack];
            [self setBackgroundColor:[UIColor clearColor]];
            [self.titleView.avatarView setHidden:NO];
            
            [self.titleView.avatarView setAvatarURL:[NSString stringWithFormat:@"%li/%@", (long)[User currentUser].userID, [User currentUser].avatarName]];
            [self.rightButton updateForState:NavButtonStateDone withAlignment:UIControlContentHorizontalAlignmentCenter];
            
            UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedTitle:)];
            [self.titleView addGestureRecognizer:tapRecognizer];
        }
            break;
            
        case NavStateCreate:
        {
            [self.leftButton updateForState:NavButtonStateBack];
            [self.rightButton updateForState:NavButtonStateSettings withAlignment:UIControlContentHorizontalAlignmentRight];
        }
            break;
            
        case NavStateMore:
        {
            [self.leftButton updateForState:NavButtonStateNone];
            [self.rightButton updateForState:NavButtonStateNone];
        }
            break;
            
        case NavStateProfile:
        {
            [self.leftButton updateForState:NavButtonStateBack];
            
            if([Friend currentFriend])
                [self.rightButton updateForState:NavButtonStateShowDetail withAlignment:UIControlContentHorizontalAlignmentRight];
            else
                [self.rightButton updateForState:NavButtonStateNone withAlignment:UIControlContentHorizontalAlignmentRight];
            
            [self setBackgroundColor:[UIColor clearColor]];
            [self.divider setHidden:NO];
        }
            break;
            
        case NavStatePassword:
        case NavStateEditProfile:
        {
            [self.leftButton updateForState:NavButtonStateCancel];
            [self.rightButton updateForState:NavButtonStateSave withAlignment:UIControlContentHorizontalAlignmentRight];
        }
            break;
            
        case NavStateFindFriends:
        case NavStatePushNotifications:
        case NavStateShareSettings:
            [self.divider setHidden:NO];
            
        case NavStateAbout:
        case NavStateHelp:
        case NavStateLegal:
        case NavStateFullScreen:
        case NavStateAddFriend:
        case NavStateEdit:
        {
            [self.leftButton updateForState:NavButtonStateBack];
            [self.rightButton updateForState:NavButtonStateNone withAlignment:UIControlContentHorizontalAlignmentRight];
        }
            break;
            
        case NavStateActivity:
        {
            [self.leftButton updateForState:NavButtonStateNone];
            [self.rightButton updateForState:NavButtonStateRefresh withAlignment:UIControlContentHorizontalAlignmentRight];
        }
            break;
            
        default:
        {
            [self.leftButton updateForState:NavButtonStateNone];
            [self.rightButton updateForState:NavButtonStateNone withAlignment:UIControlContentHorizontalAlignmentRight];
            
        }
            break;
    }
    
    
}

- (void)tappedTitle:(UIGestureRecognizer *)recognizer
{
    [self.delegate navBarViewDidRequestShowProfile:self];
}

- (void)setTitle:(NSString *)title forState:(NavState)state
{
    [self setCurrentNavState:state];
    
    [UIView animateWithDuration:0.1 animations:^
    {
        [self.titleView setAlpha:0.0];
    }
    completion:^(BOOL finished)
    {
        self.titleView.titleLabel.text = title;
        
        [self updateForState:state];
        
        [UIView animateWithDuration:ANIMATION_DURATION animations:^
        {
            [self.titleView setAlpha:1.0];
        }];
    }];
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
