//
//  LoginViewController.m
//  PeggSite
//
//  Created by Jennifer Duffey on 3/6/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import "LoginViewController.h"
#import "UAPush.h"


@interface LoginViewController ()

@property (nonatomic, weak) IBOutlet UITextField *loginTextField;
@property (nonatomic, weak) IBOutlet UITextField *passwordTextField;


- (IBAction)login:(id)sender;
- (IBAction)forgot:(id)sender;

@end

@implementation LoginViewController

- (void)prepareView
{
    [super prepareView];
    
    [self.loginTextField becomeFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.shouldHideLoader = YES;
}

#pragma mark

- (void)moveForwardIfReady
{
    if(self.loginTextField.text && self.loginTextField.text.length > 0)
    {
        if(self.passwordTextField.text && self.passwordTextField.text.length > 0)
        {
            [self login:nil];
        }
    }
}

- (IBAction)login:(id)sender
{
    [self.activeTextField resignFirstResponder];
    
    [[DataManager sharedInstance] loginWithUserName:self.loginTextField.text andPassword:self.passwordTextField.text delegate:self];
}

- (IBAction)forgot:(id)sender
{
    [self.navController navigateToViewControllerWithIdentifier:FORGOT_PASSWORD_VIEW_CONTROLLER animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark UITextField Delegate Methods
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [super textFieldDidBeginEditing:textField];
    
    if(textField == self.passwordTextField)
    {
        textField.secureTextEntry = YES;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField.returnKeyType == UIReturnKeyDone)
    {
        [self login:nil];
    }
    else
    {
        NSInteger currentTag = textField.tag;
        currentTag++;
        
        PeggTextField *peggTF = (PeggTextField *)[self.view viewWithTag:currentTag];
        [peggTF becomeFirstResponder];
        
        self.activeTextField = (PeggTextField *)peggTF;
    }
    
    return YES;
}

#pragma mark - DataManagerDelegate
- (void)dataManager:(DataManager *)dataManager didReturnData:(id)data
{
    NSDictionary *dict = (NSDictionary *)data;
    
    User *user = [[User alloc] initWithDictionary:dict];
    
    [User setCurrentUser:user];
    
    [[NSUserDefaults standardUserDefaults] setObject:self.loginTextField.text forKey:KEY_LOGIN_USERNAME];
    [[NSUserDefaults standardUserDefaults] setObject:self.passwordTextField.text forKey:KEY_LOGIN_PASSWORD];
    
    [self.navController navigateToViewControllerWithIdentifier:HOME_VIEW_CONTROLLER animated:YES];
    
    [[UAPush shared] setPushEnabled:YES];
    
    [[UAPush shared] setAlias:[NSString stringWithFormat:@"%li", (long)user.userID]];
    
    self.loginTextField.text = @"";
    self.passwordTextField.text = @"";
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
    return SpinnerTypeBrown;
}

#pragma mark - Nav Bar Title
- (NSString *)title
{
    return TEXT_LOG_IN;
}

@end
