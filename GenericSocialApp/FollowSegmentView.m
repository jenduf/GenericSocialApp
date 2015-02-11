
//
//  FollowSegmentView.m
//  PeggSite
//
//  Created by Jennifer Duffey on 5/23/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import "FollowSegmentView.h"
#import "FollowButtonView.h"

@implementation FollowSegmentView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (IBAction)segmentSelected:(id)sender
{
    for(FollowButtonView *fbv in self.subviews)
    {
        [fbv setActive:NO];
    }
    
    UIGestureRecognizer *recognizer = (UIGestureRecognizer *)sender;
    
    FollowButtonView *followButtonView = (FollowButtonView *)recognizer.view;
    
    [followButtonView setActive:YES];
    
    [self.delegate followSegmentSelected:followButtonView.tag];
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
