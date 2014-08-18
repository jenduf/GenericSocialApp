//
//  ArticleViewController.m
//  PeggSite
//
//  Created by Jennifer Duffey on 5/27/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import "ArticleViewController.h"
#import "FullScreenViewController.h"
#import "MediaContentView.h"
#import "ArticleView.h"
#import "CommentsView.h"
#import "ColorButton.h"
#import "Activity.h"
#import "ShareView.h"
#import "MediaView.h"

@interface ArticleViewController ()
<ArticleViewDelegate, ShareViewDelegate, MediaContentViewDelegate>

@property (nonatomic, weak) IBOutlet UIScrollView *articleDetailScrollView;
@property (nonatomic, strong) ArticleView *articleView;
@property (nonatomic, strong) ShareView *shareView;
@property (nonatomic, strong) UITapGestureRecognizer *screenTapRecognizer;
@property (nonatomic, weak) IBOutlet MediaView *mediaView;
@property (nonatomic, weak) IBOutlet UIView *detailView;
@property (nonatomic, weak) IBOutlet UIToolbar *actionToolbar;
@property (nonatomic, weak) IBOutlet PeggLabel *captionLabel;
@property (nonatomic, weak) IBOutlet PeggButton *notesButton;
@property (nonatomic, weak) IBOutlet CommentsView *commentsView;
@property (nonatomic, weak) IBOutlet PeggTextField *commentTextField;
@property (nonatomic, weak) IBOutlet UIView *commentInputView;

- (IBAction)close:(id)sender;
- (IBAction)love:(id)sender;
- (IBAction)comment:(id)sender;
- (IBAction)share:(id)sender;

@end

@implementation ArticleViewController

- (void)animateView
{
    
}

- (void)moveForwardIfReady
{
    self.articleDetailScrollView.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // have to do this to make a clear background in a toolbar
    [[UIToolbar appearance] setBackgroundImage:[[UIImage alloc] init] forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    
    self.shouldHideLoader = YES;
    
    if(self.article)
        self.articleID = self.article.articleID;
    
    if(!self.article)
    {
        [self getArticle];
    }
    else
    {
        [self getActivity];
    }
}

- (void)prepareExit
{
    
}

- (void)shiftForKeyboard
{
    //[super shiftForKeyboard];
    
    [self.articleDetailScrollView setContentOffset:CGPointMake(0, self.articleDetailScrollView.height - COMMENT_OFFSET)];
}

- (void)postComment:(id)sender
{
    [[DataManager sharedInstance] postComment:self.commentTextField.text forArticleID:self.article.articleID delegate:self];
}

- (IBAction)love:(id)sender
{
    [self doubleTapped:nil];
}

- (IBAction)comment:(id)sender
{
    if(self.screenTapRecognizer)
    {
        [self.articleDetailScrollView removeGestureRecognizer:self.screenTapRecognizer];
        [self.shareView removeFromSuperview];
    }
    
    //[self.articleDetailScrollView setContentOffset:CGPointMake(0, KEYBOARD_HEIGHT + BORDER_PADDING)];
    [self.commentTextField becomeFirstResponder];
}

- (IBAction)share:(id)sender
{
    if(self.screenTapRecognizer)
    {
        [self.articleDetailScrollView removeGestureRecognizer:self.screenTapRecognizer];
        [self.shareView removeFromSuperview];
    }
    else
    {
        self.screenTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(screenTapped:)];
        [self.articleDetailScrollView addGestureRecognizer:self.screenTapRecognizer];
    }
    
    if(!self.shareView)
    {
        self.shareView = [[ShareView alloc] initWithFrame:CGRectMake(self.view.width - SHARE_WIDTH, self.view.height / 2 + self.articleDetailScrollView.contentOffset.y, SHARE_WIDTH, SHARE_HEIGHT)];
        self.shareView.delegate = self;
    }
    
    [self.articleDetailScrollView setContentOffset:CGPointMake(0, self.shareView.height)];
    
    [self.view addSubview:self.shareView];
}

- (IBAction)close:(id)sender
{
    [UIView animateWithDuration:0.3 animations:^
    {
        [self.detailView setTop:APP_HEIGHT];
    }
     completion:^(BOOL finished)
     {
         [self.navController zoomOut];
     }];
}

- (void)getArticle
{
    [[DataManager sharedInstance] getArticleWithID:self.articleID delegate:self];
}

- (void)getActivity
{
    [[DataManager sharedInstance] getActivityForArticleID:self.article.articleID delegate:self];
}

