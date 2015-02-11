//
//  PeggTextView.m
//  PeggSite
//
//  Created by Jennifer Duffey on 4/18/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import "PeggTextView.h"

@implementation PeggTextView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        if([self.font.fontName hasSuffix:@"Bold"] || [self.font.fontName hasSuffix:@"Medium"])
        {
            self.font = [UIFont fontWithName:FONT_PROXIMA_BOLD size:self.font.pointSize];
        }
        else
        {
            self.font = [UIFont fontWithName:FONT_PROXIMA_REGULAR size:self.font.pointSize];
        }
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame andFontSize:(CGFloat)fontSize
{
    self = [super initWithFrame:frame];
    
    if(self)
    {
        self.backgroundColor = [UIColor clearColor];
        
        self.font = [UIFont fontWithName:FONT_PROXIMA_BOLD size:fontSize];
    }
    
    return self;
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx
{
    if(self.showBorder)
    {
        layer.borderColor = [UIColor colorWithHexString:COLOR_CONTENT_STROKE].CGColor;
        layer.borderWidth = 1.0;
        layer.cornerRadius = CONTENT_CORNER_RADIUS;
    }
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}

@end
