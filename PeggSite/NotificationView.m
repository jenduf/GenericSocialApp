//
//  NotificationView.m
//  PeggSite
//
//  Created by Jennifer Duffey on 3/7/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import "NotificationView.h"

@implementation NotificationView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx
{
    layer.masksToBounds = YES;
    layer.backgroundColor = [UIColor colorWithHexString:COLOR_NOTIFICATION_BACKGROUND].CGColor;
    //layer.borderColor = [UIColor colorWithHexString:COLOR_NOTIFICATION_BORDER].CGColor;
    //layer.borderWidth = 2;
    
    if(self.tag == 0)
        layer.cornerRadius = 5;
    else
        layer.cornerRadius = (self.height / 2);
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}


@end
