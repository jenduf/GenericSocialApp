//
//  Request.m
//  PeggSite
//
//  Created by Jennifer Duffey on 5/23/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import "Request.h"

@implementation Request

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    
    if(self)
    {
        _dateAdded = [Utils dateFromString:dictionary[@"date_added"] withFormat:DATE_FORMAT_STRING_SANS_ZONE];
    }
    
    return self;
}

@end
