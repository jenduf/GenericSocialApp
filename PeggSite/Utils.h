//
//  Utils.h
//  AppNetReader
//
//  Created by Jennifer Duffey on 6/28/13.
//  Copyright (c) 2013 Jennifer Duffey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utils : NSObject

+ (NSDate *)dateFromString:(NSString *)str withFormat:(NSString *)format;
+ (NSString *)stringFromDate:(NSDate *)date;
+ (NSString *)getIdentifierForController:(id)controller;
+ (NSArray *)reversedArray:(NSArray *)array;
+ (BOOL)isNull:(id)obj;
+ (BOOL)isNullString:(NSString *)str;
+ (NSString *)replaceIfNullString:(NSString *)str;
+ (id)replaceIfNullValue:(id)value;
+ (BOOL) isFourInchScreen;
+ (CGRect)getScaledSizeWithSourceSize:(CGSize)sourceSize targetSize:(CGSize)targetSize isLetterBox:(BOOL)isLetterBox;
+ (NSString *)removeHTMLFromString:(NSString *)htmlString;
+ (BOOL)validateEmailAddress:(NSString *)email;
+ (UIImage *)rotateImage:(UIImage *)image byRadians:(CGFloat)radians;
+ (UIImage *)getFullImageFromAssetRepresentation:(ALAsset *)asset;
+ (UIAlertView *)createAlertWithPrefix:(NSString *)prefix customMessage:(NSString *)customMessage showOther:(BOOL)showOther andDelegate:(id)del;

+ (NSAttributedString *)getAttributedStringFromString:(NSString *)string;

@end
