//
//  SegmentBarView.m
//  PeggSite
//
//  Created by Jennifer Duffey on 4/8/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import "TabBarView.h"

@implementation TabBarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (IBAction)tabSelected:(id)sender
{
    for(UIButton *btn in self.subviews)
    {
        [btn setSelected:NO];
    }
    
    UIButton *btn = (UIButton *)sender;
    
    if(btn.tag != TabButtonStateAdd)
        [btn setSelected:YES];
    
    [self.delegate tabBarView:self didSelectIndex:btn.tag];
}

- (void)setActive:(BOOL)active
{
    UIButton *btn = (UIButton *)[self viewWithTag:TabButtonStateActivity];
    
    NSString *imageName;
    
    if(active)
    {
        imageName = [NSString stringWithFormat:@"%@_active", IMAGE_ACTIVITY_ICON];
        [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateHighlighted];
        [btn setHighlighted:YES];
    }
    else
    {
        [btn setSelected:YES];
       // imageName = [NSString stringWithFormat:@"%@_selected", IMAGE_ACTIVITY_ICON];
    }
}

- (void)setSelectedIndex:(NSInteger)index
{
    for(UIButton *btn in self.subviews)
    {
        if(btn.tag == index)
            [btn setSelected:YES];
        else
            [btn setSelected:NO];
    }
}

- (void)setAddMode:(BOOL)addMode
{
    _addMode = addMode;
    
    UIButton *addButton = (UIButton *)[self viewWithTag:TabButtonStateAdd];
    [addButton setSelected:addMode];
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
