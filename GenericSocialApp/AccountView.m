//
//  AccountView.m
//  PeggSite
//
//  Created by Jennifer Duffey on 3/11/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import "AccountView.h"

@implementation AccountView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        
    }
    
    return self;
}

- (void)setUser:(User *)user
{
    _user = user;
    
    if(user.firstName.length > 0 || user.lastName.length > 0)
        self.name.text = [NSString stringWithFormat:@"%@ %@", user.firstName, user.lastName];
    
    self.userName.text = user.userName;
    self.email.text = user.email;
    
    if(user.shortBio.length > 0)
        self.bioTextView.text = user.shortBio;
    
    if(user.location.length > 0)
        self.location.text = user.location;
    
    // load image
    if(user.avatarName.length > 0)
    {
        [self.avatarView setAvatarURL:[NSString stringWithFormat:@"%li/%@", (long)user.userID, user.avatarName]];
    }
    else
    {
        [self.avatarView setAvatarURL:nil];
    }
    
    // determine if avatar can be edited
    if(user.userID == [User currentUser].userID)
    {
        [self.avatarView setEditable:YES];
    }
    else
    {
        [self.avatarView setEditable:NO];
    }
    
    // privacy switch
    if(user.isPrivate)
    {
        self.privateImageView.image = [UIImage imageNamed:IMAGE_PRIVATE_ON];
        [self.privateSwitch setOn:YES];
    }
    else
    {
        self.privateImageView.image = [UIImage imageNamed:IMAGE_PRIVATE_OFF];
        [self.privateSwitch setOn:NO];
    }
}


/*
- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx
{
    self.bioTextView.layer.borderColor = [UIColor blackColor].CGColor;
    self.bioTextView.layer.borderWidth = 1.0;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}*/


@end
