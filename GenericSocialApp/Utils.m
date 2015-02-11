//
//  Utils.m
//  AppNetReader
//
//  Created by Jennifer Duffey on 6/28/13.
//  Copyright (c) 2013 Jennifer Duffey. All rights reserved.
//

#import "Utils.h"

@implementation Utils

+ (NSDate *)dateFromString:(NSString *)str withFormat:(NSString *)format
{	
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:format];
    
	return [formatter dateFromString:str];
}

+ (NSString *)stringFromDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    
    return [dateFormatter stringFromDate:date];
}

+ (NSString *)getIdentifierForController:(id)controller
{
	return NSStringFromClass([controller class]);
}

+ (NSArray *)reversedArray:(NSArray *)array
{
    if(array.count < 2)
        return array;
    
    NSArray *reversed = [[array reverseObjectEnumerator] allObjects];
    
    return reversed;
}

+ (BOOL)isNull:(id)obj
{
	return ( ( obj == nil ) || [obj isEqual:[NSNull null]] );
}

+ (BOOL)isNullString:(NSString *)str
{
	BOOL returnBOOL = [Utils isNull:str];
	
	return (returnBOOL || [str isEqualToString:@"<null>"] || [str isEqualToString:@"(null)"]);
}

+ (NSString *)replaceIfNullString:(NSString *)str
{
	if([self isNullString:str])
		return @"";
	
	return str;
}

+ (id)replaceIfNullValue:(id)value
{
	if ([value isKindOfClass:[NSNull class]])
		return 0;
	
	return value;
}

