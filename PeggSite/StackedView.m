//
//  StackedView.m
//  PeggSite
//
//  Created by Jennifer Duffey on 3/7/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import "StackedView.h"

@implementation StackedView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGRect strokeRect = CGRectInset(rect, 0, 2);
	UIBezierPath *strokePath = [UIBezierPath bezierPathWithRect:strokeRect];
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:rect];
    
    CGContextSaveGState(context);
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextAddPath(context, strokePath.CGPath);
    CGContextClip(context);
    CGContextAddPath(context, strokePath.CGPath);
    CGContextDrawPath(context, kCGPathFill);
    CGContextRestoreGState(context);
    
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, CGSizeMake(0, 0), 3, [UIColor blackColor].CGColor);
    CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
    CGContextSetLineWidth(context, 2.0);
    CGContextAddPath(context, path.CGPath);
    CGContextAddPath(context, strokePath.CGPath);
    CGContextEOClip(context);
    CGContextAddPath(context, strokePath.CGPath);
    CGContextDrawPath(context, kCGPathStroke);
    CGContextRestoreGState(context);
}

@end
