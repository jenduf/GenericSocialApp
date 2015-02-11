//
//  Region.m
//  PeggSite
//
//  Created by Jennifer Duffey on 3/11/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import "Region.h"

@implementation Region

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    
    if(self)
    {
        _regionNumber = [dictionary[@"region_num"] intValue];
        _top = [dictionary[@"top"] floatValue] * PIXEL_CONVERSION_MULTIPLIER;
        _left = [dictionary[@"left"] floatValue] * PIXEL_CONVERSION_MULTIPLIER;
        _width = [dictionary[@"width"] floatValue] * PIXEL_CONVERSION_MULTIPLIER;
        _height = [dictionary[@"height"] floatValue] * PIXEL_CONVERSION_MULTIPLIER;
    }
    
    return self;
}

static Region *currentRegionObject;

+ (Region *)currentRegion
{
    return currentRegionObject;
}

+ (void)setCurrentRegion:(Region *)region
{
    currentRegionObject = region;
}

@end
