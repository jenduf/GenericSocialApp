//
//  UIView+KeyboardHelpers.h
//  Esteban Torres
//
//  Created by Esteban Torres on 4/10/13.
//  Copyright (c) 2013 Esteban Torres. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (KeyboardHelpers)

@property (nonatomic, retain) NSNumber *animatedDistance;

/// Detects if the keyboard is going to cover the textfield
- (void)slideUpIfNecessaryForTextField:(UITextField *)textField;

// Detects if the keyboard is going to cover the textview
- (void)slideUpIfNecessaryForTextView:(UITextView *)textView;

/// Detects if the view was moved up and slides it back to "normal"
- (void) slideDownIfNecessary;

- (void) resignTextFields:(UIView *)container;
- (void) checkTextField:(id)object;
- (void) cleanTextField:(id)object;
@end
