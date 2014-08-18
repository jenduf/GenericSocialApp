//
//  JoinViewController.m
//  PeggSite
//
//  Created by Jennifer Duffey on 3/7/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import "JoinViewController.h"

@interface JoinViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet AvatarView *avatarView;
@property (weak, nonatomic) IBOutlet UIView *joinView;
@property (weak, nonatomic) NSTimer *timer;

@end

@implementation JoinViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.shouldHideLoader = YES;
    
    [self.avatarView setEditable:YES];
    
    switch (self.introButton) {
        case IntroButtonFacebook:
            [self.usernameTextField becomeFirstResponder];
            break;
            
        default:
            [self.emailTextField becomeFirstResponder];
            break;
    }
    
    // Listen to all change events on the username text field
    [self.usernameTextField addTarget:self action:@selector(usernameTextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

// Fired during each change to the username text field
-(void)usernameTextFieldDidChange :(UITextField *)textField
{
    // Invalidate the previous timer
    // This prevents multiple (unnedded calls), and waits for a pause in typing
    [self.timer invalidate];
    
    // Create a new time with a .5 second delay
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(updateUsernameTextFieldValidity:) userInfo:nil repeats:NO];
}

- (void) updateUsernameTextFieldValidity:(id)sender {
    BOOL isValidUsername = false;
    NSString *username = self.usernameTextField.text;
    
    // If there is anything in the text field, ask the server if it is valid
    if ([username length] > 0)
    {
        isValidUsername = [[DataManager sharedInstance] checkUserName:username];
    }
    
    if (isValidUsername)
    {
        self.usernameTextField.textColor = [UIColor colorWithRed:(112/255.0) green:(160/255.0) blue:(53/255.0) alpha:1];
    }
    else
    {
        self.usernameTextField.textColor = [UIColor colorWithRed:(237/255.0) green:(28/255.0) blue:(36/255.0) alpha:1];
    }
}

- (BOOL)validate
{
    if([Utils validateEmailAddress:self.emailTextField.text])
    {
        if(self.usernameTextField.text && self.usernameTextField.text.length > 0)
        {
            if(self.passwordTextField.text && self.passwordTextField.text.length > 0)
            {
                return YES;
            }
            else
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter a valid password" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
            }
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter a valid username" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter a valid e-mail address" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
    
    return NO;
}

- (void)setImageSelected:(UIImage *)imageSelected
{
    [super setImageSelected:imageSelected];
    
    [self.avatarView setPhotoMode:YES];
    
    [self.avatarView.avatarImageView setImage:imageSelected];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)moveForwardIfReady
{
    if([self validate])
    {
        if([[DataManager sharedInstance] checkUserName:self.usernameTextField.text])
            [self join:nil];
    }
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

/*
- (void)dismissKeyboard:(UIGestureRecognizer *)recognizer
{
    [super dismissKeyboard:recognizer];
    
    [UIView animateWithDuration:0.3 animations:^
     {
         [self.formView setTop:(self.formView.top + LARGE_PADDING)];
     }];
}

- (void)shiftForKeyboard
{
    [UIView animateWithDuration:0.3 animations:^
     {
         [self.formView setTop:(self.formView.top - LARGE_PADDING)];
     }];
}
 */

- (IBAction)join:(id)sender
{
    
    // Perform local validation before server request
    if([self validate]) {
        [self.activeTextField resignFirstResponder];
        
    [[DataManager sharedInstance] createUserWithUserName:self.usernameTextField.text password:self.passwordTextField.text email:self.emailTextField.text delegate:self];
    }

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
    if(textField.returnKeyType == UIReturnKeyJoin)
    {
        [textField resignFirstResponder];
        [self join:nil];
    }
    else
    {
        NSInteger currentTag = textField.tag;
        currentTag++;
        
        UITextField *newTF = (UITextField *)[self.view viewWithTag:currentTag];
        [newTF becomeFirstResponder];
        
        self.activeTextField = (PeggTextField *)newTF;
    }
    
    return YES;
}

#pragma mark - DataManagerDelegate
- (void)dataManager:(DataManager *)dataManager didReturnData:(id)data
{
    switch(dataManager.requestType)
    {
        case RequestTypeUpload:
        {
            [self.navController navigateToViewControllerWithIdentifier:HOME_VIEW_CONTROLLER animated:YES];
        }
            break;
        
        case RequestTypeCreateUser:
        {
            NSDictionary *dict = (NSDictionary *)data;
            
            User *user = [[User alloc] initWithDictionary:dict];
            
            [User setCurrentUser:user];
            
            [[DataManager sharedInstance] uploadAvatar:self.avatarView.avatarImageView.image delegate:self];
        }
            break;
            
        default:
            break;
    }
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
    return TEXT_JOIN;
}

@end
