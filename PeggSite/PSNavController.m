//
//  PSNavController.m
//  PeggSite
//
//  Created by Jennifer Duffey on 3/5/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import "PSNavController.h"
#import "PSViewController.h"
#import "BoardViewController.h"
#import "ProfileViewController.h"
#import "ArticleViewController.h"
#import "NavBarView.h"
#import "TitleView.h"
#import "TabBarView.h"
#import "CropView.h"
#import "ReportActivity.h"
#import "SpinnerView.h"

@interface PSNavController ()
<DataManagerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, TabBarViewDelegate, NavBarViewDelegate, CropViewDelegate>

@property (nonatomic, weak) IBOutlet NavBarView *navBarView;
@property (nonatomic, weak) IBOutlet TabBarView *tabBarView;
@property (nonatomic, weak) IBOutlet CropView *cropView;
@property (nonatomic, weak) IBOutlet SpinnerView *spinnerView;
@property (nonatomic, assign) NSInteger selectedTab;

- (IBAction)navButtonSelected:(id)sender;

@end

@implementation PSNavController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
   // [self.contentHolderView setFrame:CGRectMake(0, 0, APP_WIDTH, APP_HEIGHT)];
    
    [self navigateToViewControllerWithIdentifier:INTRO_VIEW_CONTROLLER animated:NO];
}

- (void)toggleHeader:(BOOL)show
{
    if(show)
    {
        [self.navBarView setHidden:NO];
        
        [UIView animateWithDuration:ANIMATION_DURATION animations:^
         {
             [self.navBarView setTop:0];
         }];
    }
    else
    {
        [UIView animateWithDuration:ANIMATION_DURATION animations:^
         {
             [self.navBarView setBottom:0];
         }];
        
    }
}

- (void)toggleFooter:(BOOL)show
{
    if(show)
    {
        [UIView animateWithDuration:ANIMATION_DURATION animations:^
         {
             [self.tabBarView setBottom:self.view.height];
         }];
    }
    else
    {
        [UIView animateWithDuration:ANIMATION_DURATION animations:^
         {
             [self.tabBarView setTop:self.view.height];
         }];
    }
}

- (void)setSelectedUser:(User *)selectedUser
{
    _selectedUser = selectedUser;
    
    if([self isTopViewController:BOARD_VIEW_CONTROLLER])
        [self.navBarView setUser:selectedUser];
}

- (CGSize)getSizeForController:(PSViewController *)controller
{
    CGSize controllerSize = CGSizeMake(self.view.width, self.view.height);
    
    if([controller showTabs])
    {
        controllerSize.height -= TAB_BAR_HEIGHT;
    }
    
    return controllerSize;
}

- (void)setAddMode:(BOOL)addMode
{
    _addMode = addMode;
    
    [self.topViewController setAddMode:addMode];
    
    [self.tabBarView setAddMode:addMode];
    
    [self.navBarView setAddMode:addMode];
    
    //[self setEditMode:NO];
}

- (void)setEditMode:(BOOL)editMode
{
    _editMode = editMode;
    
    [self.navBarView setEditMode:editMode];
    
    [self.topViewController setEditMode:editMode];
}

- (void)setCropMode:(BOOL)cropMode
{
    _cropMode = cropMode;
    
    [self setEditMode:NO];
    
    [self.cropView setHidden:!cropMode];
    
    if(cropMode)
    {
        //[self.navBarView updateForState:NavStateNone];
        [self.tabBarView setHidden:YES];
        [self.cropView setImageToCrop:[Article currentArticle].articleImage];
    }
    else
    {
        //[self.navBarView updateForState:NavStateArticleEdit];
        [self.tabBarView setHidden:NO];
    }
    
    [self.topViewController setCropMode:cropMode];
}

- (void)showProfile:(NSString *)userName
{
    ProfileViewController *pvc = [self.storyboard instantiateViewControllerWithIdentifier:PROFILE_VIEW_CONTROLLER];
    pvc.userName = userName;
    [self navigateToViewController:pvc animated:YES];
}

- (void)showArticle:(NSString *)articleID
{
    ArticleViewController *articleViewController = [self.storyboard instantiateViewControllerWithIdentifier:ARTICLE_VIEW_CONTROLLER];
    articleViewController.articleID = articleID;
    [self navigateToViewController:articleViewController animated:YES];
}

- (void)showBoard:(NSString *)userName
{
    BoardViewController *bvc = [self.storyboard instantiateViewControllerWithIdentifier:BOARD_VIEW_CONTROLLER];
    bvc.userName = userName;
    [self navigateToViewController:bvc animated:YES];
}

