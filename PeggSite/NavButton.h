//
//  NavButton.h
//  PeggSite
//
//  Created by Jennifer Duffey on 3/5/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NavButton : PeggButton

- (void)updateForState:(NavButtonState)state;
- (void)updateForState:(NavButtonState)state withAlignment:(UIControlContentHorizontalAlignment)alignment;

@end
