//
//  ShadeView.m
//  PeggSite
//
//  Created by Jennifer Duffey on 6/11/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import "ShadeView.h"

@implementation ShadeView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.opaque = NO;
    }
    
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, rect);
    
    CGContextSetRGBFillColor(context, 0, 0, 0.05, 0.8);
    CGContextFillRect(context, rect);
    
    CGRect clearRect = CGRectMake(ARTICLE_OFFSET, CROP_OFFSET, MEDIA_WIDTH, MEDIA_HEIGHT);
    
    CGContextClearRect(context, clearRect);
    
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextSetLineWidth(context, 2);
    CGContextStrokeRect(context, clearRect);
}


@end
