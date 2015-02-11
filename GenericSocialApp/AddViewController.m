//
//  AddViewController.m
//  PeggSite
//
//  Created by Jennifer Duffey on 6/13/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import "AddViewController.h"
#import "ArticleContentView.h"

@interface AddViewController ()
<UIAlertViewDelegate>

@property (nonatomic, weak) IBOutlet UIView *contentView;

- (IBAction)cancel:(id)sender;
- (IBAction)post:(id)sender;

@end

@implementation AddViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.shouldHideLoader = YES;
    
    [self setUpContent];
}

- (void)setUpContent
{
    ArticleContentView *contentView = (ArticleContentView *)[self.view viewWithTag:self.contentType];
    contentView.hidden = NO;
    
    if(self.contentType == AddContentTypeText)
    {
        [contentView.contentTextView becomeFirstResponder];
        
        if(self.article)
        {
            self.placeholder = contentView.contentTextView.text;
            contentView.contentTextView.text = self.article.text;
            contentView.titleTextField.text = self.article.caption;
        }
    }
    else
    {
        [contentView.titleTextField becomeFirstResponder];
    }
}

- (IBAction)cancel:(id)sender
{
    [Region setCurrentRegion:nil];
    
    if(self.article)
        [self.navController hideModalViewController:self];
    else
        [self.navController popViewController];
}

- (IBAction)post:(id)sender
{
    ArticleContentView *contentView = (ArticleContentView *)[self.view viewWithTag:self.contentType];
    
    if(self.contentType == AddContentTypeText)
    {
        if(self.article)
        {
            self.article.text = contentView.contentTextView.text;
            [[DataManager sharedInstance] updateArticle:self.article delegate:self];
        }
        else
        {
            [[DataManager sharedInstance] createArticleWithExternalMediaID:[self determineExternalMediaID] articleType:[self determineArticleType] regionNumber:[Region currentRegion].regionNumber text:contentView.contentTextView.text caption:contentView.titleTextField.text delegate:self];
        }
    }
    else
    {
        NSLog(@"Region: %ld Article Type: %ld Media ID: %@ text: %@ caption: %@", (long)[Region currentRegion].regionNumber, (long)[self determineArticleType], [self determineExternalMediaID], contentView.titleTextField.text, contentView.contentTextView.text);
        
        NSString *caption = nil;
        
        if(self.placeholder)
        {
            caption = ([contentView.contentTextView.text isEqualToString:self.placeholder] ? nil : contentView.contentTextView.text);
        }
        
        [[DataManager sharedInstance] createArticleWithExternalMediaID:[self determineExternalMediaID] articleType:[self determineArticleType] regionNumber:[Region currentRegion].regionNumber text:nil caption:caption delegate:self];
    }
}

// helper methods
- (NSString *)determineExternalMediaID
{
    NSString *externalMediaID;
    
    ArticleContentView *contentView = (ArticleContentView *)[self.view viewWithTag:self.contentType];
    
    switch (self.contentType)
    {
        case AddContentTypePhoto:
            
            break;
            
        case AddContentTypeAudio:
            externalMediaID = contentView.titleTextField.text;
            break;
            
        case AddContentTypeText:
            
            break;
            
        case AddContentTypeVideo:
        {
            NSString *url = contentView.titleTextField.text;
            if([url rangeOfString:@"vimeo"].location != NSNotFound)
            {
                NSArray *urlComponents = [url componentsSeparatedByString:@"vimeo.com/"];
                if(urlComponents && urlComponents.count >= 1)
                    externalMediaID = urlComponents[1];
            }
            else if([url rangeOfString:@"?v="].location != NSNotFound)
            {
                NSArray *urlComponents = [url componentsSeparatedByString:@"?v="];
                if(urlComponents && urlComponents.count >= 1)
                    externalMediaID = urlComponents[1];
            }
        }
            break;
            
        default:
            break;
    }
    
    return externalMediaID;
}

- (ArticleType)determineArticleType
{
    ArticleType articleType;
    
    ArticleContentView *contentView = (ArticleContentView *)[self.view viewWithTag:self.contentType];
    
    switch (self.contentType)
    {
        case AddContentTypeAudio:
            articleType = ArticleTypeSound;
            break;
            
        case AddContentTypeVideo:
        {
            NSString *url = contentView.titleTextField.text;
            if([url rangeOfString:@"vimeo"].location != NSNotFound)
            {
                articleType = ArticleTypeVimeo;
            }
            else
            {
                articleType = ArticleTypeYouTube;
            }
        }
            break;
            
        case AddContentTypePhoto:
            articleType = ArticleTypeImage;
            break;
            
        case AddContentTypeText:
            articleType = ArticleTypeText;
            break;
            
        default:
            break;
    }
    
    return articleType;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIAlertViewDelegate Methods
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(self.article)
        [self.navController hideModalViewController:self];
    else
        [self.navController popViewController];
}

/*
#pragma mark - UITextView Delegate Methods
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if(!self.article)
        [super textViewDidBeginEditing:textView];
}
 */

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [super textViewDidEndEditing:textView];
    
    NSString *textString;
    
    if(textView.text && textView.text.length > 0)
        textString = textView.text;
    else if(textView.attributedText && textView.attributedText.length > 0)
        textString = textView.attributedText.string;
    
    if(textString && textString.length > 0)
    {
        textView.attributedText = [Utils getAttributedStringFromString:textString];
    }
    else
    {
        textView.attributedText = nil;
        textView.text = self.placeholder;
        textView.textColor = [UIColor colorWithHexString:COLOR_PLACEHOLDER_TEXT];
    }
}

#pragma mark - DataManagerDelegate
- (void)dataManager:(DataManager *)dataManager didReturnData:(id)data
{
    UIAlertView *alert = [Utils createAlertWithPrefix:STRING_CONTENT_UPDATED_PREFIX customMessage:nil showOther:NO andDelegate:self];
    [alert show];
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
    return nil;
}

@end
