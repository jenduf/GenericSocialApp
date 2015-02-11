//
//  AddContentBox.m
//  PeggSite
//
//  Created by Jennifer Duffey on 6/13/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import "AddContentBox.h"

@implementation AddContentBox

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(rect, SMALL_GAP, SMALL_GAP) cornerRadius:CONTENT_CORNER_RADIUS];
    
    CGFloat dashes[] = {4, 2};
    
    CGContextSaveGState(context);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithHexString:COLOR_CONTENT_STROKE].CGColor);
    CGContextSetFillColorWithColor(context, [UIColor colorWithHexString:COLOR_CONTENT_BACKGROUND].CGColor);
    CGContextSetLineWidth(context, 1.0);
    CGContextSetLineDash(context, 0, dashes, 2);
    CGContextAddPath(context, roundedRect.CGPath);
    CGContextDrawPath(context, kCGPathFillStroke);
    CGContextRestoreGState(context);
}


@end
