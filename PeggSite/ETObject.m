//
//  ETObject.m
//  Esteban Torres - NSObject categories
//
//  Copyright (c) 2013 Esteban Torres. All rights reserved.
//

#import "ETObject.h"
#import "ETDictionary.h"
#import "ETDebugLog.h"
#import <objc/runtime.h>

static char const * const kETUserDictionaryKey = "kETUserDictionaryKey";

#pragma mark - NSObject (ETFramework)
@implementation NSObject (ETFramework)

/* ! Compares if the first value is null then return the second value.
 
 */
id is_null(id A, id B)
{
    if (!A
        || [[NSNull null] isEqual:A]) {
        return B;
    }
    else{
        return A;
    }
    
    return nil;
}

- (void) attachUserInfo:(id)userInfo
{
    objc_setAssociatedObject(self, kETUserDictionaryKey, userInfo, OBJC_ASSOCIATION_RETAIN);
}

- (id) userInfo
{
    return objc_getAssociatedObject(self, kETUserDictionaryKey);
}

- (void) attachUserInfo:(id)userInfo forKey:(char const * const)key
{
    if (key != nil)
    {
        objc_setAssociatedObject(self, key, userInfo, OBJC_ASSOCIATION_RETAIN);
    }
}

- (id) userInfoForKey:(char const * const)key
{
    if (key != nil)
    {
        return objc_getAssociatedObject(self, key);
    }
    else
    {
        return nil;
    }
}

- (id) initFromDictionary:(NSDictionary*)dictionary
{
    return [self initFromDictionary:dictionary dateFormatter:[NSDateFormatter ETDefaultDateFormatter]];
}

- (id) initFromDictionary:(NSDictionary*)dictionary dateFormatter:(NSDateFormatter*)dateFormatter
{
    self = [self init];
    
    if (self != nil)
    {
        NSDictionary* propDefs = [self ETPropertyDefinitions];
        ETDebugLog(@"propDefs: %@", propDefs);
        ETDebugLog(@"dictionary: %@", dictionary);
        
        if (propDefs && dictionary)
        {
            NSArray* propKeys = [propDefs allKeys];
            if (propKeys)
            {
                for (NSString* key in propKeys)
                {
                    id value = dictionary[key];
                    
                    if ([value isKindOfClass:[NSNull class]])
                    {
                        value = nil;
                    }
                    
                    if ([@"NSDate" isEqualToString:[propDefs valueForKey:key]])
                    {
                        value = [dateFormatter dateFromString:value];
                    }
                    
                    [self setValue:value forKey:key];
                }
            }
        }
    }
    
    return self;
}

- (id) updateDataWithDictionary:(NSDictionary*)dictionary{
    return [self updateDataWithDictionary:dictionary dateFormatter:[NSDateFormatter ETDefaultJSONDateFormatter]];
}

- (id) updateDataWithDictionary:(NSDictionary*)dictionary dateFormatter:(NSDateFormatter*)dateFormatter
{
    if (self != nil)
    {
        NSDictionary* propDefs = [self ETPropertyDefinitions];
        ETDebugLog(@"propDefs: %@", propDefs);
        ETDebugLog(@"dictionary: %@", dictionary);
        
        if (propDefs && dictionary)
        {
            NSArray* propKeys = [propDefs allKeys];
            if (propKeys)
            {
                for (NSString* key in propKeys)
                {
                    // Get the value for the property key
                    // out of the dictionary
                    id value = [self getValueForKey:key fromDictionary:dictionary propertiesArray:propDefs andDateFormatter:dateFormatter];
                    
                    // Here we check for values that could be defined with iVar name in the dictionary instead of the property
                    if(value == nil){
                        // Pull the ivar name out of the property.
                        char *ivarPropertyName = property_copyAttributeValue((__bridge objc_property_t)(key), "V");
                        // Make sure we're not dealing with a @dynamic property
                        if(ivarPropertyName != NULL){
                            // See if that lives in the incoming dictionary.
                            NSString *ivarName = @(ivarPropertyName);
                            value = [self getValueForKey:ivarName fromDictionary:dictionary propertiesArray:propDefs andDateFormatter:dateFormatter];
                        }
                        free (ivarPropertyName);
                    }
                    
                    [self setValue:value forKey:key];
                }
            }
        }
    }
    
    return self;
}

