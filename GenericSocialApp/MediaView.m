//
//  MediaWebView.m
//  PeggSite
//
//  Created by Jennifer Duffey on 7/14/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import "MediaView.h"

@implementation MediaView

- (void)setArticle:(Article *)article
{
    _article = article;
    
    NSString *urlString;
    
    switch (article.articleTypeID)
    {
        case ArticleTypeText:
        {
            [self.textContentView setHidden:NO];
          //  [self.webView setHidden:YES];
           // [self.contentImageView setHidden:YES];
            self.titleLabel.text = article.caption;
            
            NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
            paraStyle.lineSpacing = CAPTION_LINE_SPACING;
            paraStyle.lineBreakMode = NSLineBreakByWordWrapping;
            paraStyle.alignment = NSTextAlignmentLeft;
            
            NSDictionary *nameAttributes = @{NSFontAttributeName : [UIFont fontWithName:FONT_PROXIMA_REGULAR size:FONT_SIZE_TEXT_CONTENT], NSForegroundColorAttributeName : [UIColor colorWithHexString:COLOR_BUTTON_TEXT], NSParagraphStyleAttributeName : paraStyle};
            
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[Utils removeHTMLFromString:article.text] attributes:nameAttributes];
            
            self.textView.attributedText = attributedString;
            [self.textView sizeToFit];
            
            [self.textView setHeight:MIN(MEDIA_HEIGHT_LARGE - self.textView.top - (PADDING * 2), self.textView.height)];
            [self setHeight:(self.textView.bottom + (PADDING * 2))];
        }
            break;
            
        case ArticleTypeImage:
        {
           // [self.webView setHidden:YES];
            [self.contentImageView setHidden:NO];
            self.contentImageView.image = article.articleImage;
            [self.contentImageView setSize:self.size];
            [self.contentImageView setContentMode:UIViewContentModeScaleAspectFill];
            [self setHeight:self.contentImageView.bottom];
        }
            break;
            
        case ArticleTypeSound:
            self.contentImageView.image = article.articleImage;
            urlString = [NSString stringWithFormat:@"%@%@", SOUND_CLOUD_URL, self.article.externalMediaID];
            [self playAudio:urlString];
            break;
            
        case ArticleTypeVimeo:
            urlString = [NSString stringWithFormat:@"%@%@", VIMEO_URL, self.article.externalMediaID];
            [self playVideo:urlString];
            [self setHeight:VIDEO_HEIGHT];
            break;
            
        case ArticleTypeYouTube:
            urlString = [NSString stringWithFormat:@"%@%@", YOU_TUBE_URL, self.article.externalMediaID];
            [self playVideo:urlString];
            [self setHeight:VIDEO_HEIGHT];
            break;
            
        default:
            break;
    }
}

- (void)playVideo:(NSString *)url
{
    [self.webView setHidden:NO];
    [self setHeight:self.webView.height];
   // [self.contentImageView setHidden:YES];
    
    /*NSString *embedHTML = [NSString stringWithFormat:@"\
                           <html>\
                           <head>\
                           <style type=\"text/css\">\
                           iframe {position:absolute; top:50%%; margin-top:-130px;}\
                           body {background-color:#000; margin:0;}\
                           </style>\
                           </head>\
                           <body>\
                           <iframe width=\"100%%\" height=\"300px\" src=\"%@\" frameborder=\"0\" allowfullscreen></iframe>\
                           </body>\
                           </html>", url];*/

    NSString *embedHTML = [NSString stringWithFormat:@"\
                           <iframe id=\"ytplayer\" type=\"text/html\" width=\"100%%\" height=\"240\" src=\"%@\" frameborder=\"no\" allowfullscreen></iframe>", url];
    
    
    [self.webView loadHTMLString:embedHTML baseURL:nil];
}

- (void)playAudio:(NSString *)url
{
    [self.webView setHidden:NO];
    [self setHeight:self.webView.height];
    
    NSString *audioSource = [NSString stringWithFormat:@"%@&amp;auto_play=false&amp;hide_related=false&amp;show_comments=true&amp;show_user=true&amp;show_reposts=false&amp;visual=true", url];
    
    NSString *embedHTML = [NSString stringWithFormat:@"\
                           <iframe width=\"100%%\" height=\"300\" scrolling=\"no\" frameborder=\"no\" src=\"%@\"></iframe>", audioSource];
    
    [self.webView loadHTMLString:embedHTML baseURL:nil];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
