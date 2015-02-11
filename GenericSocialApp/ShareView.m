//
//  ShareView.m
//  PeggSite
//
//  Created by Jennifer Duffey on 7/1/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import "ShareView.h"
#import "Divider.h"

@implementation ShareView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if(self)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:IMAGE_SHARE_BACKGROUND]];
        [self addSubview:imageView];
        
        // facebook button
        UIView *fbView = [[UIView alloc] initWithFrame:CGRectMake(SHARE_OFFSET_LEFT, SHARE_OFFSET_TOP, self.width, SHARE_BUTTON_HEIGHT)];
        fbView.backgroundColor = [UIColor clearColor];
        
        UIImage *fbImage = [UIImage imageNamed:IMAGE_SHARE_FACEBOOK];
        UIButton *fbButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [fbButton setImage:fbImage forState:UIControlStateNormal];
        [fbButton setFrame:CGRectMake(SHARE_IMAGE_SIZE, 0, SHARE_IMAGE_SIZE, SHARE_IMAGE_SIZE)];
        [fbView addSubview:fbButton];
        [fbButton centerVerticallyInSuperView];
        
        PeggLabel *fbLabel = [[PeggLabel alloc] initWithText:@"Facebook" color:[UIColor colorWithHexString:COLOR_SHARE_TEXT] font:[UIFont fontWithName:FONT_PROXIMA_BOLD size:FONT_SIZE_ACTIVITY] andFrame:CGRectZero];
        [fbView addSubview:fbLabel];
        [fbLabel sizeToFit];
        [fbLabel centerInSuperView];
        [fbLabel setLeft:(fbButton.right + PADDING)];
        
        Divider *divider = [[Divider alloc] initWithColor:[UIColor colorWithHexString:COLOR_SHARE_DIVIDER] andFrame:CGRectMake(SHARE_DIVIDER_OFFSET, fbView.height - 1.5, SHARE_DIVIDER_WIDTH, 1.5)];
        [fbView addSubview:divider];
        
        [self addSubview:fbView];
        
        UITapGestureRecognizer *fbRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(facebookTapped:)];
        [fbView addGestureRecognizer:fbRecognizer];
        
        // twitter button
        UIView *twitterView = [[UIView alloc] initWithFrame:CGRectMake(SHARE_OFFSET_LEFT, fbView.bottom, self.width, SHARE_BUTTON_HEIGHT)];
        twitterView.backgroundColor = [UIColor clearColor];
        
        UIImage *twitterImage = [UIImage imageNamed:IMAGE_SHARE_TWITTER];
        UIButton *twitterButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [twitterButton setImage:twitterImage forState:UIControlStateNormal];
        [twitterButton setFrame:CGRectMake(SHARE_IMAGE_SIZE, 0, SHARE_IMAGE_SIZE, SHARE_IMAGE_SIZE)];
        [twitterView addSubview:twitterButton];
        [twitterButton centerVerticallyInSuperView];
        
        PeggLabel *twitterLabel = [[PeggLabel alloc] initWithText:@"Twitter" color:[UIColor colorWithHexString:COLOR_SHARE_TEXT] font:[UIFont fontWithName:FONT_PROXIMA_BOLD size:FONT_SIZE_ACTIVITY] andFrame:CGRectZero];
        [twitterView addSubview:twitterLabel];
        [twitterLabel sizeToFit];
        [twitterLabel centerInSuperView];
        [twitterLabel setLeft:(twitterButton.right + PADDING)];
        
        Divider *divider2 = [[Divider alloc] initWithColor:[UIColor colorWithHexString:COLOR_SHARE_DIVIDER] andFrame:CGRectMake(SHARE_DIVIDER_OFFSET, twitterView.height - 1.5, SHARE_DIVIDER_WIDTH, 1.5)];
        [twitterView addSubview:divider2];
        
        [self addSubview:twitterView];
        
        UITapGestureRecognizer *twitterRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(twitterTapped:)];
        [twitterView addGestureRecognizer:twitterRecognizer];
        
        // email button
        UIView *emailView = [[UIView alloc] initWithFrame:CGRectMake(SHARE_OFFSET_LEFT, twitterView.bottom, self.width, SHARE_BUTTON_HEIGHT)];
        emailView.backgroundColor = [UIColor clearColor];
        
        UIImage *emailImage = [UIImage imageNamed:IMAGE_SHARE_EMAIL];
        UIButton *emailButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [emailButton setImage:emailImage forState:UIControlStateNormal];
        [emailButton setFrame:CGRectMake(SHARE_IMAGE_SIZE, 0, SHARE_IMAGE_SIZE, SHARE_IMAGE_SIZE)];
        [emailView addSubview:emailButton];
        [emailButton centerVerticallyInSuperView];
        
        PeggLabel *emailLabel = [[PeggLabel alloc] initWithText:@"Email" color:[UIColor colorWithHexString:COLOR_SHARE_TEXT] font:[UIFont fontWithName:FONT_PROXIMA_BOLD size:FONT_SIZE_ACTIVITY] andFrame:CGRectZero];
        [emailView addSubview:emailLabel];
        [emailLabel sizeToFit];
        [emailLabel centerInSuperView];
        [emailLabel setLeft:(emailButton.right + PADDING)];
        
        Divider *divider3 = [[Divider alloc] initWithColor:[UIColor colorWithHexString:COLOR_SHARE_DIVIDER] andFrame:CGRectMake(SHARE_DIVIDER_OFFSET, emailView.height - 1.5, SHARE_DIVIDER_WIDTH, 1.5)];
        [emailView addSubview:divider3];
        
        [self addSubview:emailView];
        
        UITapGestureRecognizer *emailRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(emailTapped:)];
        [emailView addGestureRecognizer:emailRecognizer];
        
        // url button
        UIView *urlView = [[UIView alloc] initWithFrame:CGRectMake(SHARE_OFFSET_LEFT, emailView.bottom, self.width, SHARE_BUTTON_HEIGHT)];
        urlView.backgroundColor = [UIColor clearColor];
        
        UIImage *urlImage = [UIImage imageNamed:IMAGE_SHARE_URL];
        UIButton *urlButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [urlButton setImage:urlImage forState:UIControlStateNormal];
        [urlButton setFrame:CGRectMake(SHARE_IMAGE_SIZE, 0, SHARE_IMAGE_SIZE, SHARE_IMAGE_SIZE)];
        [urlView addSubview:urlButton];
        [urlButton centerVerticallyInSuperView];
        
        PeggLabel *urlLabel = [[PeggLabel alloc] initWithText:@"Copy URL" color:[UIColor colorWithHexString:COLOR_SHARE_TEXT] font:[UIFont fontWithName:FONT_PROXIMA_BOLD size:FONT_SIZE_ACTIVITY] andFrame:CGRectZero];
        [urlView addSubview:urlLabel];
        [urlLabel sizeToFit];
        [urlLabel centerInSuperView];
        [urlLabel setLeft:(urlButton.right + PADDING)];
        
        [self addSubview:urlView];
        
        UITapGestureRecognizer *urlRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(urlTapped:)];
        [urlView addGestureRecognizer:urlRecognizer];
    }
    
    return self;
}

- (void)facebookTapped:(UIGestureRecognizer *)recognizer
{
    [self.delegate shareViewDidRequestShareFacebook:self];
}

- (void)twitterTapped:(UIGestureRecognizer *)recognizer
{
    [self.delegate shareViewDidRequestShareTwitter:self];
}

- (void)emailTapped:(UIGestureRecognizer *)recognizer
{
    [self.delegate shareViewDidRequestShareEmail:self];
}

- (void)urlTapped:(UIGestureRecognizer *)recognizer
{
    [self.delegate shareViewDidRequestShareURL:self];
}

@end
