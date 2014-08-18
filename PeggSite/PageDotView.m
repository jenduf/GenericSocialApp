//
//  PageCircleView.m
//  PeggSite
//
//  Created by Jennifer Duffey on 3/27/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import "PageDotView.h"

@implementation PageDotView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

- (void)setArticleExists:(BOOL)articleExists
{
    _articleExists = articleExists;
    
    [self setNeedsDisplay];
}

- (void)setIsSelected:(BOOL)isSelected
{
    _isSelected = isSelected;
    
    [self setNeedsDisplay];
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx
{
    NSString *bgColorString;
    
    if(self.isSelected)
    {
        bgColorString = COLOR_DOT_SELECTED;
    }
    else
    {
        if(self.articleExists)
        {
            bgColorString = COLOR_DOT_ACTIVE;
            layer.opacity = 0.9;
        }
        else
        {
            bgColorString = COLOR_DOT_INACTIVE;
            layer.opacity = 0.45;
        }
    }

    layer.backgroundColor = [UIColor colorWithHexString:bgColorString].CGColor;
    layer.cornerRadius = (self.height / 2);
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}


@end