- (void)activateTabBar:(BOOL)active
{
    [self.tabBarView setActive:active];
}

// hide status bar
- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark -
#pragma mark Helper Methods
- (BOOL)isTopViewController:(NSString *)identifier
{
	NSString *currentIdentifier = [Utils getIdentifierForController:self.topViewController];
	
	return [currentIdentifier isEqualToString:identifier];
}

- (PSViewController *)topViewController
{
    return [self.childViewControllers lastObject];
}

- (PSViewController *)secondTopViewController
{
    if(self.childViewControllers.count < 2)
        return nil;
    
    return self.childViewControllers[(self.childViewControllers.count - 2)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)zoomInToViewController:(PSViewController *)newController
{
    PSViewController *currentController = (PSViewController *)self.topViewController;
    
    [self addChildViewController:newController];
    
    [self.contentHolderView addSubview:newController.view];
    
    newController.view.left = 0;
    
    newController.view.size = [self getSizeForController:newController];
    
    newController.view.alpha = 0;
    
    [self toggleHeader:NO];
    [self toggleFooter:NO];
    
    [UIView animateWithDuration:ANIMATION_DURATION delay:0.5 options:0 animations:^
     {
         newController.view.left = 0;
         newController.view.alpha = 1.0;
     }
    completion:^(BOOL finished)
     {
         [newController didMoveToParentViewController:self];
         
         [currentController performSelector:@selector(moveForwardIfReady) withObject:nil afterDelay:1.0];
         [newController performSelector:@selector(moveForwardIfReady) withObject:nil afterDelay:1.0];
     }];
}

- (void)zoomOut
{
    [self prepareForNavigationToController:self.secondTopViewController];
    
    PSViewController *viewControllerToRemove = self.topViewController;
    [viewControllerToRemove willMoveToParentViewController:nil];
    
    [UIView animateWithDuration:ANIMATION_DURATION animations:^
     {
         viewControllerToRemove.view.alpha = 0.0;
         //self.secondTopViewController.view.left = 0;
     }
    completion:^(BOOL finished)
     {
         [viewControllerToRemove willMoveToParentViewController:nil];
         [viewControllerToRemove removeFromParentViewController];
         [viewControllerToRemove.view removeFromSuperview];
         
         if(finished)
         {
             [self.topViewController didMoveToParentViewController:self];
             
             [self updateNavigationForController:self.topViewController];
         }
     }];
    
    NSLog(@"ViewController %@ Removed :: Child Views: %lu", viewControllerToRemove, (unsigned long)[self.childViewControllers count]);
}

- (void)tabToViewControllerWithIdentifier:(NSString *)identifier
{
    PSViewController *dest = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
    
    [self tabToViewController:dest];
}

- (void)tabToViewController:(PSViewController *)newController
{
    // ensure loading screen is hidden
    [self hideSpinner];
    
    // returns in case the old and the new controller are the same
   // if([self isTopViewController:NSStringFromClass([newController class])])
     //   return;
    
    PSViewController *currentController = (PSViewController *)self.topViewController;
    
    [self prepareForNavigationToController:newController];
    
    [self addChildViewController:newController];
    
    [self.contentHolderView addSubview:newController.view];
    
    [newController didMoveToParentViewController:self];
    
    newController.view.left = 0;
    
    newController.view.size = [self getSizeForController:newController];
    
    [currentController.view removeFromSuperview];
    
    [self updateNavigationForController:newController];
}

- (void)navigateToViewControllerWithIdentifier:(NSString *)identifier animated:(BOOL)animated
{
    PSViewController *dest = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
    
    [self navigateToViewController:dest animated:animated];
}

- (void)navigateToViewControllerWithIdentifier:(NSString *)identifier animated:(BOOL)animated completion:(void (^)(void))completion
{
    PSViewController *dest = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
    
    [self navigateToViewController:dest animated:animated completion:completion];
}

- (void)navigateToViewController:(PSViewController *)newController animated:(BOOL)animated
{
    [self navigateToViewController:newController animated:animated completion:NULL];
}

- (void)navigateToViewController:(PSViewController *)newController animated:(BOOL)animated completion:(void (^)(void))completion
{
    // ensure loading screen is hidden
    [self hideSpinner];
    
    // returns in case the old and the new controller are the same
    if([self isTopViewController:NSStringFromClass([newController class])])
        return;
    
    PSViewController *currentController = (PSViewController *)self.topViewController;
    
    [self addChildViewController:newController];
    
    [self.contentHolderView addSubview:newController.view];
    
    [newController didMoveToParentViewController:self];
    
    newController.view.left = APP_WIDTH;
    
    newController.view.size = [self getSizeForController:newController];
    
    float duration = (animated ? ANIMATION_DURATION : 0.0);
    
    [self prepareForNavigationToController:newController];
    
    [UIView animateWithDuration:duration animations:^
    {
        currentController.view.right = 0;
        newController.view.left = 0;
    }
    completion:^(BOOL finished)
    {
        //[currentController.view removeFromSuperview];
        
        if(completion)
            completion();
    }];
    
    [self updateNavigationForController:newController];
    
    NSLog(@"ViewController %@ Added on top of %@ :: Child Views: %lu", newController, currentController, (unsigned long)[self.childViewControllers count]);
}

- (void)showModalViewController:(PSViewController *)controller
{
    // ensure loading screen is hidden
    [self hideSpinner];
    
    [self addChildViewController:controller];
    
    [self.contentHolderView addSubview:controller.view];
    
    controller.view.top = APP_HEIGHT;
    
    controller.view.size = [self getSizeForController:controller];
    
    [self prepareForNavigationToController:controller];

    [UIView animateWithDuration:ANIMATION_DURATION animations:^
     {
         controller.view.top = ([controller showNav] ? NAV_BAR_HEIGHT : 0);
     }
    completion:^(BOOL finished)
     {
         [controller didMoveToParentViewController:self];
     }];
    
    [self updateNavigationForController:controller];
}

- (void)hideModalViewController:(PSViewController *)controller
{
    [self prepareForNavigationToController:self.secondTopViewController];
    
    [UIView animateWithDuration:ANIMATION_DURATION animations:^
    {
        controller.view.top = APP_HEIGHT;
    }
     completion:^(BOOL finished)
    {
        [controller removeFromParentViewController];
        [controller.view removeFromSuperview];
        
        
        [self.topViewController didMoveToParentViewController:self];
        [self updateNavigationForController:self.topViewController];
    }];
}

- (void)popViewController
{
    // ensure loading screen is hidden
    [self hideSpinner];
    
    [self prepareForNavigationToController:self.secondTopViewController];
    
    PSViewController *viewControllerToRemove = self.topViewController;
    [viewControllerToRemove willMoveToParentViewController:nil];
    
    [UIView animateWithDuration:ANIMATION_DURATION animations:^
    {
        viewControllerToRemove.view.left = APP_WIDTH;
        self.secondTopViewController.view.left = 0;
    }
    completion:^(BOOL finished)
     {
        [viewControllerToRemove willMoveToParentViewController:nil];
        [viewControllerToRemove.view removeFromSuperview];
        [viewControllerToRemove removeFromParentViewController];
        
        if(finished)
        {
            [self.topViewController didMoveToParentViewController:self];
            
            [self updateNavigationForController:self.topViewController];
        }
    }];
    
    NSLog(@"ViewController %@ Removed :: Child Views: %lu", viewControllerToRemove, (unsigned long)[self.childViewControllers count]);
}

- (void)popViewController:(PSViewController *)controller
{
    [controller willMoveToParentViewController:nil];
    [controller removeFromParentViewController];
    [controller.view removeFromSuperview];
    
    NSLog(@"ViewController %@ Removed :: Child Views: %lu", controller, (unsigned long)[self.childViewControllers count]);
}

- (void)popToViewControllerWithIdentifier:(NSString *)identifier
{
   // [self.contentHolderView setFrame:CGRectMake(0, 0, APP_WIDTH, APP_HEIGHT)];
    
    // ensure loading screen is hidden
    [self hideSpinner];
    
    // returns in case the old and the new controller are the same
    if([self isTopViewController:identifier])
        return;
    
    for(PSViewController *controller in self.childViewControllers.reverseObjectEnumerator)
    {
        if([[Utils getIdentifierForController:controller] isEqualToString:identifier])
            break;
        
        [self popViewController:controller];
    }
    
    
    if(!self.topViewController)
    {
        [self navigateToViewControllerWithIdentifier:INTRO_VIEW_CONTROLLER animated:YES];
    }
    else
    {
        [self prepareForNavigationToController:self.topViewController];
        
        [self.contentHolderView addSubview:self.topViewController.view];
    
        [self.topViewController.view setRight:0];
        
        [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionOverrideInheritedDuration animations:^
         {
             self.topViewController.view.left = 0;
         }
        completion:^(BOOL finished)
         {
             [self.topViewController didMoveToParentViewController:self];
             
             [self updateNavigationForController:self.topViewController];
         }];
    }
}

- (void)prepareForNavigationToController:(PSViewController *)controller
{
    NavState navState = controller.view.tag;
    
    [self.navBarView setTitle:controller.title forState:navState];
    
    [self.navBarView.titleView.avatarView setAvatarURL:nil];
}

- (void)updateNavigationForController:(PSViewController *)controller
{
    [self toggleHeader:[controller showNav]];
    
    [self toggleFooter:[controller showTabs]];
    
    //newController.view.size = self.contentHolderView.size;
    
   // self.navBarView.titleView.titleLabel.text = [controller title];
}

- (void)showSpinnerForType:(SpinnerType)type
{
    [self.spinnerView showSpinnerForType:type];
}

- (void)hideSpinner
{
    [self.spinnerView hideSpinner];
}

- (void)logout
{
    [[DataManager sharedInstance] userLoggedOut];
    
    [self popToViewControllerWithIdentifier:LOGIN_VIEW_CONTROLLER];
}

/*
- (void)handleButton:(id)sender
{
    [self.customAlert dismiss];
    self.navigationItem.rightBarButtonItem.enabled = YES;
}*/

- (IBAction)showFriends:(id)sender
{
    
}

- (void)showActivityScreenForArticle:(Article *)article
{
    NSURL *imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PEGGSITE_IMAGE_URL, article.source]];
    
    ReportActivity *activity = [[ReportActivity alloc] init];
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[imageURL] applicationActivities:@[activity]];
    activityViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    activityViewController.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll, UIActivityTypeAddToReadingList];
    [self presentViewController:activityViewController animated:YES completion:^
     {
         
     }];
}

