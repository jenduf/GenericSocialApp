//
//  ETObject.h
//  Esteban Torres - NSObject categories
//
//  Copyright (c) 2013 Esteban Torres. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (ETFramework)

- (void) attachUserInfo:(id)userInfo;
- (id) userInfo;

- (void) attachUserInfo:(id)userInfo forKey:(char const *)key;
- (id) userInfoForKey:(char const *)key;

- (id) initFromDictionary:(NSDictionary*)dictionary;
- (id) initFromDictionary:(NSDictionary*)dictionary dateFormatter:(NSDateFormatter*)dateFormatter;

- (id) updateDataWithDictionary:(NSDictionary*)dictionary;
- (id) updateDataWithDictionary:(NSDictionary*)dictionary dateFormatter:(NSDateFormatter*)dateFormatter;

id is_null(id A, id B);

@end


@interface NSTimer (ETTimerBlocks)

+ (NSTimer*) delay:(NSTimeInterval)timeInterval andExecuteBlock:(void (^)(void))block;

@end

@interface NSDate (ETTimeZoneConversion)

- (NSDate *) convertToLocalTime;

@end

@interface NSDateFormatter (ETFramework)

+ (NSDateFormatter*) ETDefaultDateFormatter;
+ (NSDateFormatter*) ETDefaultJSONDateFormatter;

@end

@interface NSNotificationCenter (ETFramework)

- (void) ETPostNotificationName:(NSString*)aName object:(id)anObject withDelay:(NSTimeInterval)delay;

@end

@interface NSNumberFormatter (ETFramework)

+ (NSNumberFormatter *)sharedInstance;

@end