+ (BOOL) isFourInchScreen
{
	return (IS_4_INCH && [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone);
}

+ (CGRect)getScaledSizeWithSourceSize:(CGSize)sourceSize targetSize:(CGSize)targetSize isLetterBox:(BOOL)isLetterBox
{
    CGRect returnRect = CGRectZero;
    
    if(sourceSize.width <= 0 || sourceSize.height <= 0 || targetSize.width <= 0 || targetSize.height <= 0)
        return returnRect;
    
    // scale to the target width
    float scaleX1 = targetSize.width;
    float scaleY1 = (sourceSize.height * targetSize.width) / sourceSize.width;
    
    // scale to the target height
    float scaleX2 = (sourceSize.width * targetSize.height) / sourceSize.height;
    float scaleY2 = targetSize.height;
    
    BOOL scaleByWidth;
    
    // now figure out which one we should use
    if(scaleX2 > targetSize.width)
    {
        scaleByWidth = isLetterBox;
    }
    else
    {
        scaleByWidth = !isLetterBox;
    }
    
    if(scaleByWidth)
    {
        returnRect.size.width = floorf(scaleX1);
        returnRect.size.height = floorf(scaleY1);
    }
    else
    {
        returnRect.size.width = floorf(scaleX2);
        returnRect.size.height = floorf(scaleY2);
    }
    
    returnRect.origin.x = floorf((targetSize.width - returnRect.size.width) / 2);
    returnRect.origin.y = floorf((targetSize.height - returnRect.size.height) / 2);
    
    return returnRect;
}

+ (NSString *)removeHTMLFromString:(NSString *)htmlString
{
    NSMutableString *mutableString = [NSMutableString stringWithString:htmlString];
    NSRange r;
    while ((r = [mutableString rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        [mutableString replaceCharactersInRange:r withString:@""];
    
    return [mutableString copy];
}

// Validators
+ (BOOL)validateEmailAddress:(NSString *)email
{
    if(email)
    {
        NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
        
        NSError *error = nil;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:emailRegEx options:NSRegularExpressionCaseInsensitive error:&error];
        NSAssert(regex, @"Unable to create regular expression");
        
        NSRange textRange = NSMakeRange(0, email.length);
        NSRange matchRange = [regex rangeOfFirstMatchInString:email options:NSMatchingReportProgress range:textRange];

        // Did find match?
        if(matchRange.location != NSNotFound)
            return YES;
    }
    
    return NO;
}

+ (UIImage *)rotateImage:(UIImage *)image byRadians:(CGFloat)radians
{
    // calculate the size of the rotated view's containing box for our drawing space
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    CGAffineTransform t = CGAffineTransformMakeRotation(radians);
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    
    // Create the bitmap context
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    
    // Move the origin to the middle of the image so we will rotate and scale around the center.
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    
    //Rotate the image context
    CGContextRotateCTM(bitmap, radians);
    
    // Now, draw the rotated/scaled image into the context
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-image.size.width / 2, -image.size.height / 2, image.size.width, image.size.height), [image CGImage]);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIImage *)getFullImageFromAssetRepresentation:(ALAsset *)asset
{
    // Get the asset's representation object
    ALAssetRepresentation *assetRep = [asset defaultRepresentation];
    
    // we need the scale and orientation to be able to construct a properly oriented and scaled UIImage out of the representation object
    CGFloat imageScale = [assetRep scale];
    
    UIImageOrientation imageOrientation = (UIImageOrientation)[assetRep orientation];
    
    CGImageRef imageReference = [assetRep fullResolutionImage];
                       
    // construct the image
    UIImage *image = [[UIImage alloc] initWithCGImage:imageReference scale:imageScale orientation:imageOrientation];
        
    return image;
}

+ (UIAlertView *)createAlertWithPrefix:(NSString *)prefix customMessage:(NSString *)customMessage showOther:(BOOL)showOther andDelegate:(id)del
{
    NSString *title = [NSString stringWithFormat:@"%@_Title", prefix];
    NSString *message = [NSString stringWithFormat:@"%@_Message", prefix];
    NSString *cancel = [NSString stringWithFormat:@"%@_Cancel", prefix];
    NSString *other = nil;

    if(showOther)
    {
        other = [NSString stringWithFormat:@"%@_Other", prefix];
        other = NSLocalizedString(other, nil);
    }
    
    NSString *completeMessage;
    
    if(customMessage)
    {
        completeMessage = [NSString stringWithFormat:@"%@%@", NSLocalizedString(message, nil), customMessage];
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(title, nil) message:(completeMessage ? completeMessage : NSLocalizedString(message, nil)) delegate:del cancelButtonTitle:NSLocalizedString(cancel, nil) otherButtonTitles:other, nil];
    
    return alert;
}

+ (NSAttributedString *)getAttributedStringFromString:(NSString *)string
{
    NSDictionary *normalAttributes = @{ NSFontAttributeName : [UIFont fontWithName:FONT_PROXIMA_REGULAR size:FONT_SIZE_TEXT_CONTENT], NSForegroundColorAttributeName : [UIColor colorWithHexString : COLOR_TEXT_CONTENT] };
    
    NSDictionary *hyperlinkAttributes = @{ NSFontAttributeName : [UIFont fontWithName:FONT_PROXIMA_BOLD size:FONT_SIZE_TEXT_CONTENT], NSForegroundColorAttributeName : [UIColor colorWithHexString : COLOR_TEXT_LINK],  NSUnderlineStyleAttributeName : @(1) };
    
    NSMutableAttributedString *textViewString = [[NSMutableAttributedString alloc] initWithString:string attributes:normalAttributes];
    
    NSRange hashRange = [string rangeOfString:@"@"];
    
    if(hashRange.location != NSNotFound)
    {
        NSString *subStr = [string substringFromIndex:hashRange.location];
        
        NSRange nextRange = [subStr rangeOfString:@" "];
        
        if(nextRange.location != NSNotFound)
            hashRange.length = nextRange.location;
        else
            hashRange.length = subStr.length;
        
        [textViewString addAttributes:hyperlinkAttributes range:hashRange];
        
       // [textView setAttributedText:textViewString];
    }
    
    NSError *error = nil;
    
    NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:&error];
    
    NSArray *matches = [detector matchesInString:string options:0 range:NSMakeRange(0, string.length)];
    
    for(NSTextCheckingResult *match in matches)
    {
        NSRange matchRange = match.range;
        [textViewString addAttributes:hyperlinkAttributes range:matchRange];
    }
    
    return textViewString;
}

@end