- (void)showActivityScreenForFriend:(Friend *)friend
{
    NSURL *friendURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%li/%@", PEGGSITE_API_URL, (long)[Friend currentFriend].userID, [Friend currentFriend].avatarName]];
    
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[friendURL] applicationActivities:nil];
    activityViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    [self presentViewController:activityViewController animated:YES completion:^
     {
         
     }];
}

- (void)showFriendActionSheet
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Report Inappropriate" otherButtonTitles:@"Copy Profile URL", nil];
    actionSheet.tag = FRIEND_ACTION_SHEET_TAG;
    [actionSheet showFromRect:self.tabBarView.frame inView:self.view animated:YES];
}

#pragma mark - Image Handling
- (void)selectPhoto
{
    BOOL cameraAvailable = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    BOOL photoAvailable = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary];
    
    if(cameraAvailable && photoAvailable)
    {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo", @"Choose Existing", nil];
        [actionSheet showInView:self.view];
    }
    else
    {
        [self shouldPresentPhotoCaptureController];
    }
}

- (BOOL)shouldPresentPhotoCaptureController
{
    BOOL presentedPhotoCaptureController = [self shouldStartCameraController];
    
    if(!presentedPhotoCaptureController)
    {
        presentedPhotoCaptureController = [self shouldStartPhotoLibraryPickerController];
    }
    
    return presentedPhotoCaptureController;
}

