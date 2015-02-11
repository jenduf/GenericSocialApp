//
//  PushNotificationsViewController.m
//  PeggSite
//
//  Created by Jennifer Duffey on 5/12/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import "PushNotificationsViewController.h"

@interface PushNotificationsViewController ()

@end

@implementation PushNotificationsViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    return NO;
}

#pragma mark - Spinner Type For View
- (SpinnerType)spinnerType
{
    return SpinnerTypeP;
}

#pragma mark - Nav Bar Title
- (NSString *)title
{
    return TEXT_PUSH;
}

@end
