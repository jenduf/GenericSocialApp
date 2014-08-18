//
//  PhotoView.m
//  PeggSite
//
//  Created by Jennifer Duffey on 6/13/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import "PhotoView.h"

@implementation PhotoView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        [self setUpHighlightLayer];
    }
    
    return self;
}

- (void)setUpHighlightLayer
{
    self.highlightLayer = [CAShapeLayer layer];
    [self.highlightLayer setFrame:self.frame];
    self.highlightLayer.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3].CGColor;
    self.highlightLayer.borderWidth = 3.0;
    self.highlightLayer.cornerRadius = CONTENT_CORNER_RADIUS;
    self.highlightLayer.borderColor = [UIColor colorWithHexString:COLOR_HIGHLIGHT_BORDER].CGColor;
    [self.layer addSublayer:self.highlightLayer];
    [self.highlightLayer setHidden:YES];
}

- (void)setSelected:(BOOL)selected
{
    _selected = selected;
    
    [self.highlightLayer setHidden:!self.selected];
    
  //  [self setNeedsDisplay];
}


- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx
{
    [super drawLayer:layer inContext:ctx];
    
    self.photoImageView.layer.cornerRadius = CONTENT_CORNER_RADIUS;
    self.photoImageView.layer.masksToBounds = YES;
    
    if(!self.highlightLayer)
        [self setUpHighlightLayer];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}


@end
