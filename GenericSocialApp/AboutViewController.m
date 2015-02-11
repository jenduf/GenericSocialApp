//
//  AboutViewController.m
//  PeggSite
//
//  Created by Jennifer Duffey on 3/26/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@property (nonatomic, weak) IBOutlet UIWebView *webView;

@end

@implementation AboutViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSURL *aboutURL = [NSURL URLWithString:PEGGSITE_ABOUT_URL];
    [self.webView loadRequest:[NSURLRequest requestWithURL:aboutURL]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
    return TEXT_ABOUT;
}


@end
