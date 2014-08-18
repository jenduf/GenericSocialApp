//
//  ETDictionary.m
//  Esteban Torres - NSDictionary/NSMutableDictionary categories
//
//  Copyright (c) 2013 Esteban Torres. All rights reserved.
//

#import "ETDictionary.h"

@implementation NSMutableDictionary (ETFramework)

- (void)setObjectIfNotNil:(id)obj forKey:(id)key
{
    if (obj != nil && key != nil)
    {
        self[key] = obj;
    }
}

@end

NSString * const kDefaultETDateFormatter        =   @"yyyy-MM-dd HH:mm:ss";
NSString * const kETRFC3339DateFormatter        =   @"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'";
NSString * const kETDefuaultJSONDateFormatter   =   @"yyyy-MM-dd'T'HH:mm:ss'Z'";

@implementation NSDictionary (ETFramework)

- (id) nonNullObjectForKey:(NSString*)key forClass:(Class)forClass
{
    id value = self[key];
    if (value != nil && ![value isKindOfClass:[NSNull class]])
    {
        if (forClass == nil || [value isKindOfClass:forClass])
        {
            return value;
        }
    }
    
    return nil;
}

- (id) nonNullObjectForKey:(NSString*)key
{
    return [self nonNullObjectForKey:key forClass:nil];
}

- (NSDate*) dateForKey:(NSString*)key withFormatter:(NSString*)dateFormatter
{
    id value = [self nonNullObjectForKey:key];
    if (value)
    {
        NSDateFormatter* df = [[NSDateFormatter alloc] init];
        [df setDateFormat:dateFormatter];
        value = [df dateFromString:value];
    }
    
    return value;
}

- (NSDictionary*) dictionaryForKey:(NSString*)key
{
    return [self nonNullObjectForKey:key forClass:[NSDictionary class]];
}

@end