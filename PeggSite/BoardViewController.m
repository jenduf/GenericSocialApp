//
//  ArticleViewController.m
//  PeggSite
//
//  Created by Jennifer Duffey on 3/4/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import "BoardViewController.h"
#import "NSDate+PSFoundation.h"
#import "FullScreenViewController.h"
#import "PageControlView.h"
#import "ArticleView.h"
#import "MediaContentView.h"
#import "PageControlView.h"
#import "ColorButton.h"
#import "Comment.h"
#import "Love.h"
#import "Region.h"
#import "PeggTextView.h"
#import "Activity.h"
#import "ArticleViewController.h"
#import "AddViewController.h"
#import "BoardScrollView.h"

@interface BoardViewController ()
<ArticleViewDelegate, UIAlertViewDelegate, MediaContentViewDelegate, BoardScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *allRegions;
@property (nonatomic, strong) ArticleView *currentArticleView;
@property (nonatomic, weak) IBOutlet UIView *addButtonView;
@property (nonatomic, weak) IBOutlet UIToolbar *editToolbar;
@property (nonatomic, weak) IBOutlet PeggTextView *articleTextView;
@property (nonatomic, weak) IBOutlet UIView *textContentView;
@property (nonatomic, weak) IBOutlet BoardScrollView *boardScrollView;
@property (nonatomic, weak) IBOutlet PageControlView *pageControlView;
@property (nonatomic, assign) BOOL showDetails, addingContent;
@property (nonatomic, strong) MediaContentView *selectedMediaContentView;
@property (nonatomic, assign) CGRect mediaFrame;
@property (nonatomic, strong) User *selectedUser;
@property (nonatomic, assign) BOOL firstLoad;
@property (nonatomic, strong) NSMutableArray *articlesToUpdate;
@property (nonatomic, strong) UIImageView *animatingView;

- (IBAction)addContent:(id)sender;

@end

@implementation BoardViewController

- (void)animateView
{
    if(self.animatingView)
    {
        [UIView animateWithDuration:0.3 animations:^
        {
            [self.animatingView setFrame:self.mediaFrame];
        }
        completion:^(BOOL finished)
         {
             [self.animatingView removeFromSuperview];
             self.animatingView = nil;
         }];
    }
    
    if(![Region currentRegion])
        self.addingContent = NO;
    
    [self loadCurrentUser];
}

- (void)moveForwardIfReady
{
   // [self.animatingView removeFromSuperview];
    
   // self.animatingView = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.articlesToUpdate = [[NSMutableArray alloc] init];
    
    self.firstLoad = YES;
    
    [self.pageControlView setPageCount:SCROLL_PAGE_COUNT];
    
    self.shouldHideLoader = YES;
}

- (void)setEditMode:(BOOL)editMode
{
    [super setEditMode:editMode];
    
    [self.boardScrollView setEditMode:editMode];
}

- (void)setAddMode:(BOOL)addMode
{
    [super setAddMode:addMode];
    
    if(self.selectedUser)
    {
        [self animateAddMode];
    }
}

- (void)animateAddMode
{
    if(self.addMode)
    {
        
        Region *emptyRegion = [self.boardScrollView getAvailableRegion];
        
        if(!emptyRegion)
        {
            UIAlertView *alert = [Utils createAlertWithPrefix:STRING_BOARD_FULL_PREFIX customMessage:nil showOther:NO andDelegate:nil];
            [alert show];
            
            [self.navController setAddMode:NO];
        }
        else
        {
            [Region setCurrentRegion:emptyRegion];
            
            [UIView animateWithDuration:0.3 animations:^
             {
                 [self.addButtonView centerHorizontallyInSuperView];
                 
                 [self.boardScrollView setLeft:(self.view.width - PADDING_RIGHT)];
                 [self.pageControlView setLeft:APP_WIDTH];
             }
            completion:^(BOOL finished)
             {
                 [self.boardScrollView scrollToRegionNumber:1 animated:NO];
             }];
        }
    }
    else
    {
        if(!self.addingContent)
        {
            [Region setCurrentRegion:nil];
        }
        
        [UIView animateWithDuration:0.3 animations:^
         {
             [self.addButtonView setRight:0];
             [self.boardScrollView setLeft:0];
             [self.pageControlView setLeft:PAGE_CONTROL_LEFT];
         }
        completion:^(BOOL finished)
         {
             
         }];
    }
}

- (void)setCropMode:(BOOL)cropMode
{
    [super setCropMode:cropMode];
    
    //[self.selectedMediaContentView setEditMode:!cropMode];
    
    //[self loadCurrentUser];
}

- (void)loadCurrentUser
{
    [[DataManager sharedInstance] getUser:self.userName delegate:self];
}

