//
//  AppDelegate.m
//  PeggSite
//
//  Created by Jennifer Duffey on 3/3/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import "AppDelegate.h"
#import "UAirship.h"
#import "UAConfig.h"
#import "UAPush.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[BITHockeyManager sharedHockeyManager] configureWithIdentifier:HOCKEY_APP_ID];
    // [BITHockeyManager sharedHockeyManager].debugLogEnabled = YES;
    [[BITHockeyManager sharedHockeyManager] startManager];
    [[BITHockeyManager sharedHockeyManager].authenticator authenticateInstallation];
    
    [FBProfilePictureView class];
    
    UAConfig *config = [UAConfig defaultConfig];
    
    [UAirship takeOff:config];
    
    [UAPush setDefaultPushEnabledValue:NO];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    if([error code] != 3010)
        NSLog(@"Application failed to register for push notifications %@", error);
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSMutableString* deviceTokenString = [NSMutableString stringWithString:[[deviceToken description] uppercaseString]];
	[deviceTokenString replaceOccurrencesOfString:@"<" withString:@"" options:0 range:NSMakeRange(0, deviceTokenString.length)];
	[deviceTokenString replaceOccurrencesOfString:@">" withString:@"" options:0 range:NSMakeRange(0, deviceTokenString.length)];
	[deviceTokenString replaceOccurrencesOfString:@" " withString:@"" options:0 range:NSMakeRange(0, deviceTokenString.length)];
    
    NSLog(@"DEVICE TOKEN: %@ STRING: %@", deviceToken, deviceTokenString);
    
    [[DataManager sharedInstance] setDeviceToken:deviceTokenString];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    if(application.applicationState != UIApplicationStateActive)
    {
        PSNavController *navController = (PSNavController *)self.window.rootViewController;
        if(userInfo[@"username"])
            [navController showProfile:userInfo[@"username"]];
        else
            [navController showArticle:userInfo[@"article_id"]];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBAppEvents activateApp];
    [FBAppCall handleDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[FBSession activeSession] close];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
}

@end
