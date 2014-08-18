//
//  ShareSettingsViewController.m
//  PeggSite
//
//  Created by Jennifer Duffey on 5/12/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import "ShareSettingsViewController.h"

@interface ShareSettingsViewController ()

@end

@implementation ShareSettingsViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.shouldHideLoader = YES;
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
    return TEXT_SHARE;
}

@end
