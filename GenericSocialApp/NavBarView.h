//
//  NavBarView.h
//  PeggSite
//
//  Created by Jennifer Duffey on 3/5/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NavBarViewDelegate;

@class NavButton, Divider, TitleView;
@interface NavBarView : UIView

@property (nonatomic, weak) IBOutlet NavButton *leftButton, *rightButton;
@property (nonatomic, weak) IBOutlet TitleView *titleView;
@property (nonatomic, weak) IBOutlet Divider *divider;
@property (nonatomic, weak) IBOutlet id <NavBarViewDelegate> delegate;
@property (nonatomic, strong) User *user;
@property (nonatomic, assign) NavState currentNavState;
@property (nonatomic, assign) BOOL addMode, editMode;

- (void)setUser:(User *)user;
- (void)setTitle:(NSString *)title forState:(NavState)state;
- (void)updateForState:(NavState)navState;

@end

@protocol NavBarViewDelegate

- (void)navBarViewDidRequestShowProfile:(NavBarView *)navBarView;

@end