- (BOOL)shouldStartCameraController
{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO)
        return NO;
    
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] && [[UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera] containsObject:@"public.image"])
    {
        cameraUI.mediaTypes = @[@"public.image"];
        cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        if([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront])
        {
            cameraUI.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        }
        else if([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear])
        {
            cameraUI.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        }
    }
    else
    {
        return NO;
    }
    
    cameraUI.allowsEditing = YES;
    cameraUI.showsCameraControls = YES;
    cameraUI.delegate = self;
    
    [self presentViewController:cameraUI animated:YES completion:^
     {
         
     }];
    
    return YES;
}

- (BOOL)shouldStartPhotoLibraryPickerController
{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary] == NO && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum] == NO)
    {
        return NO;
    }
    
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary] && [[UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary] containsObject:@"public.image"])
    {
        cameraUI.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        cameraUI.mediaTypes = @[@"public.image"];
    }
    else if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum] && [[UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum] containsObject:@"public.image"])
    {
        cameraUI.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        cameraUI.mediaTypes = @[@"public.image"];
    }
    else
    {
        return NO;
    }
    
    cameraUI.allowsEditing = YES;
    cameraUI.delegate = self;
    
    [self presentViewController:cameraUI animated:YES completion:^
     {
         
     }];
    
    return YES;
}

