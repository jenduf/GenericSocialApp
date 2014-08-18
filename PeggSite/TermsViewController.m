//
//  TermsViewController.m
//  PeggSite
//
//  Created by Jennifer Duffey on 3/26/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import "TermsViewController.h"

@interface TermsViewController ()

@property (nonatomic, weak) IBOutlet UITextView *termsTextView;

@end

@implementation TermsViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.shouldHideLoader = YES;
    
    NSString *pathName = [[NSBundle mainBundle] pathForResource:@"text" ofType:@"plist"];
	NSDictionary *tempDict = [NSDictionary dictionaryWithContentsOfFile:pathName];
    NSString *termsString = tempDict[@"terms"];
    
    self.termsTextView.text = termsString;
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
    return TEXT_TERMS;
}


@end
