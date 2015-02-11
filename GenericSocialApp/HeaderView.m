//
//  HeaderView.m
//  PeggSite
//
//  Created by Jennifer Duffey on 4/9/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import "HeaderView.h"
#import "Divider.h"

@implementation HeaderView

- (id)initWithFrame:(CGRect)frame andText:(NSString *)text
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        Divider *divider = [[Divider alloc] initWithFrame:CGRectMake(0, SMALL_PADDING, self.width, 1)];
        [self addSubview:divider];
        [divider centerHorizontallyInSuperView];
        
        PeggLabel *peggLabel = [[PeggLabel alloc] initWithText:text color:[UIColor colorWithHexString:COLOR_ORANGE_BUTTON] font:[UIFont fontWithName:FONT_PROXIMA_SEMIBOLD size:FONT_SIZE_SUBHEADER] andFrame:CGRectZero];
        peggLabel.backgroundColor = [UIColor whiteColor];
        peggLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:peggLabel];
        [peggLabel sizeToFit];
        [peggLabel centerHorizontallyInSuperView];
    }
    
    return self;
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
