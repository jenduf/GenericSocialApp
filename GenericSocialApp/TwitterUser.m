//
//  TwitterUser.m
//  PeggSite
//
//  Created by Jennifer Duffey on 3/25/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import "TwitterUser.h"

@implementation TwitterUser

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    
    if(self)
    {
        self.name = dictionary[@"name"];
        self.screenName = dictionary[@"screen_name"];
        self.location = dictionary[@"location"];
        self.imageURL = dictionary[@"profile_image_url"];
    }
    
    return self;
}

@end
