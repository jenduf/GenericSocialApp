//
//  ShareManager.m
//  PeggSite
//
//  Created by Jennifer Duffey on 3/24/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import "ShareManager.h"
#import <Social/Social.h>
#import "FacebookUser.h"
#import "TwitterUser.h"

@implementation ShareManager

static ShareManager *sharedInstance = nil;

+ (ShareManager *)sharedInstance
{
    static dispatch_once_t pred;
    
    dispatch_once(&pred, ^
    {
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (id)init
{
    self = [super init];
    
    if(self)
    {
        self.accountStore = [[ACAccountStore alloc] init];
    }
    
    return self;
}

- (void)getContactsWithCompletionBlock:(void(^)(ABAddressBookRef addressBook, CFErrorRef error))completionBlock
{
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
    
    ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
    
    if(status == kABAuthorizationStatusNotDetermined)
    {
        ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error)
        {
            if(granted)
            {
                ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &error);
                completionBlock(addressBook, nil);
            }
            else
            {
                NSLog(@"Unauthorized access to contacts.");
            }
        });
    }
    else if(status == kABAuthorizationStatusAuthorized)
    {
        CFErrorRef *error = NULL;
        ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error);
        completionBlock(addressBook, nil);
    }
    
    CFRelease(addressBookRef);
}

- (void)getTwitterAccountWithCompletionBlock:(void(^)(BOOL succeed, NSError *error))completionBlock
{
    if(self.twitterAccount)
    {
        completionBlock(YES, nil);
        return;
    }
    
    ACAccountType *twitterAccountType = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    dispatch_async(kBGQueue, ^
    {
        [self.accountStore requestAccessToAccountsWithType:twitterAccountType options:nil completion:^(BOOL granted, NSError *error)
        {
            NSArray *twitterAccounts = [self.accountStore accountsWithAccountType:twitterAccountType];
            
            if(granted && twitterAccounts)
            {
                NSString *twitterACIdentifier = [[NSUserDefaults standardUserDefaults] objectForKey:TWITTER_ACCOUNT_IDENTIFIER];
                self.twitterAccount = [self.accountStore accountWithIdentifier:twitterACIdentifier];
                
                if(self.twitterAccount)
                {
                    completionBlock(YES, error);
                }
                else
                {
                    if(twitterAccounts.count > 0)
                    {
                        [[NSUserDefaults standardUserDefaults] removeObjectForKey:TWITTER_ACCOUNT_IDENTIFIER];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        
                        self.twitterAccount = [twitterAccounts lastObject];
                            
                        completionBlock(YES, error);
                    }
                    else
                    {
                        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           UIAlertView *alert = [Utils createAlertWithPrefix:STRING_TWITTER_PREFIX customMessage:error.localizedDescription showOther:NO andDelegate:nil];
                           //UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Twitter Error" message: [NSString stringWithFormat:@"Twitter Error, %@", error.localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                           [alert show];
                       });
                    }
                }
            }
            else
            {
                if(error)
                {
                    dispatch_async(dispatch_get_main_queue(), ^
                   {
                       UIAlertView *alert = [Utils createAlertWithPrefix:STRING_TWITTER_PREFIX customMessage:error.localizedDescription showOther:NO andDelegate:nil];
                       [alert show];
                   });
                }
                else
                {
                    dispatch_async(dispatch_get_main_queue(), ^
                   {
                       UIAlertView *alert = [Utils createAlertWithPrefix:STRING_TWITTER_PREFIX customMessage:error.localizedDescription showOther:NO andDelegate:nil];
                       [alert show];
                   });
                }
            }
        }];
    });
    
}

- (void)getFacebookAccountWithCompletionBlock:(void (^)(BOOL succeed, NSError *error))completionBlock
{
    if(self.facebookAccount)
    {
        completionBlock(YES, nil);
        return;
    }
    
    ACAccountType *fbAccountType = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
    
    dispatch_async(kBGQueue, ^
    {
        NSDictionary *facebookOptions = @{ACFacebookAppIdKey: FACEBOOK_APP_ID,
                                        ACFacebookPermissionsKey: @[@"email", @"read_stream", @"user_photos", @"friends_photos"],
                                        ACFacebookAudienceKey : ACFacebookAudienceEveryone };
                       
        [self.accountStore requestAccessToAccountsWithType:fbAccountType options:facebookOptions completion:^(BOOL granted, NSError *error)
        {
                if(granted)
                {
                    [self getPublishStreamWithCompletionBlock:completionBlock];
                }
                else
                {
                    if(error)
                    {
                        dispatch_async(dispatch_get_main_queue(), ^
                        {
                            UIAlertView *alert = [Utils createAlertWithPrefix:STRING_FACEBOOK_PREFIX customMessage:error.localizedDescription showOther:NO andDelegate:nil];
                            [alert show];
                        });
                    }
                    else
                    {
                        dispatch_async(dispatch_get_main_queue(), ^
                        {
                            UIAlertView *alert = [Utils createAlertWithPrefix:STRING_FACEBOOK_PREFIX customMessage:error.localizedDescription showOther:NO andDelegate:nil];
                            [alert show];
                        });
                    }
            }
        }];
    });
}

