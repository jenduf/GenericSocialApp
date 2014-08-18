//
//  FollowButtonView.m
//  PeggSite
//
//  Created by Jennifer Duffey on 3/31/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import "FollowButtonView.h"

@implementation FollowButtonView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        if(self.tag == INDEX_SELECTED_FOLLOWERS)
            [self setActive:YES];
        else
            [self setActive:NO];
    }
    
    return self;
}

- (void)setActive:(BOOL)active
{
    _active = active;
    
    if(active)
    {
        self.countLabel.textColor = [UIColor colorWithHexString:COLOR_ORANGE_BUTTON];
        self.textLabel.textColor = [UIColor colorWithHexString:COLOR_FOLLOW_BUTTON_TEXT_ACTIVE];
        self.layer.backgroundColor = [UIColor whiteColor].CGColor;
        self.layer.borderWidth = 1;
    }
    else
    {
        self.countLabel.textColor = [UIColor colorWithHexString:COLOR_FOLLOW_BUTTON_TEXT_INACTIVE];
        self.textLabel.textColor = [UIColor colorWithHexString:COLOR_FOLLOW_BUTTON_TEXT_INACTIVE];
        self.layer.backgroundColor = [[UIColor colorWithHexString:COLOR_FOLLOW_BUTTON_INACTIVE] colorWithAlphaComponent:0.6].CGColor;
        self.layer.borderWidth = 0;
    }
    
    [self setNeedsDisplay];
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx
{
   // layer.cornerRadius = FOLLOW_BUTTON_CORNER_RADIUS;
    layer.borderColor = [UIColor colorWithHexString:COLOR_FOLLOW_BUTTON_BORDER].CGColor;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}


@end
