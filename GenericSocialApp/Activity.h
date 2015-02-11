//
//  Activity.h
//  PeggSite
//
//  Created by Jennifer Duffey on 4/14/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Activity : NSObject

@property (nonatomic, assign) NSInteger userID;
@property (nonatomic, strong) NSString *activityID, *articleID, *avatar, *comment, *userName, *thumbnail;
@property (nonatomic, strong) NSDate *dateAdded;
@property (nonatomic, assign) ActivityType activityType;
@property (nonatomic, assign) ArticleType articleType;
@property (nonatomic, assign) BOOL isPrivate, isPrivateBypass, isAuthUserFriend;
@property (nonatomic, strong) NSString *mentionUser;
@property (nonatomic, strong) UIImage *activityThumbnail;

@end
