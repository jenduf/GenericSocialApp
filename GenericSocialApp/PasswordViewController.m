//
//  PasswordViewController.m
//  PeggSite
//
//  Created by Jennifer Duffey on 5/7/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import "PasswordViewController.h"
#import "ForgotPasswordViewController.h"

@interface PasswordViewController ()

@property (nonatomic, weak) IBOutlet UITextField *userNameTextField;

- (IBAction)forgot:(id)sender;

@end

@implementation PasswordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)forgot:(id)sender
{
    [[DataManager sharedInstance] requestPasswordWithUsername:self.userNameTextField.text delegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - DataManagerDelegate
- (void)dataManager:(DataManager *)dataManager didReturnData:(id)data
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Password reset instructions have been e-mailed to you." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
    
    [self.navController popViewController];
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
    return TEXT_PASSWORD;
}


@end
