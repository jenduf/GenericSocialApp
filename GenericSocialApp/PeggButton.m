//
//  PeggButton.m
//  PeggSite
//
//  Created by Jennifer Duffey on 6/10/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import "PeggButton.h"

@implementation PeggButton

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        
        if([self.titleLabel.font.fontName hasSuffix:@"Bold"] || [self.titleLabel.font.fontName hasSuffix:@"Medium"])
        {
            self.titleLabel.font = [UIFont fontWithName:FONT_PROXIMA_BOLD size:self.titleLabel.font.pointSize];
        }
        else
        {
            self.titleLabel.font = [UIFont fontWithName:FONT_PROXIMA_REGULAR size:self.titleLabel.font.pointSize];
        }
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if(self)
    {
        self.titleLabel.font = [UIFont fontWithName:FONT_PROXIMA_BOLD size:FONT_SIZE_EDIT_BUTTON];
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
