//
//  PSViewController.m
//  PeggSite
//
//  Created by Jennifer Duffey on 3/5/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import "PSViewController.h"

@interface PSViewController ()

@end

@implementation PSViewController

- (void)prepareView
{
    NSLog(@"prepare view - registering observers for %@", NSStringFromClass([self class]));
}

- (void)animateView
{
    NSLog(@"animate view");
}

- (void)prepareExit
{
    NSLog(@"prepare exit - unregistering observers for %@", NSStringFromClass([self class]));
    
    [self unRegisterAllObservers];
}

- (void)animateExit
{
    NSLog(@"animate exit");
}

- (void)showLoader
{
    [self.navController showSpinnerForType:self.spinnerType];
}

- (void)hideLoader
{
    if(self.shouldHideLoader)
        [self.navController hideSpinner];
}

- (void)dataRetrieved:(NSData *)returnData
{
    // override
}

- (void)setAddMode:(BOOL)addMode
{
    _addMode = addMode;
}

- (void)setEditMode:(BOOL)editMode
{
    _editMode = editMode;
}

- (void)setCropMode:(BOOL)cropMode
{
    _cropMode = cropMode;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
   // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
	//[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self unRegisterAllObservers];
}

- (void)unRegisterAllObservers
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// hide status bar
- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)moveForwardIfReady
{
    // override
}

- (void)refresh
{
    // override
}

/*
#pragma mark - Keyboard Handling
- (void)keyboardWillShow:(NSNotification *)note
{
    // get size of keyboard
    self.keyboardSize = [[[note userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    // adjust the bottom content inset of your scroll view by the keyboard height
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, self.keyboardSize.height, 0.0);
    self.formScrollView.contentInset = contentInsets;
    self.formScrollView.scrollIndicatorInsets = contentInsets;
}

- (void)keyboardWillHide:(NSNotification *)note
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.formScrollView.contentInset = contentInsets;
    self.formScrollView.scrollIndicatorInsets = contentInsets;
}
*/


- (void)dismissKeyboard:(UIGestureRecognizer *)recognizer
{
    [self.activeTextField resignFirstResponder];
    [self.activeTextView resignFirstResponder];
    
    //if(self.activeTextField)
    //{
     //   [self.activeTextField resignFirstResponder];
       // self.activeTextField = nil;
    //}
    
    //if(self.activeTextView)
    //{
      //  [self.activeTextView resignFirstResponder];
      //  self.activeTextView = nil;
    //}
    
    //self.view.gestureRecognizers = nil;
}

/*
- (void)shiftForKeyboard
{
    UIView *activeView = (self.activeTextView ? self.activeTextView : self.activeTextField);
    
    // Scroll the target text field into view
    CGRect aRect = self.view.frame;
    aRect.size.height -= self.keyboardSize.height;
    if(!CGRectContainsPoint(aRect, activeView.origin))
    {
        CGPoint scrollPoint = CGPointMake(0.0, activeView.top - (self.keyboardSize.height - 15));
        [self.formScrollView setContentOffset:scrollPoint animated:YES];
    }
}*/

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Navigation Delegate Methods
- (void)didMoveToParentViewController:(UIViewController *)parent
{
	self.navController = (PSNavController *)parent;
	
	if(parent != nil)
	{
		[self animateView];
	}
	else
	{
        [self animateExit];
	}
}

- (void)willMoveToParentViewController:(UIViewController *)parent
{
	self.navController = (PSNavController *)parent;
	
	if(parent != nil)
	{
		[self prepareView];
	}
	else
	{
		[self prepareExit];
	}
}

#pragma mark - DataManagerDelegate
- (void)dataManager:(DataManager *)dataManager didReturnData:(id)data
{
    
}

- (void)dataManager:(DataManager *)dataManager downloadProgress:(double)progress
{
    //[self.navController.progressView setProgress:progress];
}

#pragma mark -
#pragma mark UITextField Delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(!self.activeTextField)
    {
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
        [self.view addGestureRecognizer:tapRecognizer];
    }
    
    self.activeTextField = (PeggTextField *)textField;
    
    if(![self.activeTextField noScroll])
        [self.view slideUpIfNecessaryForTextField:textField];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if(![self.activeTextField noScroll])
        [self.view slideDownIfNecessary];
    
    self.activeTextField = nil;
    
    self.view.gestureRecognizers = nil;
}

#pragma mark -
#pragma mark UITextView Delegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if(!self.placeholder)
        self.placeholder = textView.text;
    
    if(self.placeholder && self.placeholder.length > 0)
    {
        if([textView.text isEqualToString:self.placeholder])
            textView.text = @"";
    }
    
    textView.textColor = [UIColor colorWithHexString:COLOR_CAPTION_TEXT];
    
    if(!self.activeTextView)
    {
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
        [self.view addGestureRecognizer:tapRecognizer];
    }
    
    self.activeTextView = (PeggTextView *)textView;
    
    if(![self.activeTextView noScroll])
        [self.view slideUpIfNecessaryForTextView:textView];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if(textView.text.length == 0)
    {
        textView.text = self.placeholder;
        textView.textColor = [UIColor colorWithHexString:COLOR_PLACEHOLDER_TEXT];
    }
    
    if(![self.activeTextView noScroll])
        [self.view slideDownIfNecessary];
    
    self.activeTextView = nil;
    
    self.view.gestureRecognizers = nil;
}

#pragma mark -
#pragma mark AvatarView Delegate
- (void)avatarViewWasSelected:(AvatarView *)avatarView
{
    [self.navController selectPhoto];
}


#pragma mark - Nav Bar Visibility
- (BOOL)showNav
{
    // override
    NSAssert(NO, @"%@ must have an override for %s", NSStringFromClass([self class]), __PRETTY_FUNCTION__);
    
    return YES;
}

#pragma mark - Tab Bar Visibility
- (BOOL)showTabs
{
    // override
    NSAssert(NO, @"%@ must have an override for %s", NSStringFromClass([self class]), __PRETTY_FUNCTION__);
    
    return YES;
}

#pragma mark - Spinner Type For View
- (SpinnerType)spinnerType
{
    // override
    NSAssert(NO, @"%@ must have an override for %s", NSStringFromClass([self class]), __PRETTY_FUNCTION__);
    
    return SpinnerTypeNone;
}

- (NSString *)title
{
    // override
    NSAssert(NO, @"%@ must have an override for %s", NSStringFromClass([self class]), __PRETTY_FUNCTION__);
    
    return @"";
}

@end
