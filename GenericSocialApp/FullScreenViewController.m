//
//  FullScreenViewController.m
//  PeggSite
//
//  Created by Jennifer Duffey on 3/30/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import "FullScreenViewController.h"
#import "MediaContentView.h"

@interface FullScreenViewController ()
@property (weak, nonatomic) IBOutlet MediaContentView *mediaContentView;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

- (IBAction)viewTapped:(id)sender;
- (IBAction)close:(id)sender;

@end

@implementation FullScreenViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.shouldHideLoader = YES;
}

- (void)embedSoundCloud
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@", SOUND_CLOUD_URL, self.article.externalMediaID];
    
    [self playVideo:urlString];
}

- (void)embedVimeo
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@", VIMEO_URL, self.article.externalMediaID];
    
    [self playVideo:urlString];
}

- (void)embedYouTube
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@", YOU_TUBE_URL, self.article.externalMediaID];
    
    [self playVideo:urlString];
}

- (void)playVideo:(NSString *)url
{
    NSString *embedHTML = [NSString stringWithFormat:@"\
                           <html>\
                           <head>\
                           <style type=\"text/css\">\
                           iframe {position:absolute; top:50%%; margin-top:-130px;}\
                           body {background-color:#000; margin:0;}\
                           </style>\
                           </head>\
                           <body>\
                           <iframe width=\"100%%\" height=\"500px\" src=\"%@\" frameborder=\"0\" allowfullscreen></iframe>\
                           </body>\
                           </html>", url];
    
    
    [self.webView loadHTMLString:embedHTML baseURL:nil];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    switch (self.article.articleTypeID)
    {
        case ArticleTypeImage:
            [self.webView setHidden:YES];
            [self.mediaContentView setHidden:NO];
            [self.mediaContentView setArticle:self.article];
            break;
            
        case ArticleTypeYouTube:
            [self.webView setHidden:NO];
            [self.mediaContentView setHidden:YES];
            [self embedYouTube];
            break;
            
        case ArticleTypeVimeo:
            [self.webView setHidden:NO];
            [self.mediaContentView setHidden:YES];
            [self embedVimeo];
            break;
            
        case ArticleTypeSound:
            [self.webView setHidden:NO];
            [self.mediaContentView setHidden:YES];
            [self embedSoundCloud];
            break;
            
        default:
            break;
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)viewTapped:(id)sender
{
    [self.navController popViewController];
}

- (IBAction)close:(id)sender
{
    [self.navController popViewController];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Nav Bar Visibility
- (BOOL)showNav
{
    return YES;
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
    return @"";
}


@end
