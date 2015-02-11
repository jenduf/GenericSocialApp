//
//  User.m
//  PeggSite
//
//  Created by Jennifer Duffey on 3/3/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import "User.h"
#import "Request.h"
#import "Activity.h"
#import "Follower.h"
#import "UAPush.h"

@implementation User

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    
    if(self)
    {
        _userID = [dictionary[@"user_id"] intValue];
        _userName = dictionary[@"username"];
        _avatarName = [Utils replaceIfNullString:dictionary[@"avatar"]];
        _email = dictionary[@"email"];
        _firstName = [Utils replaceIfNullString:dictionary[@"first_name"]];
        _lastName = [Utils replaceIfNullString:dictionary[@"last_name"]];
        _layoutID = [dictionary[@"layout_id"] intValue];
        _shortBio = [Utils replaceIfNullString:dictionary[@"short_bio"]];
        _location = [Utils replaceIfNullString:dictionary[@"location"]];
        _isNotifyLove = [dictionary[@"is_notify_love"] boolValue];
        _isNotifyFollow = [dictionary[@"is_notify_follow"] boolValue];
        _isNotifyComment = [dictionary[@"is_notify_comment"] boolValue];
        
        _isAuthorizedFriend = [dictionary[@"is_auth_user_friend"] boolValue];
        _isPrivate = [dictionary[@"is_private"] boolValue];
        _isPrivateBypass = [[Utils replaceIfNullValue: dictionary[@"is_private_bypass"]] boolValue];
        
        NSString *dateViewed = [Utils replaceIfNullString:dictionary[@"date_viewed_activity"]];
        
        if(dateViewed.length > 0)
        {
            _dateViewedActivity = [Utils dateFromString:dateViewed withFormat:DATE_FORMAT_STRING_SANS_ZONE];
        }
        
        _articles = [[NSMutableArray alloc] initWithArray:[self getArticlesFromArray:dictionary[@"articles"]]];
        
        _friends = [[NSMutableArray alloc] initWithArray:[self getFriendsFromArray:dictionary[@"friends"]]];
        
        _requests = [[NSMutableArray alloc] initWithArray:[self getRequestsFromArray:dictionary[@"requests"]]];
        
        _activity = [[NSMutableArray alloc] initWithArray:[self getActivityFromArray:dictionary[@"activity"]]];
        
        _followers = [[NSMutableArray alloc] initWithArray:[self getFollowersFromArray:dictionary[@"followers"]]];
    }
    
    return self;
}

- (NSArray *)getArticlesFromArray:(NSArray *)articles
{
    NSMutableArray *returnArticles = [NSMutableArray array];
    
    for(NSDictionary *dict in articles)
    {
        Article *article = [[Article alloc] initWithDictionary:dict];
        [returnArticles addObject:article];
    }
    
    return returnArticles;
}

- (NSArray *)getFriendsFromArray:(NSArray *)friends
{
    NSMutableArray *returnFriends = [NSMutableArray array];
    
    NSArray *arrayDict = friends[1];
    
    for(NSDictionary *dict in arrayDict)
    {
        Friend *friend = [[Friend alloc] initWithDictionary:dict];
        [returnFriends addObject:friend];
    }
    
    return returnFriends;
}

- (NSArray *)getRequestsFromArray:(NSArray *)requests
{
    NSMutableArray *returnRequests = [NSMutableArray array];
    
    if(requests && requests.count > 0)
    {
        NSArray *arrayDict = requests[1];
        
        for(NSDictionary *dict in arrayDict)
        {
            Request *request = [[Request alloc] initWithDictionary:dict];
            [returnRequests addObject:request];
        }
    }
    
    return returnRequests;
}

- (NSArray *)getFollowersFromArray:(NSArray *)followers
{
    NSMutableArray *returnFollowers = [NSMutableArray array];
    
    if(followers && followers.count > 0)
    {
        NSArray *arrayDict = followers[1];
        
        for(NSDictionary *dict in arrayDict)
        {
            Follower *follower = [[Follower alloc] initWithDictionary:dict];
            [returnFollowers addObject:follower];
        }
    }
    
    return returnFollowers;
}

- (NSArray *)getActivityFromArray:(NSArray *)activity
{
    NSMutableArray *returnActivity = [NSMutableArray array];
    
    if(activity && activity.count > 0)
    {
        NSArray *arrayDict = activity[1];
        
        for(NSDictionary *dict in arrayDict)
        {
            Activity *activity = [[Activity alloc] initWithDictionary:dict];
            [returnActivity addObject:activity];
        }
    }
    
    return returnActivity;
}

- (BOOL)isFriend:(User *)friend
{
    if([self getFriendByID:friend.userID])
        return YES;
    
    return NO;
}

- (BOOL)isFavorite:(User *)friend
{
    Friend *f = (Friend *)[self getFriendByID:friend.userID];
    return f.isFavorite;
}

- (BOOL)isFriendOfUserName:(NSString *)userName
{
    for(Friend *f in self.friends)
    {
        if([f.userName isEqualToString:userName])
            return YES;
    }
    
    return NO;
}

- (User *)getFriendByID:(NSInteger)friendID
{
    for(Friend *f in self.friends)
    {
        if(f.userID == friendID)
            return f;
    }
    
    return nil;
}

static User *currentUserObject;

+ (User *)currentUser
{
    return currentUserObject;
}

+ (void)setCurrentUser:(User *)user
{
    currentUserObject = user;
}

+ (BOOL)isCurrentUser:(NSString *)userName
{
    if([currentUserObject.userName isEqualToString:userName])
    {
        return YES;
    }
    
    return NO;
}

@end