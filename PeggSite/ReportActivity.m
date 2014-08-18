//
//  ReportActivity.m
//  PeggSite
//
//  Created by Jennifer Duffey on 4/25/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import "ReportActivity.h"

@implementation ReportActivity

- (NSString *)activityTitle
{
    return @"Report Content";
}

- (NSString *)activityType
{
    return @"com.peggsite.report";
}

- (UIImage *)activityImage
{
    return [UIImage imageNamed:@"report_icon"];
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems
{
    return YES;
}

- (void)prepareWithActivityItems:(NSArray *)activityItems
{
    for(NSObject *item in activityItems)
    {
        if([item isKindOfClass:[NSString class]])
        {
            self.text = (NSString *)item;
        }
        else if([item isKindOfClass:[NSURL class]])
        {
            self.url = (NSURL *)item;
        }
    }
}


@end
