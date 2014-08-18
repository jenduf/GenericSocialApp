//
//  ShareManager.h
//  PeggSite
//
//  Created by Jennifer Duffey on 3/24/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Accounts/Accounts.h>
#import <AddressBook/AddressBook.h>
#import <MessageUI/MessageUI.h>
#import "PSViewController.h"

@interface ShareManager : NSObject
<MFMailComposeViewControllerDelegate>

@property (nonatomic, strong) ACAccountStore *accountStore;
@property (nonatomic, strong) ACAccount *facebookAccount, *twitterAccount;
@property (nonatomic, strong) PSViewController *currentController;

+ (ShareManager *)sharedInstance;

- (void)getContactsWithCompletionBlock:(void(^)(ABAddressBookRef addressBook, CFErrorRef error))completionBlock;
- (void)getFriendsWithCompletionBlock:(void (^)(NSDictionary *friends, NSError *error))completionBlock;
- (void)getTwitterFriendsWithCompletionBlock:(void (^)(NSArray *friends, NSError *error))completionBlock;
- (void)postToFacebookWall:(NSString *)friendID withMessage:(NSString *)message;
- (void)sendEmail:(NSString*)emailTo emailSubject:(NSString*)emailSubject emailBody:(NSString*)emailBody fromController:(PSViewController *)controller;

@end