- (void)setUpArticle
{
    float nextY = 0;
    
    //UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, MEDIA_HEIGHT)];
   // topView.backgroundColor = [UIColor clearColor];
   // [self.articleDetailScrollView addSubview:topView];
    
    switch (self.article.articleTypeID)
    {
            /*
        case ArticleTypeImage:
        {
            float newHeight = self.postType == PostTypeSmall ? MEDIA_HEIGHT : MEDIA_HEIGHT_LARGE;
            
            CGRect scaledRect = [Utils getScaledSizeWithSourceSize:CGSizeMake(self.article.sourceWidth, self.article.sourceHeight) targetSize:CGSizeMake(self.view.width, newHeight) isLetterBox:NO];
            
            UIImageView *articleImageView = [[UIImageView alloc] initWithImage:self.article.articleImage];
            articleImageView.contentMode = UIViewContentModeScaleAspectFill;
            [articleImageView setFrame:scaledRect];
            UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapped:)];
            tapRecognizer.numberOfTapsRequired = 2;
            [articleImageView addGestureRecognizer:tapRecognizer];
            [topView addSubview:articleImageView];
            [topView sizeToFit];
            nextY = articleImageView.bottom;
        }
            break;
           
        case ArticleTypeText:
        {
            
            PeggTextField *tf = [[PeggTextField alloc] initWithFrame:CGRectMake(PADDING, PADDING, self.view.width, LABEL_HEIGHT)];
            tf.font = [UIFont fontWithName:FONT_PROXIMA_BOLD size:FONT_SIZE_BODY];
            tf.text = @"Title";
            [topView addSubview:tf];
            
            PeggTextView *textView = [[PeggTextView alloc] initWithFrame:CGRectMake(PADDING, tf.bottom + PADDING, self.view.width - (PADDING * 2), 0) andFontSize:FONT_SIZE_BODY];
            textView.font = [UIFont fontWithName:FONT_PROXIMA_REGULAR size:FONT_SIZE_BODY];
            textView.text = self.article.text;
            [topView addSubview:textView];
            [textView sizeToFit];
            nextY = textView.bottom;
             
            
        }
            break;*/
            
        case ArticleTypeText:
        case ArticleTypeYouTube:
        case ArticleTypeVimeo:
        case ArticleTypeSound:
        case ArticleTypeImage:
        {
          //  [topView addSubview:self.ytPlayer];
            
           // [self.ytPlayer setOrigin:CGPointZero];
            
            float newHeight = self.postType == PostTypeSmall ? MEDIA_HEIGHT_SMALL : MEDIA_HEIGHT_LARGE;
            
            if(self.article.articleTypeID == ArticleTypeImage)
                [self.mediaView setHeight:newHeight];
            
            [self.mediaView setArticle:self.article];
            
            self.mediaView.exclusiveTouch = YES;
            
            UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapped:)];
            tapRecognizer.numberOfTapsRequired = 2;
            [self.mediaView addGestureRecognizer:tapRecognizer];
            
            nextY = self.mediaView.bottom;
        }
            break;
            
        default:
            break;
    }
    
    /*
    if(self.articleView)
    {
       [self.articleView removeFromSuperview];
        self.articleView = nil;
    }
    
    self.articleView = [[ArticleView alloc] initWithArticle:self.article andFrame:CGRectMake(0, nextY, self.view.width, ARTICLE_HEIGHT)];
    self.articleView.delegate = self;
    self.commentTextField.delegate = self;
        [self.articleDetailScrollView addSubview:self.articleView];
    [self.articleDetailScrollView setContentSize:CGSizeMake(self.articleDetailScrollView.width, self.articleView.bottom)];
     */
    
    // notes count label
    NSString *notesText = (self.article.activities.count == 1 ? @"NOTE" : @"NOTES");
    NSString *notesFullText = [NSString stringWithFormat:@"%li %@", (long)self.article.activities.count, notesText];
    [self.notesButton setTitle:notesFullText forState:UIControlStateNormal];
    
    [self.commentsView setArticle:self.article];
    
    if(self.article.caption && self.article.articleTypeID != ArticleTypeText)
    {
        self.captionLabel.text = self.article.caption;
        [self.captionLabel sizeToFit];
    }
    else
    {
        self.captionLabel.height = 0;
    }
    
    [UIView animateWithDuration:0.2 animations:^
    {
        [self.detailView setTop:nextY];
    }
    completion:^(BOOL finished)
    {
        [UIView animateWithDuration:0.2 animations:^
        {
            [self.commentsView setTop:(self.captionLabel.bottom + PADDING)];
            
            [self.commentInputView setBottom:(APP_HEIGHT - self.mediaView.height - SMALL_PADDING)];//(self.commentsView.bottom + ARTICLE_OFFSET)];
        }
        completion:^(BOOL finished)
        {
            [self.detailView setHeight:(self.commentInputView.bottom + PADDING)];
            
            if(self.detailView.height + self.mediaView.height)
            
            [self.articleDetailScrollView setContentSize:CGSizeMake(self.view.width, self.detailView.bottom + PADDING)];
        }];
    }];
}

