//
//  PageControlView.m
//  PeggSite
//
//  Created by Jennifer Duffey on 3/27/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import "PageControlView.h"
#import "PageDotView.h"

@implementation PageControlView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if(self)
    {
        self.backgroundColor = [[UIColor colorWithHexString:COLOR_SCROLL_BED] colorWithAlphaComponent:0.4];
        self.layer.cornerRadius = 1;
        self.layer.masksToBounds = YES;
        self.indicatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, INDICATOR_WIDTH, INDICATOR_HEIGHT)];
        [self.indicatorView setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:self.indicatorView];
        
        [self.indicatorView centerVerticallyInSuperView];
    }
    
    return self;
}

- (void)setPageCount:(NSInteger)pageCount
{
    _pageCount = pageCount;
}

- (void)setIndexSelected:(NSInteger)indexSelected
{
    if(indexSelected <= self.pageCount)
        [self setIndexSelected:indexSelected animated:YES];
}

- (void)setIndexSelected:(NSInteger)indexSelected animated:(BOOL)animated
{
    _indexSelected = indexSelected;
 
    float duration = (animated ? 0.4 : 0.0);
    
    [UIView animateWithDuration:duration animations:^
    {
        if(indexSelected == self.pageCount)
        {
            [self.indicatorView setRight:self.width];
        }
        else
        {
            NSInteger newLeft = MAX((((indexSelected + 1) * INDICATOR_TAB) - INDICATOR_WIDTH), 0);
            [self.indicatorView setLeft:newLeft];
        }
    }];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
