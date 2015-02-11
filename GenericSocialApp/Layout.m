//
//  Layout.m
//  PeggSite
//
//  Created by Jennifer Duffey on 3/10/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import "Layout.h"
#import "Region.h"

@implementation Layout

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    
    if(self)
    {
        _layoutID = [dictionary[@"layout_id"] intValue];
        _name = dictionary[@"name"];
        _sort = [dictionary[@"sort"] intValue];

        _regions = [[NSMutableArray alloc] initWithArray:[self getRegionsFromArray:dictionary[@"regions"]]];
    }
    
    return self;
}

- (NSArray *)getRegionsFromArray:(NSArray *)regions
{
    NSMutableArray *returnRegions = [NSMutableArray array];
    
    for(NSDictionary *dict in regions)
    {
        Region *region = [[Region alloc] initWithDictionary:dict];
        [returnRegions addObject:region];
    }
    
    return returnRegions;
}

@end
