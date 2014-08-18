//
//  ArticleView.m
//  PeggSite
//
//  Created by Jennifer Duffey on 3/21/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import "ArticleView.h"
#import "MediaContentView.h"
#import "Divider.h"
#import "CommentsView.h"
#import "ColorButton.h"
#import "Region.h"
#import "PeggTextView.h"

@implementation ArticleView

- (id)initWithArticle:(Article *)article andFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        
        [self setArticle:article];
    }
    
    return self;
}

- (void)setArticle:(Article *)article
{
    _article = article;
    
    float nextY = PADDING;
    
    Divider *divider = [[Divider alloc] initWithFrame:CGRectMake(PADDING, PADDING, self.width - (PADDING * 2), 1)];
    [self addSubview:divider];
    [divider centerHorizontallyInSuperView];
    
    nextY += PADDING;
    
   // notes button
    UIImage *notesImage = [UIImage imageNamed:IMAGE_NOTES];
    self.notesButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.notesButton setFrame:CGRectMake(ARTICLE_OFFSET, nextY, notesImage.size.width, notesImage.size.height)];
    [self.notesButton setBackgroundImage:notesImage forState:UIControlStateNormal];
    [self.notesButton addTarget:self action:@selector(notesTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.notesButton];
        
    // notes count label
    NSString *notesText = (article.activities.count == 1 ? @"NOTE" : @"NOTES");
    NSString *notesFullText = [NSString stringWithFormat:@"%li %@", (long)article.activities.count, notesText];
    self.notesCount = [[PeggLabel alloc] initWithText:notesFullText color:[UIColor colorWithHexString:COLOR_COUNT_TEXT] font:[UIFont fontWithName:FONT_PROXIMA_BOLD size:FONT_SIZE_NOTES] andFrame:CGRectZero];
    self.notesCount.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.notesCount];
    [self.notesCount sizeToFit];
    [self.notesCount setCenter:self.notesButton.center];
    [self.notesCount setLeft:(self.notesButton.right + PADDING)];
    
    // detail button
    UIImage *detailImage = [UIImage imageNamed:IMAGE_DETAIL_ARROW];
    UIButton *detailButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [detailButton setFrame:CGRectMake(self.width - detailImage.size.width - ARTICLE_OFFSET, nextY, detailImage.size.width, detailImage.size.height)];
    [detailButton setBackgroundImage:detailImage forState:UIControlStateNormal];
    [detailButton addTarget:self action:@selector(showShare:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:detailButton];
    
    // comment button
    UIImage *commentImage = [UIImage imageNamed:IMAGE_COMMENT];
    UIButton *commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [commentButton setFrame:CGRectMake(detailButton.left - commentImage.size.width - DELETE_BUTTON_PADDING, nextY, commentImage.size.width, commentImage.size.height)];
    [commentButton setBackgroundImage:commentImage forState:UIControlStateNormal];
    [commentButton addTarget:self action:@selector(commentTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:commentButton];
    
    nextY += (detailButton.height + PADDING);
    
    // caption label
    if(self.article.caption)
    {
        self.captionLabel = [[PeggLabel alloc] initWithText:article.caption color:[[UIColor colorWithHexString:COLOR_CAPTION_TEXT] colorWithAlphaComponent:0.88] font:[UIFont fontWithName:FONT_PROXIMA_REGULAR size:FONT_SIZE_CAPTION] andFrame:CGRectZero];
        self.captionLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.captionLabel];
        [self.captionLabel sizeToFit];
        [self.captionLabel setOrigin:CGPointMake(ARTICLE_DETAIL_PADDING, (self.notesButton.bottom + ARTICLE_OFFSET))];
        
        nextY += (self.captionLabel.height + PADDING);
    }
    
    self.commentsView = [[CommentsView alloc] initWithArticle:self.article andFrame:CGRectMake(ARTICLE_DETAIL_PADDING, nextY, self.width - (ARTICLE_OFFSET * 2), COMMENTS_HEIGHT)];
    [self addSubview:self.commentsView];
}