- (id) getValueForKey:(NSString *)key
       fromDictionary:(NSDictionary *)dictionary
      propertiesArray:(NSDictionary *)propDefs
     andDateFormatter:(NSDateFormatter *)dateFormatter
{
    NSString *propertyClassString = propDefs[key];
    Class propertyClass = NSClassFromString(propertyClassString);
    id value = dictionary[key];
    
    if ([value isKindOfClass:[NSNull class]] || !value
        || [value isKindOfClass:[NSDictionary class]]){
        value = nil;
    }
    else if([propertyClass isSubclassOfClass:[NSString class]]
       && [value isKindOfClass:[NSNumber class]]){
        // number converted into a string.
        value = [value stringValue];
    }
    else if ([propertyClass isSubclassOfClass:[NSNumber class]]
             && [value isKindOfClass:[NSString class]]) {
        // String converted into a number.  We can't tell what its
        // intention ls (float, integer, etc), so let the number
        // formatter make a best guess for us.
        NSNumberFormatter *numberFormatter = [NSNumberFormatter sharedInstance];
        value = [numberFormatter numberFromString:value];
    }
    else if (dateFormatter
             && [propertyClass isSubclassOfClass:[NSDate class]]
             && [value isKindOfClass:[NSString class]]) {
        // If the caller provided a date formatter, try converting
        // the date into a string.
        value = [dateFormatter dateFromString:value];
    }
//    else if (((attributeType == NSInteger16AttributeType) ||
//                  (attributeType == NSInteger32AttributeType) ||
//                  (attributeType == NSInteger64AttributeType) ||
//                  (attributeType == NSBooleanAttributeType)) &&
//                 ([value isKindOfClass:[NSString class]]))
//        {
//
//            if (attributeType == NSBooleanAttributeType)
//            {
//                if ([@"true" isEqualToString:[value lowercaseString]])
//                {
//                    value = @"1";
//                }
//                else if ([@"false" isEqualToString:[value lowercaseString]])
//                {
//                    value = @"0";
//                }
//            }
//            
//            value = [NSNumber numberWithInteger:[value integerValue]];
    
    return value;
}

- (NSDictionary*) ETPropertyDefinitions
{
    NSMutableDictionary* propDefs = [NSMutableDictionary dictionary];
    unsigned int count;
    
    objc_property_t* properties = class_copyPropertyList([self class], &count);
    
    for (int i = 0; i < count; i++)
    {
        objc_property_t property = properties[i];
        
        NSString* propName = @(property_getName(property));
        
        NSString* attrs = @(property_getAttributes(property));
        NSArray* attrParts = [attrs componentsSeparatedByString:@","];
        if (attrParts != nil && attrParts.count > 0)
        {
            NSString* className = [attrParts[0] substringFromIndex:1];
            className = [className stringByReplacingOccurrencesOfString:@"@" withString:@""];
            className = [className stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            propDefs[propName] = className;
        }
    }
    
    free(properties);
    return [NSDictionary dictionaryWithDictionary:propDefs];
}

@end

#pragma mark - NSTimer (ETTimerBlocks)
@implementation NSTimer (ETTimerBlocks)

+ (NSTimer*) delay:(NSTimeInterval)timeInterval andExecuteBlock:(void (^)(void))block
{
    return [self scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(invokeBlock:) userInfo:block repeats:NO];
}

+ (void) invokeBlock:(NSTimer*)timer
{
    if (timer.userInfo)
    {
        void (^block)() = (void (^)())timer.userInfo;
        if (block)
        {
            block();
//            Block_release(block);
        }
    }
}

@end

#pragma mark - NSDate (ETTimeZoneConversion)
@implementation NSDate (ETTimeZoneConversion)

- (NSDate *) convertToLocalTime
{
    NSTimeZone* tz = [NSTimeZone defaultTimeZone];
    NSInteger seconds = [tz secondsFromGMTForDate:self];
    return [NSDate dateWithTimeInterval:seconds sinceDate:self];
}

@end

#pragma mark - NSDateFormatter (ETFramework)
@implementation NSDateFormatter (ETFramework)

+ (NSDateFormatter*) ETDefaultDateFormatter
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:kETRFC3339DateFormatter];
    return dateFormatter;
}

+ (NSDateFormatter*) ETDefaultJSONDateFormatter
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    [dateFormatter setDateFormat:kETDefuaultJSONDateFormatter];
    
    return dateFormatter;
}

@end

#pragma mark - NSNumberFormatter (ETFramework)
@implementation NSNumberFormatter (ETFramework)

+ (NSNumberFormatter *)sharedInstance
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
        [sharedInstance setNumberStyle:NSNumberFormatterDecimalStyle];
    });
    
    return sharedInstance;
}

@end