#pragma mark -
#pragma mark UIActionSheet Delegate Methods
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(actionSheet.tag == FRIEND_ACTION_SHEET_TAG)
    {
        switch (buttonIndex)
        {
            case 0:
            {
                NSString *body = [NSString stringWithFormat:(NSLocalizedString(@"EmailReportContentBody", nil)), [Friend currentFriend].userName];
                
                [[ShareManager sharedInstance] sendEmail:PEGGSITE_HELP_EMAIL emailSubject:STRING_EMAIL_REPORT_CONTENT_SUBJECT emailBody:body fromController:self.topViewController];
            }
                break;
                
            case 1:
            {
                NSString *profileURL = [NSString stringWithFormat:@"%@%@", PEGGSITE_URL, [Friend currentFriend].userName];
                [[UIPasteboard generalPasteboard] setString:profileURL];
            }
                break;
                
            default:
                break;
        }
    }
    else
    {
        switch (buttonIndex)
        {
            case 0:
            {
                [self shouldPresentPhotoCaptureController];
            }
                break;
                
            case 1:
            {
                [self shouldStartPhotoLibraryPickerController];
            }
                break;
                
            default:
                break;
        }
    }
}

#pragma mark - UIImagePickerController delegate methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"IMAGE METADATA: %@", info);
    
    UIImage *originalImage = (UIImage *)info[UIImagePickerControllerOriginalImage];
    UIImage *editedImage = (UIImage *)info[UIImagePickerControllerEditedImage];
    UIImage *rotatedImage;
    
    if(originalImage)
    {
        NSLog(@"Image orientation: %ld, size: %@", (long)originalImage.imageOrientation, NSStringFromCGSize(originalImage.size));
        
        switch (originalImage.imageOrientation)
        {
            case UIImageOrientationDown:
            case UIImageOrientationDownMirrored:
            case UIImageOrientationUp:
            case UIImageOrientationUpMirrored:
                rotatedImage = (editedImage ? editedImage : originalImage);
                break;
                
            case UIImageOrientationLeft:
            case UIImageOrientationLeftMirrored:
                rotatedImage = [Utils rotateImage:(editedImage ? editedImage : originalImage) byRadians:-M_PI_2];
                break;
                
            case UIImageOrientationRight:
            case UIImageOrientationRightMirrored:
                rotatedImage = [Utils rotateImage:(editedImage ? editedImage : originalImage) byRadians:M_PI_2];
                break;
                
            default:
                break;
        }
    }
    
    [self.topViewController setImageSelected:rotatedImage];
    
    [picker dismissViewControllerAnimated:YES completion:^
     {
        /* if([self.topViewController showNav])
         {
             [self.contentHolderView setFrame:CGRectMake(0, NAV_BAR_HEIGHT, APP_WIDTH, APP_HEIGHT - NAV_BAR_HEIGHT)];
             
         }
         else
         {
             [self.contentHolderView setFrame:CGRectMake(0, 0, APP_WIDTH, APP_HEIGHT)];
         }*/
     }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^
     {
       /*  if([self.topViewController showNav])
         {
             [self.contentHolderView setFrame:CGRectMake(0, NAV_BAR_HEIGHT, APP_WIDTH, APP_HEIGHT - NAV_BAR_HEIGHT)];
             
         }
         else
         {
             [self.contentHolderView setFrame:CGRectMake(0, 0, APP_WIDTH, APP_HEIGHT)];
         }*/
     }];
}

#pragma mark - CropViewDelegate
- (void)cropView:(CropView *)cropView didRequestSaveNewImage:(UIImage *)image
{
    [[DataManager sharedInstance] uploadImage:image toRegionNumber:[Article currentArticle].regionNumber delegate:self];
    
    [self setCropMode:NO];
    
    [self.cropView reset];
}

- (void)cropViewDidRequestCancelEditing:(CropView *)cropView
{
    [Article setCurrentArticle:nil];
    [self setCropMode:NO];
}

#pragma mark - NavBarViewDelegate
- (void)navBarViewDidRequestShowProfile:(NavBarView *)navBarView
{
    ProfileViewController *pvc = [self.storyboard instantiateViewControllerWithIdentifier:PROFILE_VIEW_CONTROLLER];
    
    BoardViewController *bvc = (BoardViewController *)self.topViewController;
    pvc.userName = bvc.userName;
    
    [bvc setAddMode:NO];
    
    [self navigateToViewController:pvc animated:YES completion:^
    {
        [self setAddMode:NO];
    }];
}

