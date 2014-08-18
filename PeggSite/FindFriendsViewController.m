//
//  FindFriendsViewController.m
//  PeggSite
//
//  Created by Jennifer Duffey on 5/7/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import "FindFriendsViewController.h"
#import "SocialButtonView.h"

@interface FindFriendsViewController ()

- (IBAction)getFriends:(id)sender;


@end

@implementation FindFriendsViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.shouldHideLoader = YES;
}

- (IBAction)getFriends:(id)sender
{
    UIGestureRecognizer *recognizer = (UIGestureRecognizer *)sender;
    SocialButtonView *btnView = (SocialButtonView *)recognizer.view;
    
    NSInteger index = btnView.tag;
    
    switch (index)
    {
        case 100:
            [self.navController navigateToViewControllerWithIdentifier:FACEBOOK_FRIEND_VIEW_CONTROLLER animated:YES];
            break;
            
        case 101:
            [self.navController navigateToViewControllerWithIdentifier:CONTACTS_VIEW_CONTROLLER animated:YES];
            break;
            
        case 102:
            [self.navController navigateToViewControllerWithIdentifier:FACEBOOK_FRIEND_VIEW_CONTROLLER animated:YES];
            break;
            
        case 103:
            [self.navController navigateToViewControllerWithIdentifier:TWITTER_VIEW_CONTROLLER animated:YES];
            break;
            
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Nav Bar Visibility
- (BOOL)showNav
{
    return YES;
}

#pragma mark - Tab Bar Visibility
- (BOOL)showTabs
{
    return YES;
}

#pragma mark - Spinner Type For View
- (SpinnerType)spinnerType
{
    return SpinnerTypeP;
}

#pragma mark - Nav Bar Title
- (NSString *)title
{
    return TEXT_FIND_FRIENDS;
}

@end
