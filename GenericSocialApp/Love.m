//
//  Love.m
//  PeggSite
//
//  Created by Jennifer Duffey on 3/5/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import "Love.h"

@implementation Love

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    
    if(self)
    {
        _loveID = [dictionary[@"love_id"] intValue];
        _articleID = dictionary[@"article_id"];
        _userID = [dictionary[@"user_id"] intValue];
        _dateLoved = [Utils dateFromString:dictionary[@"date_loved"] withFormat:DATE_FORMAT_STRING];
        _avatar = dictionary[@"avatar"];
        _userName = dictionary[@"username"];
    }
    
    return self;
}

@end
