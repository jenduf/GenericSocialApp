//
//  Divider.m
//  PeggSite
//
//  Created by Jennifer Duffey on 3/27/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import "Divider.h"

@implementation Divider

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if(self)
    {
        self.backgroundColor = [[UIColor colorWithHexString:COLOR_ARTICLE_DIVIDER] colorWithAlphaComponent:0.3];
    }
    
    return self;
}

- (id)initWithColor:(UIColor *)color andFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if(self)
    {
        self.backgroundColor = [color colorWithAlphaComponent:0.3];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if(self)
    {
        self.backgroundColor = [[UIColor colorWithHexString:COLOR_ARTICLE_DIVIDER] colorWithAlphaComponent:0.3];
    }
    
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(context);
    CGContextSetFillColorWithColor(context, [UIColor colorWithHexString:COLOR_ARTICLE_DIVIDER].CGColor);
    CGContextSetAlpha(context, 0.3);
    CGContextFillRect(context, rect);
    CGContextRestoreGState(context);
}
*/

@end