- (void)screenTapped:(UIGestureRecognizer *)recognizer
{
    [self.shareView removeFromSuperview];
    
    [self.articleDetailScrollView removeGestureRecognizer:self.screenTapRecognizer];
    
    self.screenTapRecognizer = nil;
}

- (void)doubleTapped:(UIGestureRecognizer *)recognizer
{
    if(self.article.iLove)
    {
        [[DataManager sharedInstance] deleteLoveForArticleID:self.article.articleID delegate:self];
    }
    else
    {
        [[DataManager sharedInstance] postLoveForArticleID:self.article.articleID delegate:self];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ArticleView Delegate Methods
- (void)articleViewDidRequestAddComment:(ArticleView *)articleView
{
    if(self.screenTapRecognizer)
    {
        [self.articleDetailScrollView removeGestureRecognizer:self.screenTapRecognizer];
        [self.shareView removeFromSuperview];
    }
    
    //[self.articleDetailScrollView setContentOffset:CGPointMake(0, KEYBOARD_HEIGHT + BORDER_PADDING)];
    [self.commentTextField becomeFirstResponder];
}

- (void)articleViewDidRequestLove:(ArticleView *)articleView
{
    [self doubleTapped:nil];
}

- (void)articleViewDidRequestShare:(ArticleView *)articleView
{
    if(self.screenTapRecognizer)
    {
        [self.articleDetailScrollView removeGestureRecognizer:self.screenTapRecognizer];
        [self.shareView removeFromSuperview];
    }
    else
    {
        self.screenTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(screenTapped:)];
        [self.articleDetailScrollView addGestureRecognizer:self.screenTapRecognizer];
    }
    
    if(!self.shareView)
    {
        self.shareView = [[ShareView alloc] initWithFrame:CGRectMake(self.view.width - SHARE_WIDTH, self.view.height / 2, SHARE_WIDTH, SHARE_HEIGHT)];
        self.shareView.delegate = self;
    }
    
    [self.articleDetailScrollView setContentOffset:CGPointMake(0, self.shareView.height)];
    
    [self.view addSubview:self.shareView];
}

#pragma mark - MediaContentView Delegate Methods
- (void)mediaContentViewDidRequestPlay:(MediaContentView *)mediaContentView
{
    FullScreenViewController *fsvc = [self.storyboard instantiateViewControllerWithIdentifier:FULL_SCREEN_VIEW_CONTROLLER];
    fsvc.article = mediaContentView.article;
    [self.navController navigateToViewController:fsvc animated:YES];
}

#pragma mark - ShareView Delegate Methods
- (void)shareViewDidRequestShareFacebook:(ShareView *)shareView
{
    NSLog(@"Share facebook");
    
    [self screenTapped:nil];
}

- (void)shareViewDidRequestShareTwitter:(ShareView *)shareView
{
    NSLog(@"Share twitter");
    
    [self screenTapped:nil];
}

- (void)shareViewDidRequestShareEmail:(ShareView *)shareView
{
    NSString *url = [NSString stringWithFormat:@"%@%@/post/%@", PEGGSITE_URL, [Friend currentFriend].userName, self.article.articleID];
    
    NSString *body = [NSString stringWithFormat:(NSLocalizedString(@"EmailShareContentBody", nil)), url];
    
    [[ShareManager sharedInstance] sendEmail:nil emailSubject:STRING_EMAIL_SHARE_CONTENT_SUBJECT emailBody:body fromController:self];
    
    [self screenTapped:nil];
}

- (void)shareViewDidRequestShareURL:(ShareView *)shareView
{
    NSString *url = [NSString stringWithFormat:@"%@%@/post/%@", PEGGSITE_URL, [Friend currentFriend].userName, self.article.articleID];
    [[UIPasteboard generalPasteboard] setString:url];
    
    [self screenTapped:nil];
}

#pragma mark - DataManagerDelegate
- (void)dataManager:(DataManager *)dataManager didReturnData:(id)data
{
    switch (dataManager.requestType)
    {
            
        case RequestTypeGetArticle:
        {
            NSDictionary *dict = (NSDictionary *)data;
            self.article = [[Article alloc] initWithDictionary:dict];
            [self getActivity];
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
            
            self.article.activities = [Utils reversedArray:allActivities];
            
            [self setUpArticle];
        }
            break;
            
        case RequestTypePostComment:
        case RequestTypePostLove:
        case RequestTypeDeleteLove:
        {
            [self getArticle];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - Nav Bar Visibility
- (BOOL)showNav
{
    return NO;
}

#pragma mark - Tab Bar Visibility
- (BOOL)showTabs
{
    return NO;
}

#pragma mark - Spinner Type For View
- (SpinnerType)spinnerType
{
    return SpinnerTypeP;
}

#pragma mark - Nav Bar Title
- (NSString *)title
{
    return TEXT_ARTICLE;
}

@end
