//
//  SegmentBarView.h
//  PeggSite
//
//  Created by Jennifer Duffey on 4/8/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TabBarViewDelegate;

@interface TabBarView : UIView

@property (nonatomic, weak) IBOutlet id <TabBarViewDelegate> delegate;
@property (nonatomic, assign) BOOL addMode;

- (IBAction)tabSelected:(id)sender;
- (void)setSelectedIndex:(NSInteger)index;
- (void)setActive:(BOOL)active;

@end

@protocol TabBarViewDelegate

- (void)tabBarView:(TabBarView *)tabBarView didSelectIndex:(NSInteger)index;

@end