//
//  ForgotPasswordViewController.m
//  PeggSite
//
//  Created by Jennifer Duffey on 3/14/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import "ForgotPasswordViewController.h"

@interface ForgotPasswordViewController ()

@property (nonatomic, weak) IBOutlet UITextField *userNameTextField;

- (IBAction)reset:(id)sender;

@end

@implementation ForgotPasswordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.shouldHideLoader = YES;
    
    [self.userNameTextField becomeFirstResponder];
}

- (IBAction)reset:(id)sender
{
    [[DataManager sharedInstance] requestPasswordWithUsername:self.userNameTextField.text delegate:self];
}

- (void)moveForwardIfReady
{
    if(self.userNameTextField.text && self.userNameTextField.text.length > 0)
    {
        [self reset:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self reset:nil];
    
    return YES;
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
    return TEXT_FORGOT_PASSWORD;
}

@end
