//
//  EmptyArticleView.m
//  PeggSite
//
//  Created by Jennifer Duffey on 5/29/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import "EmptyArticleView.h"
#import "PageDotView.h"

@implementation EmptyArticleView

- (id)initWithRegion:(Region *)region andFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        _region = region;
        
        float boardLeftPadding = SMALL_BOARD_DOT_PADDING;
        float boardTopPadding = ([Utils isFourInchScreen] ? SMALL_BOARD_DOT_PADDING : MINI_BOARD_DOT_PADDING);
        
        if(self.width == ARTICLE_WIDTH)
        {
            boardLeftPadding = BOARD_DOT_LEFT_PADDING;
            boardTopPadding = ([Utils isFourInchScreen] ? BOARD_DOT_TOP_PADDING : MINI_BOARD_DOT_PADDING);
        }
        
        NSInteger numberOfHorizontalDots = floor(self.width / boardLeftPadding) - 1;
        NSInteger numberOfVerticalDots = MIN(floor(self.height / boardTopPadding) - 1, 5);
      //  NSLog(@"number of dots: horizontal - %li vertical - %li", (long)numberOfHorizontalDots, (long)numberOfVerticalDots);
        
        float nextX = boardLeftPadding;
        float nextY = boardTopPadding;
        
        for(NSInteger i = 0; i < numberOfVerticalDots; i++)
        {
            for(NSInteger j = 0; j < numberOfHorizontalDots; j++)
            {
                PageDotView *pageDotView = [[PageDotView alloc] initWithFrame:CGRectMake(nextX, nextY, PADDING, PADDING)];
                [self addSubview:pageDotView];
                nextX += (pageDotView.width + boardLeftPadding);
            }
            
            nextX = boardLeftPadding;
            nextY += (PADDING + boardTopPadding);
        }
    }
    
    return self;
}

- (void)setActive:(BOOL)active
{
    _active = active;
    
    [self setNeedsDisplay];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(context);
    CGContextSetFillColorWithColor(context, [UIColor colorWithHexString:COLOR_EMPTY_BACKGROUND].CGColor);
    CGContextFillRect(context, rect);
    CGContextRestoreGState(context);
    
    if(self.active)
    {
        UIBezierPath *roundedPath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:10];
        CGContextSaveGState(context);
        CGContextSetStrokeColorWithColor(context, [UIColor colorWithHexString:COLOR_HIGHLIGHT_BORDER].CGColor);
        CGContextSetLineWidth(context, 6.0);
        CGContextAddPath(context, roundedPath.CGPath);
        CGContextStrokePath(context);
        CGContextRestoreGState(context);
    }
}

@end
