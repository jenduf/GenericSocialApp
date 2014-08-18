//
//  PageControlView.h
//  PeggSite
//
//  Created by Jennifer Duffey on 3/27/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PageControlView : UIView

@property (nonatomic, assign) NSInteger pageCount;
@property (nonatomic, assign) NSInteger indexSelected;
@property (nonatomic, strong) UIView *indicatorView;

- (void)setIndexSelected:(NSInteger)indexSelected animated:(BOOL)animated;

@end
