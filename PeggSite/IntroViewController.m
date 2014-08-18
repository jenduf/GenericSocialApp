//
//  IntroViewController.m
//  PeggSite
//
//  Created by Jennifer Duffey on 3/26/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import "IntroViewController.h"
#import "JoinViewController.h"
#import "UAPush.h"

@interface IntroViewController ()

@property (weak, nonatomic) IBOutlet PeggLabel *versionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *fakeSplashImageView;
@property (nonatomic, strong) User *user;

- (IBAction)signUpEmail:(id)sender;
- (IBAction)signUpFacebook:(id)sender;
- (IBAction)logIn:(id)sender;

@end

@implementation IntroViewController

- (void)prepareView
{
    [super prepareView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
    self.versionLabel.text = [NSString stringWithFormat:@"version %@", version];

    // Do we have an auth key stored that we can log in with?
    NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_LOGIN_USERNAME];
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_LOGIN_PASSWORD];
    
    if(username && username.length > 0 && password && password.length > 0)
    {
        [[DataManager sharedInstance] loginWithUserName:username andPassword:password delegate:self];
    }
    else
    {
        [self.fakeSplashImageView setHidden:YES];
    }
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

- (IBAction)signUpEmail:(id)sender
{
     [self navigateToJoinViewController:IntroButtonEmail];
}

- (IBAction)signUpFacebook:(id)sender
{
    [self navigateToJoinViewController:IntroButtonFacebook];
}

- (IBAction)logIn:(id)sender
{
    [self.navController navigateToViewControllerWithIdentifier:LOGIN_VIEW_CONTROLLER animated:YES];
}

- (void)navigateToJoinViewController:(IntroButton)introButton
{
    JoinViewController *jvc = (JoinViewController *)[self.storyboard instantiateViewControllerWithIdentifier:JOIN_VIEW_CONTROLLER];
    jvc.introButton = introButton;
    
    [self.navController navigateToViewController:jvc animated:YES completion:^
     {
         // [button setSelected:NO];
     }];
}

#pragma mark - DataManagerDelegate
- (void)dataManager:(DataManager *)dataManager didReturnData:(id)data
{
    NSDictionary *dict = (NSDictionary *)data;
    
    User *user = [[User alloc] initWithDictionary:dict];
    
    [User setCurrentUser:user];
    
    [self.navController navigateToViewControllerWithIdentifier:HOME_VIEW_CONTROLLER animated:YES];
    
    [[UAPush shared] setPushEnabled:YES];
    
    [[UAPush shared] setAlias:[NSString stringWithFormat:@"%li", (long)user.userID]];
}

#pragma mark - Nav Bar Visibility
- (BOOL)showNav
{
    return NO;
}

#pragma mark - Tab Bar Visibility
- (BOOL)showTabs
{
    return NO;
}

#pragma mark - Spinner Type For View
- (SpinnerType)spinnerType
{
    return SpinnerTypeGray;
}

#pragma mark - Nav Bar Title
- (NSString *)title
{
    return @"";
}

@end