#pragma mark - DataManagerDelegate
- (void)dataManager:(DataManager *)dataManager didReturnData:(id)data
{
    switch (dataManager.requestType)
    {
        case RequestTypeUpload:
        {
            NSLog(@"Image Saved %@", data);
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - NavBarActions
- (IBAction)navButtonSelected:(id)sender
{
    NSInteger btnIndex = [(UIButton *)sender tag];
    
    // [self.contentHolderView setFrame:CGRectMake(0, NAV_BAR_HEIGHT, APP_WIDTH, APP_HEIGHT - NAV_BAR_HEIGHT)];
    
    switch (btnIndex)
    {
        case NavButtonStateCancel:
        {
            if([self isTopViewController:EDIT_PROFILE_VIEW_CONTROLLER])
            {
                [self hideModalViewController:self.topViewController];
            }
        }
            break;
            
        case NavButtonStateBack:
        case NavButtonStateShortBack:
            [self popViewController];
            break;
            
        case NavButtonStatePanel:
        case NavButtonStateShowDetail:
            //[self showActivityScreenForFriend:[Friend currentFriend]];
            [self showFriendActionSheet];
            NSLog(@"Panel");
            break;
            
        case NavButtonStateHeart:
            [self navigateToViewControllerWithIdentifier:LOVE_VIEW_CONTROLLER animated:YES];
            break;
            
        case NavButtonStateSettings:
            [self navigateToViewControllerWithIdentifier:SETTINGS_VIEW_CONTROLLER animated:YES];
            break;
            
        case NavButtonStateRefresh:
            [self.topViewController refresh];
            break;
            
        case NavButtonStateLogout:
            
            break;
            
            //  case NavButtonStateAddFriend:
            //    [self navigateToViewControllerWithIdentifier:ADD_FRIEND_VIEW_CONTROLLER animated:YES];
            //  break;
            
        case NavButtonStateEdit:
           // [self.navBarView updateForState:NavStateArticleEdit];
            [self setEditMode:YES];
            break;
            
        case NavButtonStateDone:
           // [self.navBarView updateForState:NavStateBoard];
//            [self.topViewController setEditMode:NO];
            [self setEditMode:NO];
            break;
            
        case NavButtonStateSave:
        case NavButtonStateForward:
            [self.topViewController moveForwardIfReady];
            break;
            
        default:
            break;
    }
}

#pragma mark - SegmentBarViewDelegate
- (void)tabBarView:(TabBarView *)tabBarView didSelectIndex:(NSInteger)index
{
    if(self.selectedTab == index && (![self isTopViewController:BOARD_VIEW_CONTROLLER]))
       [self popToViewControllerWithIdentifier:HOME_VIEW_CONTROLLER];
    
    switch (index)
    {
        case TabButtonStateNone:
            break;
            
        case TabButtonStateHome:
            [self tabToViewControllerWithIdentifier:HOME_VIEW_CONTROLLER];
            break;
            
        case TabButtonStateActivity:
            [self tabToViewControllerWithIdentifier:ACTIVITY_VIEW_CONTROLLER];
            break;
            
        case TabButtonStateProfile:
        {
            [Region setCurrentRegion:nil];
            
            [self setAddMode:NO];
            
            BoardViewController *bvc = [self.storyboard instantiateViewControllerWithIdentifier:BOARD_VIEW_CONTROLLER];
            bvc.userName = [User currentUser].userName;
            [self tabToViewController:bvc];
            //ProfileViewController *pvc = [self.storyboard instantiateViewControllerWithIdentifier:PROFILE_VIEW_CONTROLLER];
            //pvc.userName = [User currentUser].userName;
            //[self tabToViewController:pvc];
        }
            break;
            
        case TabButtonStateAdd:
        {
            if([self isTopViewController:BOARD_VIEW_CONTROLLER])
            {
                BoardViewController *bvc = (BoardViewController *)self.topViewController;
                
                if([User isCurrentUser:bvc.userName])
                {
                    [self setAddMode:!self.addMode];
                    
                    return;
                }
            }
            
            BoardViewController *bvc = [self.storyboard instantiateViewControllerWithIdentifier:BOARD_VIEW_CONTROLLER];
            bvc.userName = [User currentUser].userName;
            [self tabToViewController:bvc];
            [self setAddMode:YES];
        }
            break;
            
        case TabButtonStateMore:
            [self tabToViewControllerWithIdentifier:MORE_VIEW_CONTROLLER];
            break;
            
        default:
            break;
    }
    
    _selectedTab = index;
}

@end
