//
//  CropControlsView.m
//  PeggSite
//
//  Created by Jennifer Duffey on 6/10/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import "CropControlsView.h"
#import "DrawingHelper.h"

@implementation CropControlsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if(self)
    {
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
 CGContextRef context = UIGraphicsGetCurrentContext();
 
/* CGContextSaveGState(context);
 CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
 CGContextSetLineWidth(context, 3);
 CGContextStrokeRect(context, rect);
 CGContextRestoreGState(context);
    */
    NSLog(@"CROP FRAME: %@", NSStringFromCGRect(rect));
 
 drawStroke(context, CGPointMake(0, self.height / 3), CGPointMake(self.width, self.height / 3), [UIColor whiteColor].CGColor, 1.0);
 
 drawStroke(context, CGPointMake(0, self.height / 3 * 2), CGPointMake(self.width, self.height / 3 * 2), [UIColor whiteColor].CGColor, 1.0);
 
 drawStroke(context, CGPointMake(self.width / 3, 0), CGPointMake(self.width / 3, self.height), [UIColor whiteColor].CGColor, 1.0);
 
 drawStroke(context, CGPointMake(self.width / 3 * 2, 0), CGPointMake(self.width / 3 * 2, self.height), [UIColor whiteColor].CGColor, 1.0);
}


@end
