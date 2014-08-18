//
//  LoginBoxView.m
//  PeggSite
//
//  Created by Jennifer Duffey on 3/26/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import "WhiteBoxView.h"

@implementation WhiteBoxView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        UIImageView *shadowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:IMAGE_SHADOW_BOTTOM]];
        [self addSubview:shadowView];
        [shadowView centerHorizontallyInSuperView];
        [shadowView setBottom:self.height];
        
        CALayer *boxLayer = [CAShapeLayer layer];
        boxLayer.frame = CGRectMake(0, 0, self.width, (self.height - shadowView.height));
        boxLayer.cornerRadius = 6;
        boxLayer.backgroundColor = [UIColor whiteColor].CGColor;
        [self.layer addSublayer:boxLayer];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if(self)
    {
        UIImageView *shadowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:IMAGE_SHADOW_BOTTOM]];
        [self addSubview:shadowView];
        [shadowView centerHorizontallyInSuperView];
        [shadowView setBottom:self.height];
        
      /*  CALayer *boxLayer = [CAShapeLayer layer];
        boxLayer.frame = CGRectMake(0, 0, self.width, (self.height - shadowView.height));
        boxLayer.cornerRadius = 5;
        boxLayer.backgroundColor = [UIColor whiteColor].CGColor;
        [self.layer addSublayer:boxLayer];*/
    }
    
    return self;
}


/*
- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx
{
    UIImageView *shadowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:IMAGE_SHADOW_BOTTOM]];
   
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:shadowView.frame];
    layer.backgroundColor = [UIColor whiteColor].CGColor;
    layer.shadowPath = path.CGPath;
    layer.shadowColor = [UIColor blackColor].CGColor;
    layer.shadowOffset = CGSizeMake(1, 1);
   // layer.opacity = 0.5;
    layer.cornerRadius = 5;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(rect, PADDING, PADDING) cornerRadius:BOARD_BACKGROUND_CORNER_RADIUS];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(context);
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextAddPath(context, bezierPath.CGPath);
    CGContextDrawPath(context, kCGPathFill);
    CGContextRestoreGState(context);
}
 */

@end
