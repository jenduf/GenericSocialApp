//
//  AddTextView.m
//  PeggSite
//
//  Created by Jennifer Duffey on 6/13/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import "AddTextView.h"
#import "DrawingHelper.h"

@implementation AddTextView

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
    
    CGContextSaveGState(context);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithHexString:COLOR_CONTENT_STROKE].CGColor);
    CGContextSetLineWidth(context, 1.0);
    CGContextAddPath(context, roundedRect.CGPath);
    CGContextDrawPath(context, kCGPathStroke);
    CGContextRestoreGState(context);
    
    drawStroke(context, CGPointMake(SMALL_GAP, TEXT_VIEW_TITLE_SIZE), CGPointMake(self.width - TEXT_LINE_GAP, TEXT_VIEW_TITLE_SIZE), [UIColor colorWithHexString:COLOR_CONTENT_STROKE].CGColor, 1.0);
}


@end
