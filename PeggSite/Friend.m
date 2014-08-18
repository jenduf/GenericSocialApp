//
//  Friend.m
//  PeggSite
//
//  Created by Jennifer Duffey on 3/3/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import "Friend.h"

@implementation Friend

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    
    if(self)
    {
        self.userID = [dictionary[@"friend_id"] intValue];
        _isFavorite = [dictionary[@"is_favorite"] boolValue];
        _dateVisited = [Utils dateFromString:dictionary[@"date_visited"] withFormat:DATE_FORMAT_STRING_SANS_ZONE];
        _newPostCount = [dictionary[@"new_post_count"] intValue];
    }
    
    return self;
}

static Friend *currentFriendObject;

+ (Friend *)currentFriend
{
    return currentFriendObject;
}

+ (void)setCurrentFriend:(Friend *)friend
{
    currentFriendObject = friend;
}

@end
