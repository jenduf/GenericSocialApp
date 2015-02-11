//
//  User.h
//  PeggSite
//
//  Created by Jennifer Duffey on 3/3/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (nonatomic, assign) NSInteger userID;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *avatarName;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *firstName, *lastName;
@property (nonatomic, assign) NSInteger layoutID;
@property (nonatomic, strong) NSString *shortBio;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, assign) NSInteger isNotifyLove, isNotifyFollow, isNotifyComment;
@property (nonatomic, assign) BOOL isAuthorizedFriend, isPrivate, isPrivateBypass;
@property (nonatomic, strong) NSMutableArray *articles, *friends, *requests, *activity, *followers;
@property (nonatomic, strong) NSDate *dateViewedActivity;

+ (User *)currentUser;
+ (void)setCurrentUser:(User *)user;
+ (BOOL)isCurrentUser:(NSString *)userName;
- (BOOL)isFriend:(User *)friend;
- (BOOL)isFavorite:(User *)friend;
- (BOOL)isFriendOfUserName:(NSString *)userName;
- (User *)getFriendByID:(NSInteger)friendID;


@end
