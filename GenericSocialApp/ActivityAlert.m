//
//  ActivityAlert.m
//  PeggSite
//
//  Created by Jennifer Duffey on 4/29/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import "ActivityAlert.h"

static UIAlertView *alertView = nil;
static UIActivityIndicatorView *activity = nil;

@implementation ActivityAlert

+ (void)presentWithText:(NSString *)text
{
    if(alertView)
    {
        // with an existing alert, update the text and re-show it
        alertView.title = text;
        [alertView show];
    }
    else
    {
        // create an alert with plenty of room
        alertView = [[UIAlertView alloc] initWithTitle:text message:@"\n\n\n\n\n\n" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
        [alertView show];
        
        // build a new activity indicator and animate it
        activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        activity.center = CGPointMake(CGRectGetMidX(alertView.bounds), CGRectGetMidY(alertView.bounds));
        [activity startAnimating];
        
        // add it to the alert
        [alertView addSubview:activity];
    }
}

+ (void)setTitle:(NSString *)title
{
    alertView.title = title;
}

// Update the alert's message, making sure to pad it to the proper number of lines. Keep the message short.
+ (void)setMessage:(NSString *)message
{
    NSString *msg = message;
    while([msg componentsSeparatedByString:@"\n"].count < 7)
    {
        msg = [msg stringByAppendingString:@"\n"];
    }
    
    alertView.message = msg;
}

// Dismiss the alert and reset the static variables
+ (void)dismiss
{
    if(alertView)
    {
        [alertView dismissWithClickedButtonIndex:0 animated:YES];
        
        [activity removeFromSuperview];
        activity = nil;
        alertView = nil;
    }
}

@end
