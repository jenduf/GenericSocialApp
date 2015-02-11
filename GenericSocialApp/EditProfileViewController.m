//
//  SettingsViewController.m
//  PeggSite
//
//  Created by Jennifer Duffey on 3/26/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import "EditProfileViewController.h"
#import "AccountView.h"
#import "PasswordView.h"
#import "NotificationSettingsView.h"

@interface EditProfileViewController ()
<UIAlertViewDelegate, CLLocationManagerDelegate>

@property (nonatomic, weak) IBOutlet AccountView *accountView;
@property (nonatomic, weak) IBOutlet PasswordView *passwordView;
@property (nonatomic, weak) IBOutlet NotificationSettingsView *notificationsView;
@property (nonatomic, assign) BOOL imageChanged;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (weak, nonatomic) NSTimer *timer;

- (IBAction)update:(id)sender;
- (IBAction)changePassword:(id)sender;
- (IBAction)getLocation:(id)sender;
- (IBAction)changePic:(id)sender;
- (IBAction)save:(id)sender;

@end

@implementation EditProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.shouldHideLoader = YES;
    
    [self updateEditView];
    
    // Listen to all change events on the username text field
    [self.accountView.userName addTarget:self action:@selector(usernameTextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

- (BOOL)validate
{
    if([Utils validateEmailAddress:self.accountView.email.text])
        return YES;
    
    UIAlertView *alert = [Utils createAlertWithPrefix:STRING_ERROR_INVALID_EMAIL_PREFIX customMessage:nil showOther:NO andDelegate:nil];
    [alert show];
    
    return NO;
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
    BOOL isValidUserName = false;
    NSString *currentUserName = [User currentUser].userName;
    NSString *newUserName = self.accountView.userName.text;
    
    if ([currentUserName isEqualToString:newUserName])
    {
        isValidUserName = true;
    }
    else
    {
        // If there is anything in the text field, ask the server if it is valid
        if ([newUserName length] > 0)
        {
            isValidUserName = [[DataManager sharedInstance] checkUserName:newUserName];
        }
    }

    if (isValidUserName)
    {
        self.accountView.userName.textColor = [UIColor colorWithRed:(112/255.0) green:(160/255.0) blue:(53/255.0) alpha:1];
    }
    else
    {
        self.accountView.userName.textColor = [UIColor colorWithRed:(237/255.0) green:(28/255.0) blue:(36/255.0) alpha:1];
    }
}

- (void)setImageSelected:(UIImage *)imageSelected
{
    [super setImageSelected:imageSelected];
    
    self.imageChanged = YES;
    
    [self.accountView.avatarView.avatarImageView setImage:imageSelected];
}

- (void)moveForwardIfReady
{
    if(self.imageChanged)
        [self save:nil];
    else
        [self update:nil];
}

- (IBAction)save:(id)sender
{
    [[DataManager sharedInstance] uploadAvatar:self.accountView.avatarView.avatarImageView.image delegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)getLocation:(id)sender
{
    if(!self.locationManager)
        self.locationManager = [[CLLocationManager alloc] init];
    
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
}

- (IBAction)changePassword:(id)sender
{
    [self.navController navigateToViewControllerWithIdentifier:PASSWORD_VIEW_CONTROLLER animated:YES];
    
    [self.passwordView.passwordCurrent becomeFirstResponder];
}

- (IBAction)update:(id)sender
{
    switch (self.accountTypeIndex)
    {
        case 0:
        {
            User *user = [User currentUser];
            NSArray *names = [self.accountView.name.text componentsSeparatedByString:@" "];
            if(names.count > 0)
                user.firstName = names[0];
            
            if(names.count > 1)
                user.lastName = names[1];
            
            user.userName = self.accountView.userName.text;
            user.email = self.accountView.email.text;
            user.shortBio = self.accountView.bioTextView.text;
            user.location = self.accountView.location.text;
            user.isPrivate = self.accountView.privateSwitch.isOn;
            
            if([self validate])
                [[DataManager sharedInstance] updateCurrentUser:user delegate:self];
        }
            break;
            
        case 1:
            [[DataManager sharedInstance] updatePasswordWithCurrentPassword:self.passwordView.passwordCurrent.text newPassword:self.passwordView.passwordNew.text andVerifiedPassword:self.passwordView.passwordVerify.text delegate:self];
            break;
            
        case 2:
            
            break;
            
        default:
            break;
    }
}

- (IBAction)changePic:(id)sender
{
    [self.navController selectPhoto];
}

- (void)updateEditView
{
    switch (self.accountTypeIndex)
    {
        case 0:
            [self.accountView setUser:[User currentUser]];
            [self.accountView setHidden:NO];
            [self.passwordView setHidden:YES];
            //[self.notificationsView setHidden:YES];
            break;
            
        case 1:
            [self.passwordView setHidden:NO];
            [self.accountView setHidden:YES];
            //[self.notificationsView setHidden:YES];
            break;
            
        case 2:
            [self.passwordView setHidden:YES];
            [self.accountView setHidden:YES];
            //[self.notificationsView setHidden:NO];
            break;
            
        default:
            break;
    }
}

#pragma mark - Location Manager Delegate Methods
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    // If it's a relatively recent event, turn off updates to save power.
    CLLocation *location = [locations lastObject];
    NSDate *eventDate = location.timestamp;
    
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    
    if(abs(howRecent) < 15.0)
    {
        [self geocodeLocation:location];
        [self.locationManager stopUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Location error: %@", error);
}

- (void)geocodeLocation:(CLLocation *)location
{
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error)
    {
        if(error)
        {
            NSLog(@"Geocode failed with error: %@", error);
            return;
        }
        
        NSLog(@"Received placemarks: %@", placemarks);
        
        CLPlacemark *placemark = placemarks[0];
        
        NSLog(@"locality: %@, subAA: %@, AA: %@", placemark.locality, placemark.subAdministrativeArea, placemark.administrativeArea);
        
        NSString *cityString = (placemark.locality ? placemark.locality : placemark.subAdministrativeArea);
        
        self.accountView.location.text = [NSString stringWithFormat:@"%@, %@", cityString, placemark.administrativeArea];
    }];
}

#pragma mark - DataManagerDelegate
- (void)dataManager:(DataManager *)dataManager didReturnData:(id)data
{
    switch (dataManager.requestType)
    {
        case RequestTypeUpdateUser:
        {
           if(dataManager.requestType == RequestTypeUpdateUser)
           {
            // NSDictionary *dict = (NSDictionary *)data;
        // Article *article = [[Article alloc] initWithDictionary:dict];
               UIAlertView *alert = [Utils createAlertWithPrefix:STRING_CONTENT_UPDATED_PREFIX customMessage:nil showOther:NO andDelegate:self];
               [alert show];
           }
        }
            break;
            
        case RequestTypeUpload:
        {
            [self update:nil];
        }
            
        default:
            break;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField.returnKeyType == UIReturnKeyDone)
    {
        [textField resignFirstResponder];
        [self update:nil];
        
        return YES;
    }
    else
    {
        NSInteger currentTag = textField.tag;
        currentTag++;
        
        id newTF = [self.view viewWithTag:currentTag];
        [newTF becomeFirstResponder];
        
        if([newTF isKindOfClass:[UITextView class]])
            self.activeTextView = newTF;
        else
            self.activeTextField = newTF;
    }
    
    return NO;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    NSInteger currentTag = textView.tag;
    currentTag++;
    
    id newTF = [self.view viewWithTag:currentTag];
    [newTF becomeFirstResponder];
    
    if([newTF isKindOfClass:[UITextView class]])
        self.activeTextView = newTF;
    else
        self.activeTextField = newTF;
    
    return YES;
}

/*
- (void)dismissKeyboard:(UIGestureRecognizer *)recognizer
{
     [super dismissKeyboard:recognizer];
 
     [UIView animateWithDuration:0.3 animations:^
      {
          [self.accountView setTop:NAV_BAR_HEIGHT];
      }];
}
 */

/*
- (void)shiftForKeyboard
{
    if(self.accountView.top > EDIT_MIN_Y)
    {
        [UIView animateWithDuration:0.3 animations:^
         {
             [self.accountView setTop:(self.accountView.top - LARGE_PADDING)];
         }];
    }
}
 */

#pragma mark -
#pragma mark - UIAlertViewDelegate Methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navController hideModalViewController:self];
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
    return TEXT_EDIT_PROFILE;
}


@end