- (void)getPublishStreamWithCompletionBlock:(void (^)(BOOL succeeded, NSError *error))completionBlock
{
    ACAccountType *fbAccountType = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
    
    dispatch_async(kBGQueue, ^
    {
        NSDictionary *facebookOptions = @{ACFacebookAppIdKey: FACEBOOK_APP_ID,
                                                         ACFacebookPermissionsKey: @[@"publish_stream"],
                                                         ACFacebookAudienceKey : ACFacebookAudienceEveryone };
                       
        [self.accountStore requestAccessToAccountsWithType:fbAccountType options:facebookOptions completion:^(BOOL granted, NSError *error)
        {
            if(granted)
            {
                self.facebookAccount = [[self.accountStore accountsWithAccountType:fbAccountType] lastObject];
                
                dispatch_async(dispatch_get_main_queue(), ^
                {
                                   // [[NSNotificationCenter defaultCenter] postNotificationName:NOTE_FACEBOOK_ACCESS_GRANTED object:nil];
                                   
                    completionBlock(granted, error);
                });
            }
            else
            {
                if(error)
                {
                    dispatch_async(dispatch_get_main_queue(), ^
                   {
                       UIAlertView *alert = [Utils createAlertWithPrefix:STRING_FACEBOOK_PREFIX customMessage:error.localizedDescription showOther:NO andDelegate:nil];
                       [alert show];
                   });
                }
                else
                {
                    dispatch_async(dispatch_get_main_queue(), ^
                   {
                       UIAlertView *alert = [Utils createAlertWithPrefix:STRING_FACEBOOK_PREFIX customMessage:error.localizedDescription showOther:NO andDelegate:nil];
                       [alert show];
                   });
                }
            }
        }];
    });
    
}

- (void)getTwitterFriendsWithCompletionBlock:(void (^)(NSArray *friends, NSError *error))completionBlock
{
    [self getTwitterAccountWithCompletionBlock:^(BOOL succeed, NSError *error)
    {
        SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:[NSURL URLWithString:[NSString stringWithFormat:@"%@followers/list.json", TWITTER_URL]] parameters:@{@"screen_name":self.twitterAccount.username}];
        request.account = self.twitterAccount;
        [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error)
        {
            if(error)
            {
                dispatch_async(dispatch_get_main_queue(), ^
               {
                   UIAlertView *alert = [Utils createAlertWithPrefix:STRING_TWITTER_PREFIX customMessage:error.localizedDescription showOther:NO andDelegate:nil];
                   [alert show];
                   
               });
            }
            else
            {
                NSError *jsonError;
                NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&jsonError];
                
                if(jsonError)
                {
                    UIAlertView *alert = [Utils createAlertWithPrefix:STRING_TWITTER_PREFIX customMessage:error.localizedDescription showOther:NO andDelegate:nil];
                    [alert show];
                }
                else
                {
                    NSMutableArray *twitterUsers = [NSMutableArray array];
                    
                    NSLog(@"REsponse: %@", responseJSON);
                    NSArray *users = responseJSON[@"users"];
                    NSLog(@"users; %@", users);
                    for(NSDictionary *dict in users)
                    {
                        TwitterUser *user = [[TwitterUser alloc] initWithDictionary:dict];
                        [twitterUsers addObject:user];
                    }
                    
                    completionBlock(twitterUsers, error);
                }
                
            }
        }];
    }];
}

