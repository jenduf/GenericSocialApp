//
//  PeggLabel.m
//  PeggSite
//
//  Created by Jennifer Duffey on 3/7/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import "PeggLabel.h"

@implementation PeggLabel

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if(self)
    {
        switch(self.tag)
        {
            case FONT_TAG_PROXIMA:
            {
                self.font = [UIFont fontWithName:FONT_PROXIMA_REGULAR size:self.font.pointSize];
            }
                break;
                
            case FONT_TAG_PROXIMA_SEMIBOLD:
            {
                self.font = [UIFont fontWithName:FONT_PROXIMA_SEMIBOLD size:self.font.pointSize];
            }
                break;
                
            case FONT_TAG_PROXIMA_BOLD:
            {
                self.font = [UIFont fontWithName:FONT_PROXIMA_BOLD size:self.font.pointSize];
            }
                break;
                
            case FONT_TAG_PROXIMA_EXTRABOLD:
            {
                self.font = [UIFont fontWithName:FONT_PROXIMA_EXTRA_BOLD size:self.font.pointSize];
            }
                break;
                
            default:
            {
                if([self.font.fontName hasSuffix:@"Bold"] || [self.font.fontName hasSuffix:@"Medium"])
                {
                    self.font = [UIFont fontWithName:FONT_PROXIMA_SEMIBOLD size:self.font.pointSize];
                }
            }
                break;
        }
    }
    
    return self;
}

- (id)initWithText:(NSString *)text color:(UIColor *)color font:(UIFont *)font andFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if(self)
    {
        self.backgroundColor = [UIColor clearColor];
        
        self.text = text;
        
        self.textColor = color;
        
        self.font = font;
    }
    
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
