//
//  UIView+KeyboardHelpers.m
//  Esteban Torres
//
//  Created by Esteban Torres on 4/10/13.
//  Copyright (c) 2013 Esteban Torres. All rights reserved.
//

#import "UIView+KeyboardHelpers.h"
#import "ETObject.h"

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;

static char const * const AnimatedDistanceKey = "AnimatedDistanceKey";

@implementation UIView (KeyboardHelpers)
@dynamic animatedDistance;

- (id)animatedDistance {
    return [self userInfoForKey:AnimatedDistanceKey];
}

- (void)setAnimatedDistance:(id)animatedDistance
{
    [self attachUserInfo:animatedDistance forKey:AnimatedDistanceKey];
}

- (void) slideUpIfNecessaryForTextField:(UITextField *)textField
{
    CGRect textFieldRect = [self.window convertRect:textField.bounds fromView:textField];
    
    [self slideUpWithRect:textFieldRect];
}

- (void)slideUpIfNecessaryForTextView:(UITextView *)textView
{
    CGRect textViewRect = [self.window convertRect:textView.bounds fromView:textView];
    
    [self slideUpWithRect:textViewRect];
}

- (void)slideUpWithRect:(CGRect)rect
{
    CGRect viewRect = [self.window convertRect:self.bounds fromView:self];
    
    CGFloat midline = rect.origin.y + 0.5 * rect.size.height;
    CGFloat numerator = midline - viewRect.origin.y - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator = (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION) * viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
    
    if (heightFraction < 0.0)
    {
        heightFraction = 0.0;
    }
    else if (heightFraction > 1.0)
    {
        heightFraction = 1.0;
    }
    
    UIInterfaceOrientation orientation =
    [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait ||
        orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        self.animatedDistance = @(floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction));
    }
    else
    {
        self.animatedDistance = @(floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction));
    }
    
    CGRect viewFrame = self.frame;
    viewFrame.origin.y -= self.animatedDistance.floatValue;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self setFrame:viewFrame];
    
    [UIView commitAnimations];
}

- (void) slideDownIfNecessary
{
    NSNumber *animDist = self.animatedDistance;
    
    if (!animDist) {
        return;
    }
    
    CGRect viewFrame = self.frame;
    viewFrame.origin.y += self.animatedDistance.floatValue;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self setFrame:viewFrame];
    
    [UIView commitAnimations];
}

#pragma mark - Internal UI Helpers

- (void) resignTextFields:(UIView *)container{
    for (id txtFld in [container subviews]) {
        [self checkTextField:txtFld];
    }
}

- (void) checkTextField:(id)object{
    if ([object isKindOfClass:[UITextField class]]) {
        [(UITextField *)object resignFirstResponder];
    }
    else{
        if ([object isKindOfClass:[UIView class]]) {
            [self resignTextFields:object];
        }
    }
}

- (void) cleanTextFields:(UIView *)container{
    for (id txtFld in [container subviews]) {
        [self cleanTextField:txtFld];
    }
}

- (void) cleanTextField:(id)object{
    if ([object isKindOfClass:[UITextField class]]) {
        [(UITextField *)object setText:@""];
    }
    else{
        if ([object isKindOfClass:[UIView class]]) {
            [self resignTextFields:object];
        }
    }
}

@end
