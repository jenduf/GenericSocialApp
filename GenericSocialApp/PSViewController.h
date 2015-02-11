//
//  PSViewController.h
//  PeggSite
//
//  Created by Jennifer Duffey on 3/5/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+KeyboardHelpers.h"

@class PeggTextView, PeggTextField;
@interface PSViewController : UIViewController
<DataManagerDelegate, UITextFieldDelegate, UITextViewDelegate, AvatarViewDelegate>

@property (nonatomic, strong) PSNavController *navController;
@property (nonatomic, strong) PeggTextField *activeTextField;
@property (nonatomic, strong) PeggTextView *activeTextView;
@property (nonatomic, strong) UIImage *imageSelected;
@property (nonatomic, assign) BOOL addMode, editMode, cropMode, keyboardShowing, shouldHideLoader;
@property (nonatomic, strong) NSString *placeholder;

- (BOOL)showNav;
- (BOOL)showTabs;
- (SpinnerType)spinnerType;
- (NSString *)title;
- (void)prepareView;
- (void)animateView;
- (void)prepareExit;
- (void)animateExit;
- (void)showLoader;
- (void)hideLoader;
- (void)moveForwardIfReady;
- (void)refresh;
- (void)dataRetrieved:(NSData *)returnData;

@end
