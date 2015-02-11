//
//  Comment.m
//  PeggSite
//
//  Created by Jennifer Duffey on 4/4/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import "Comment.h"

@implementation Comment

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    
    if(self)
    {
        _userID = [dictionary[@"user_id"] intValue];
        _userName = dictionary[@"username"];
        _commentText = dictionary[@"comment"];
        _dateAdded = [Utils dateFromString:[Utils replaceIfNullString:dictionary[@"date_added"]] withFormat:DATE_FORMAT_STRING_SANS_ZONE];
        _avatar = [Utils replaceIfNullString:dictionary[@"avatar"]];
    }
    
    return self;
}

@end