- (void)refreshBoard
{
    if(!self.allRegions)
         self.allRegions = [[NSMutableArray alloc] init];
    
    [self.allRegions removeAllObjects];
    
    [[LayoutManager sharedInstance] getRegionsForUser:self.selectedUser withCompletionBlock:^(NSArray *regions, NSError *error)
     {
         for(Region *region in regions)
         {
             for(Article *article in self.selectedUser.articles)
             {
                 if(![User isCurrentUser:self.selectedUser.userName])
                 {
                     Friend *friend = (Friend *)[[User currentUser] getFriendByID:self.selectedUser.userID];
                     if([article.dateAdded isAfter:friend.dateVisited])
                     {
                         article.isNew = YES;
                     }
                 }
                 
                 if(article.regionNumber == region.regionNumber)
                 {
                     region.article = article;
                     break;
                 }
                 
                 region.article = nil;
             }
             
             [self.allRegions addObject:region];
         }
         
         [self.boardScrollView addPlaceholdersForRegions:self.allRegions];
         
         if(self.addMode)
            [self animateAddMode];
         
         [self.navController setEditMode:self.editMode];
         
         if(!self.addMode)
         {
             if([Region currentRegion])
             {
                 [self.boardScrollView scrollToRegionNumber:[Region currentRegion].regionNumber animated:YES];
                 
                 [Region setCurrentRegion:nil];
                 
                 self.addingContent = NO;
             }
             else
             {
                 if(self.firstLoad)
                 {
                     Region *region = (Region *)[self.boardScrollView getOccupiedRegion];
                     if(region)
                     {
                         [self.boardScrollView scrollToRegionNumber:region.regionNumber animated:YES];
                     }
                     
                     self.firstLoad = NO;
                 }
             }
         }
     }];
}

