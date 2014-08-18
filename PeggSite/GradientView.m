//
//  GradientView.m
//  Toric
//
//  Created by Jennifer Duffey on 8/1/13.
//  Copyright (c) 2013 Jennifer Duffey. All rights reserved.
//

#import "GradientView.h"

@implementation GradientView

- (void)setColors:(NSArray *)colors andLocations:(NSArray *)locations
{
    _colors = colors;
    
    _locations = locations;
    
    [self drawBackgroundLayer];
}

- (void)setColors:(NSArray *)colors
{
    _colors = colors;
    
    _locations = (@[@0.0f, @1.0f]);
    
    [self drawBackgroundLayer];
}

- (void)layoutSubviews
{
	// set gradient frame
	_backgroundLayer.frame = self.bounds;
	
	[super layoutSubviews];
}

- (void)drawBackgroundLayer
{
	// check if the property has been set already
	if(!_backgroundLayer)
	{
		// instantiate the gradient layer
		_backgroundLayer = [CAGradientLayer layer];
    }
    else
    {
        [_backgroundLayer removeFromSuperlayer];
    }
    
    // set the colors
    _backgroundLayer.colors = self.colors;
    
    // set the stops
    _backgroundLayer.locations = self.locations;
    
    _backgroundLayer.cornerRadius = self.cornerRadius;
    
    // add the gradient to the layer hierarchy
    [self.layer insertSublayer:_backgroundLayer atIndex:0];
        
    /*self.layer.shadowRadius = 2.0;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 0);
    self.layer.shadowOpacity = 1.0;*/
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(context);
    
    //CGContextSetShadowWithColor(context, CGSizeMake(-2, 0), 10.0, [UIColor blackColor].CGColor);
    
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    
    CGContextFillRect(context, CGRectMake(0, 0, rect.size.width, (rect.size.height - 1)));
    
    CGContextRestoreGState(context);
}
*/

@end
