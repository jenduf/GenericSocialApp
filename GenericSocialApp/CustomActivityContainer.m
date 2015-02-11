//
//  CustomActivityContainer.m
//  PeggSite
//
//  Created by Jennifer Duffey on 4/25/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import "CustomActivityContainer.h"
#import "UIImage+Resize.h"

@implementation CustomActivityContainer

- (instancetype)initWithURL:(NSURL *)url
{
    self = [super init];
    
    if(self)
    {
        _url = url;
    }
    
    return self;
}

#pragma mark - UIActivityItemSource
- (id)activityViewControllerPlaceholderItem:(UIActivityViewController *)activityViewController
{
    // Because the URL is already set it can be the placeholder. The API will use this to determine that an object of class type NSURL will be sent.
    return self.url;
}

- (id)activityViewController:(UIActivityViewController *)activityViewController itemForActivityType:(NSString *)activityType
{
    // Return the URL being used. This URL has a custom scheme
    return self.url;
}

- (UIImage *)activityViewController:(UIActivityViewController *)activityViewController thumbnailImageForActivityType:(NSString *)activityType suggestedSize:(CGSize)size
{
    // Add image to improve the look of the alert received on the other side, make sure it is scaled to the suggested size.
    return [UIImage imageWithImage:[UIImage imageNamed:@"report_icon"] scaledToFillToSize:size];
}

@end