- (void)getFriendsWithCompletionBlock:(void (^)(NSDictionary *friends, NSError *error))completionBlock
{
    [self getFacebookAccountWithCompletionBlock:^(BOOL succeeded, NSError *error)
     {
         SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeFacebook requestMethod:SLRequestMethodGET URL:[NSURL URLWithString:[NSString stringWithFormat:@"%@me/friends", FACEBOOK_GRAPH_URL]] parameters:@{@"fields": @"id,name,picture,first_name,last_name,username,devices,installed"}];
         request.account = self.facebookAccount;
         
         [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error)
          {
              if(error)
              {
                  dispatch_async(dispatch_get_main_queue(), ^
                 {
                     UIAlertView *alert = [Utils createAlertWithPrefix:STRING_FACEBOOK_PREFIX customMessage:error.localizedDescription showOther:NO andDelegate:nil];
                     [alert show];
                     
                 });
              }
              else
              {
                  NSError *jsonError;
                  NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&jsonError];
                  
                  if(jsonError)
                  {
                      UIAlertView *alert = [Utils createAlertWithPrefix:STRING_FACEBOOK_PREFIX customMessage:error.localizedDescription showOther:NO andDelegate:nil];
                      [alert show];
                  }
                  else
                  {
                      if(responseJSON[@"error"])
                      {
                          UIAlertView *alert = [Utils createAlertWithPrefix:STRING_FACEBOOK_PREFIX customMessage:responseJSON[@"error"] showOther:NO andDelegate:nil];
                          [alert show];
                      }
                      else
                      {
                          NSMutableArray *nonUserArray = [NSMutableArray array];
                          NSMutableArray *userArray = [NSMutableArray array];
                          
                          NSArray *friendArray = responseJSON[@"data"];
                          
                          for(NSDictionary *user in friendArray)
                          {
                              FacebookUser *rUser = [[FacebookUser alloc] initWithDictionary:user];
                              
                              if(rUser.isInstalled)
                                  [userArray addObject:rUser];
                              else
                                  [nonUserArray addObject:rUser];
                              
                              NSLog(@"User: %@", user);
                          }
                          
                          NSDictionary *allUsers = @
                          {
                              APP_USERS : userArray,
                              NON_APP_USERS : nonUserArray
                          };
                          
                          completionBlock(allUsers, error);
                      }
                  }
                  
              }
          }];
         
     }];
}

- (void)postToFacebookWall:(NSString *)friendID withMessage:(NSString *)message
{
    [self getFacebookAccountWithCompletionBlock:^(BOOL succeeded, NSError *error)
     {
         SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeFacebook requestMethod:SLRequestMethodPOST URL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/feed", friendID]] parameters:@{@"message": STRING_FACEBOOK_SHARE_MESSAGE}];
         request.account = self.facebookAccount;
         
         [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error)
          {
              if(error)
              {
                  dispatch_async(dispatch_get_main_queue(), ^
                  {
                      UIAlertView *alert = [Utils createAlertWithPrefix:STRING_FACEBOOK_PREFIX customMessage:error.localizedDescription showOther:NO andDelegate:nil];
                      [alert show];
                     
                 });
              }
              else
              {
                  NSError *jsonError;
                  NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&jsonError];
                  
                  if(jsonError)
                  {
                      UIAlertView *alert = [Utils createAlertWithPrefix:STRING_FACEBOOK_PREFIX customMessage:error.localizedDescription showOther:NO andDelegate:nil];
                      [alert show];
                  }
                  else
                  {
                      if(responseJSON[@"error"])
                      {
                          UIAlertView *alert = [Utils createAlertWithPrefix:STRING_FACEBOOK_PREFIX customMessage:responseJSON[@"error"] showOther:NO andDelegate:nil];
                          [alert show];
                      }
                      else
                      {
                        
                      }
                  }
                  
              }
          }];
         
     }];
}

// Open the device email client, with the given "to", "subject", and "body"
- (void)sendEmail:(NSString *)emailTo emailSubject:(NSString *)emailSubject emailBody:(NSString *)emailBody fromController:(PSViewController *)controller
{
    self.currentController = controller;
    
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *email = [[MFMailComposeViewController alloc] init];
        email.mailComposeDelegate = self;
        
        if(emailTo)
            [email setToRecipients:@[emailTo]];
        
        [email setSubject:emailSubject];
        [email setMessageBody:emailBody isHTML:NO];
        
        [self.currentController presentViewController:email animated:YES completion:nil];
    }
    else
    {
      //  NSString *message = [NSString stringWithFormat:@"%@%@", STRING_EMAIL_ERROR_MESSAGE, emailTo];
        
       // NSLog(@"Message: %@", STRING_EMAIL_MESSAGE(emailTo));
        
        UIAlertView *alert = [Utils createAlertWithPrefix:STRING_EMAIL_PREFIX customMessage:nil showOther:NO andDelegate:self];
      //  UIAlertView *emailAlert = [[UIAlertView alloc] initWithTitle:@"Email Failure" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self.currentController dismissViewControllerAnimated:true completion:^
    {
        self.currentController = nil;
    }];
}

@end