- (IBAction)addContent:(id)sender
{
    //for(ColorButton *btn in self.addButtonView.subviews)
    //{
      //  [btn setSelected:NO];
    //}
    
    self.addingContent = YES;
    
    [self setAddMode:NO];
    
    ColorButton *button = (ColorButton *)sender;
   // [button setSelected:YES];
    
    
    AddContentType type = button.tag;
    
    if(type == AddContentTypePhoto)
    {
        [self.navController navigateToViewControllerWithIdentifier:ADD_PHOTO_VIEW_CONTROLLER animated:YES completion:^
        {
            [self.navController setAddMode:NO];
        }];
    }
    else
    {
        AddViewController *avc = (AddViewController *)[self.storyboard instantiateViewControllerWithIdentifier:ADD_VIEW_CONTROLLER];
        avc.contentType = type;
    
        [self.navController navigateToViewController:avc animated:YES completion:^
        {
            [self.navController setAddMode:NO];
        }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - BoardScrollView Methods
- (void)boardScrollView:(BoardScrollView *)boardScrollView didRequestViewMedia:(MediaContentView *)mediaContentView
{
    [Article setCurrentArticle:mediaContentView.article];
    
    // future animation
 
    // add the image
    CGPoint newPoint = [self.boardScrollView convertPoint:mediaContentView.origin toView:self.view];
    float newHeight = (mediaContentView.height <= SMALL_ARTICLE_SIZE ? MEDIA_HEIGHT_SMALL : MEDIA_HEIGHT_LARGE);
    
    self.animatingView = [[UIImageView alloc] initWithImage:mediaContentView.mediaImageView.image];
    self.animatingView.contentMode = UIViewContentModeScaleAspectFill;
    
    [self.view addSubview:self.animatingView];
    
    self.mediaFrame = CGRectMake(newPoint.x, newPoint.y, mediaContentView.width, mediaContentView.height);
    
    [self.animatingView setFrame:self.mediaFrame];
    
    // start the zoom
    ArticleViewController *avc = [self.storyboard instantiateViewControllerWithIdentifier:ARTICLE_VIEW_CONTROLLER];
    avc.article = mediaContentView.article;
    avc.postType = (mediaContentView.height <= SMALL_ARTICLE_SIZE ? PostTypeSmall : PostTypeLarge);
  //  [self.navController navigateToViewController:avc animated:YES];
    
    
    [self.navController zoomInToViewController:avc];
    
    [UIView animateWithDuration:0.5 animations:^
    {
        [self.animatingView setFrame:CGRectMake(0, 0, self.view.width, newHeight)];
    }
    completion:^(BOOL finished)
    {
       // [self.navController navigateToViewController:avc animated:YES completion:^
       // {
        
       // }];
    }];
}

- (void)boardScrollView:(BoardScrollView *)boardScrollView didRequestCropMedia:(MediaContentView *)mediaContentView
{
    [Article setCurrentArticle:mediaContentView.article];
    
    [self.navController setCropMode:YES];
}

- (void)boardScrollView:(BoardScrollView *)boardScrollView didRequestDeleteArticle:(Article *)article
{
    [Article setCurrentArticle:article];
    
    UIAlertView *alert = [Utils createAlertWithPrefix:STRING_DELETE_WARNING_PREFIX customMessage:nil showOther:YES andDelegate:self];
    alert.tag = ALERT_TAG_DELETE;
    [alert show];
}

- (void)boardScrollView:(BoardScrollView *)boardScrollView didRequestUpdateArticle:(Article *)article
{
    [[DataManager sharedInstance] updateArticle:article delegate:self];
}

- (void)boardScrollView:(BoardScrollView *)boardScrollView didRequestUpdateArticles:(NSArray *)articles
{
    [[DataManager sharedInstance] updateArticle:articles[0] delegate:self];
    [self.articlesToUpdate addObject:articles[1]];
}

- (void)boardScrollView:(BoardScrollView *)boardScrollView didRequestEditArticle:(Article *)article
{
    [self.navController setEditMode:NO];
    
    AddViewController *avc = (AddViewController *)[self.storyboard instantiateViewControllerWithIdentifier:ADD_VIEW_CONTROLLER];
    avc.contentType = AddContentTypeText;
    avc.article = article;
    [self.navController showModalViewController:avc];
}

- (void)boardScrollView:(BoardScrollView *)boardScrollView didChangePage:(NSInteger)pageIndex
{
    [self.pageControlView setIndexSelected:pageIndex];
}

#pragma mark - UIAlertViewDelegate Methods
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == ALERT_TAG_DELETE)
    {
        if(buttonIndex > 0)
        {
            [[DataManager sharedInstance] deleteArticle:[Article currentArticle].articleID delegate:self];
        }
    }
}

#pragma mark - DataManagerDelegate
- (void)dataManager:(DataManager *)dataManager didReturnData:(id)data
{
    switch (dataManager.requestType)
    {
        case RequestTypeGetUser:
        {
            NSDictionary *dict = (NSDictionary *)data;
            
            self.selectedUser = [[User alloc] initWithDictionary:dict];
            
            [self.navController setSelectedUser:self.selectedUser];
            
            [self refreshBoard];
        }
            break;
            
        case RequestTypeUpload:
        {
            NSLog(@"Image Uploaded %@", data);
        }
            break;
            
        case RequestTypeGetActivity:
        {
            NSArray *arr = (NSArray *)data;
            
            NSArray *activityArray = arr[1];
            
            NSMutableArray *allActivities = [NSMutableArray array];
            
            for(NSDictionary *dict in activityArray)
            {
                Activity *activity = [[Activity alloc] initWithDictionary:dict];
                [allActivities addObject:activity];
            }
            
           // Region *region = self.currentArticleView.region;
           // region.article.activities = [[NSArray alloc] initWithArray:allActivities];
            
           // [self.currentArticleView setRegion:region];
            
           // if(self.showDetails)
             //   [self.currentArticleView slideUp];
            
        }
            break;
            
        case RequestTypeGetArticle:
        {
            ///////// FIX TO EVENTUALLY REPLACE ARTICLE IN CURRENT DATA SOURCE
           // NSDictionary *dict = (NSDictionary *)data;
           // Article *article = [[Article alloc] initWithDictionary:dict];
            //[self.currentArticleView setArticle:article];
        }
            break;
            
     /*   case RequestTypeCreateArticle:
        {
            NSDictionary *dict = (NSDictionary *)data;
            Article *article = [[Article alloc] initWithDictionary:dict];
          //  Region *region = self.currentArticleView.region;
          //  region.article = article;
          //  [self.currentArticleView setRegion:region];
        }
            break;
            */
        case RequestTypePostComment:
        {
            UIAlertView *alert = [Utils createAlertWithPrefix:STRING_CONTENT_POSTED_PREFIX customMessage:nil showOther:NO andDelegate:self];
            [alert show];
        }
            break;
            
        case RequestTypeUpdateArticle:
        {
            if(self.articlesToUpdate.count > 0)
            {
                [[DataManager sharedInstance] updateArticle:self.articlesToUpdate[0] delegate:self];
                [self.articlesToUpdate removeAllObjects];
            }
            else
            {
                [self loadCurrentUser];
            }
            
            NSLog(@"Article updated");
        }
            break;
            
        case RequestTypePostLove:
        {
         //   [self getActivityAndShowDetails:NO];
        }
            break;
            
        case RequestTypeDeleteLove:
        {
           // [self getActivityAndShowDetails:NO];
        }
            break;
            
        case RequestTypeDeleteArticle:
        {
            [self loadCurrentUser];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - Nav Bar Visibility
- (BOOL)showNav
{
    return YES;
}

#pragma mark - Tab Bar Visibility
- (BOOL)showTabs
{
    return YES;
}

#pragma mark - Spinner Type For View
- (SpinnerType)spinnerType
{
    return SpinnerTypeGray;
}

#pragma mark - Nav Bar Title
- (NSString *)title
{
    return self.userName;
}

@end
