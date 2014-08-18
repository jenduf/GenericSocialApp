//
//  PSNavController.h
//  PeggSite
//
//  Created by Jennifer Duffey on 3/5/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PSViewController;
@interface PSNavController : UIViewController

@property (nonatomic, weak) IBOutlet UIView *contentHolderView;
@property (nonatomic, assign) BOOL cropMode, addMode, editMode;
@property (nonatomic, strong) User *selectedUser;

- (void)selectPhoto;
- (void)zoomInToViewController:(PSViewController *)newController;
- (void)zoomOut;
- (void)tabToViewController:(PSViewController *)newController;
- (void)navigateToViewControllerWithIdentifier:(NSString *)identifier animated:(BOOL)animated;
- (void)navigateToViewControllerWithIdentifier:(NSString *)identifier animated:(BOOL)animated completion:(void (^)(void))completion;
- (void)navigateToViewController:(PSViewController *)newController animated:(BOOL)animated;
- (void)navigateToViewController:(PSViewController *)newController animated:(BOOL)animated completion:(void (^)(void))completion;
- (void)showModalViewController:(PSViewController *)controller;
- (void)hideModalViewController:(PSViewController *)controller;
- (void)popViewController;
- (void)showSpinnerForType:(SpinnerType)type;
- (void)hideSpinner;
- (void)showActivityScreenForArticle:(Article *)article;
- (void)logout;
- (void)showProfile:(NSString *)userName;
- (void)showArticle:(NSString *)articleID;
- (void)showBoard:(NSString *)userName;
- (void)activateTabBar:(BOOL)active;
- (void)toggleHeader:(BOOL)show;
- (void)toggleFooter:(BOOL)show;

@end