/*
- (void)addEditButton
{
    UIImage *addButtonImage = [UIImage imageNamed:IMAGE_GALLERY_ADD];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(0, 0, addButtonImage.size.width, addButtonImage.size.height)];
    [btn addTarget:self action:@selector(editButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundImage:addButtonImage forState:UIControlStateNormal];
    [self addSubview:btn];
    [btn centerInSuperView];
}

- (void)shrink
{
    [UIView animateWithDuration:0.3 animations:^
    {
        self.transform = CGAffineTransformMakeScale(0.85, 0.85);
    }];
}

- (void)grow
{
    [UIView animateWithDuration:0.3 animations:^
     {
         self.transform = CGAffineTransformMakeScale(1.0, 1.0);
     }];
}

- (void)hideDetails
{
    if(self.showingDetails)
    {
        self.showingDetails = !self.showingDetails;
       [self slideDown];
    }
}

- (void)slideUp
{
    [UIView animateWithDuration:0.3 animations:^
    {
        [self.detailContainer setFrame:CGRectMake(0, 0, self.mediaContentView.width, MEDIA_HEIGHT + self.detailContainer.height)];
    }
    completion:^(BOOL finished)
    {
        [self updateCaption];
        
        self.detailsView = [[CommentsView alloc] initWithArticle:self.region.article andFrame:CGRectMake(0, (self.captionTextView.bottom + SMALL_GAP), self.detailContainer.width, (self.detailContainer.height - self.captionTextView.height))];
        [self.detailContainer addSubview:self.detailsView];
    }];
}

- (void)slideDown
{
    [self updateCaption];
    
    [UIView animateWithDuration:0.2 animations:^
    {
        [self.detailsView setAlpha:0.0];
    }
     completion:^(BOOL finished)
    {
        [self.detailsView removeFromSuperview];
        self.detailsView = nil;
    }];
    
    [UIView animateWithDuration:0.3 delay:0.1 options:0 animations:^
    {
         [self.detailContainer setFrame:CGRectMake(0, self.mediaContentView.bottom, self.mediaContentView.width, self.containerView.height - self.mediaContentView.bottom)];
    }
     completion:^(BOOL finished)
    {
        
    }];
}

- (void)fullScreen
{
    [UIView animateWithDuration:0.3 animations:^
    {
        self.mediaContentView.mediaImageView.frame = CGRectMake(0, 0, APP_WIDTH, APP_HEIGHT);
    }];
}

- (void)setDelegate:(id<ArticleViewDelegate>)delegate
{
    _delegate = delegate;
}

- (void)setEditable:(BOOL)editable
{
    _editable = editable;
}

- (void)updateCaption
{
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineSpacing = CAPTION_LINE_SPACING;
    paraStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    
    NSString *caption = self.region.article.caption;

    NSDictionary *attributedAttributes = @{NSFontAttributeName : [UIFont fontWithName:FONT_PROXIMA_REGULAR size:FONT_SIZE_NOTES], NSForegroundColorAttributeName : [UIColor colorWithHexString:COLOR_CAPTION_TEXT], NSParagraphStyleAttributeName : paraStyle};
    
    NSDictionary *moreAttributes = @{NSFontAttributeName : [UIFont fontWithName:FONT_PROXIMA_REGULAR size:FONT_SIZE_NOTES], NSForegroundColorAttributeName : [UIColor colorWithHexString:COLOR_MORE_TEXT], NSParagraphStyleAttributeName : paraStyle};
    
    if(self.showingDetails || caption.length <= CAPTION_MAX_LENGTH)
    {
        //if(caption.length == 0)
        //{
            //caption = @"
       // }
        NSAttributedString *captionString = [[NSAttributedString alloc] initWithString:self.region.article.caption attributes:attributedAttributes];
        //self.captionLabel.text = self.article.caption;
        self.captionTextView.attributedText = captionString;
        
        [self.captionTextView sizeToFit];
    }
    else
    {
        NSMutableAttributedString *subbedString = [[NSMutableAttributedString alloc] initWithString:[self.region.article.caption substringToIndex:CAPTION_MAX_LENGTH] attributes:attributedAttributes];
        
        NSAttributedString *moreString = [[NSAttributedString alloc] initWithString:@" ...more" attributes:moreAttributes];
        
        [subbedString appendAttributedString:moreString];
        
        self.captionTextView.attributedText = subbedString;
        
        [self.captionTextView setFrame:CGRectMake(0, (self.notesButton.bottom + SMALL_PADDING), self.detailContainer.width, CAPTION_TEXT_HEIGHT)];
        
        [self.captionTextView sizeToFit];
    }
}

- (void)editButtonTapped:(id)sender
{
    UIButton *addButton = (UIButton *)sender;
    
    UIImage *textIcon = [UIImage imageNamed:@"article_text_button"];
    UIButton *textButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [textButton setFrame:CGRectMake(0, 0, textIcon.size.width, textIcon.size.height)];
    [textButton setBackgroundImage:textIcon forState:UIControlStateNormal];
    [textButton setAlpha:0.0];
    textButton.tag = ArticleTypeText;
    [textButton addTarget:self action:@selector(optionSelected:) forControlEvents:UIControlEventTouchUpInside];
    [self.containerView addSubview:textButton];
    
    UIImage *imageIcon = [UIImage imageNamed:@"article_image_button"];
    UIButton *imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [imageButton setFrame:CGRectMake(textButton.right, 0, imageIcon.size.width, imageIcon.size.height)];
    [imageButton setBackgroundImage:imageIcon forState:UIControlStateNormal];
    [imageButton setAlpha:0.0];
    imageButton.tag = ArticleTypeImage;
    [imageButton addTarget:self action:@selector(optionSelected:) forControlEvents:UIControlEventTouchUpInside];
    [self.containerView addSubview:imageButton];
    
    UIImage *audioIcon = [UIImage imageNamed:@"article_audio_button"];
    UIButton *audioButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [audioButton setFrame:CGRectMake(0, textButton.bottom, audioIcon.size.width, audioIcon.size.height)];
    [audioButton setBackgroundImage:audioIcon forState:UIControlStateNormal];
    [audioButton setAlpha:0.0];
    audioButton.tag = ArticleTypeSound;
    [audioButton addTarget:self action:@selector(optionSelected:) forControlEvents:UIControlEventTouchUpInside];
    [self.containerView addSubview:audioButton];
    
    UIImage *videoIcon = [UIImage imageNamed:@"article_video_button"];
    UIButton *videoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [videoButton setFrame:CGRectMake(audioButton.right, imageButton.bottom, videoIcon.size.width, videoIcon.size.height)];
    [videoButton setBackgroundImage:videoIcon forState:UIControlStateNormal];
    [videoButton setAlpha:0.0];
    videoButton.tag = ArticleTypeYouTube;
    [videoButton addTarget:self action:@selector(optionSelected:) forControlEvents:UIControlEventTouchUpInside];
    [self.containerView addSubview:videoButton];
    
    [UIView animateWithDuration:0.3 animations:^
    {
        [audioButton setAlpha:1.0];
        [videoButton setAlpha:1.0];
        [textButton setAlpha:1.0];
        [imageButton setAlpha:1.0];
        [addButton setAlpha:0.0];
    }];
}

- (void)optionSelected:(id)sender
{
    ArticleType type = [sender tag];
    
    [self.delegate articleView:self didRequestAddArticleType:type];
}

- (void)mediaTapped:(UIGestureRecognizer *)recognizer
{
    [self.delegate articleViewDidRequestDisplayMedia:self];
}

- (void)detailsTapped:(UIGestureRecognizer *)recognizer
{
    self.showingDetails = !self.showingDetails;
    
    if(self.showingDetails)
        [self.delegate articleViewDidRequestShowActivities:self];
    else
        [self slideDown];
        
}
*/

- (void)notesTapped:(id)sender
{
    [self.delegate articleViewDidRequestLove:self];
}

- (void)commentTapped:(id)sender
{
    [self.delegate articleViewDidRequestAddComment:self];
}

- (void)showShare:(id)sender
{
    [self.delegate articleViewDidRequestShare:self];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    //self.showingDetails = YES;
    
   // [self slideUp];
    
 //   [self.delegate articleViewDidRequestEditCaption:self];
    
   // [self.captionTextView becomeFirstResponder];
    
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [textView resignFirstResponder];
}

@end
