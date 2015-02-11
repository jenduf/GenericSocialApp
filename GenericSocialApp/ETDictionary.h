//
//  ETDictionary.h
//  Esteban Torres - NSDictionary/NSMutableDictionary categories
//
//  Copyright (c) 2013 Esteban Torres. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (ETFramework)

- (void)setObjectIfNotNil:(id)obj forKey:(id)key;

@end

extern NSString * const kDefaultETDateFormatter;
extern NSString * const kETRFC3339DateFormatter;
extern NSString * const kETDefuaultJSONDateFormatter;

@interface NSDictionary (ETFramework)

- (id) nonNullObjectForKey:(NSString*)key;
- (NSDate*) dateForKey:(NSString*)key withFormatter:(NSString*)dateFormatter;
- (NSDictionary*) dictionaryForKey:(NSString*)key;
   
@end