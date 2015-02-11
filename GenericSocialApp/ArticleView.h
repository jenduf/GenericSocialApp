//
//  ArticleView.h
//  PeggSite
//
//  Created by Jennifer Duffey on 3/21/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ArticleViewDelegate;

@class CommentsView, PeggTextView;
@interface ArticleView : UIView
<UITextViewDelegate>

@property (nonatomic, strong) PeggLabel *notesCount;
@property (nonatomic, strong) UIButton *notesButton;
@property (nonatomic, strong) PeggLabel *captionLabel;
@property (nonatomic, strong) CommentsView *commentsView;

@property (nonatomic, strong) Article *article;
@property (nonatomic, weak) id <ArticleViewDelegate> delegate;

- (id)initWithArticle:(Article *)article andFrame:(CGRect)frame;
/*- (void)shrink;
- (void)grow;
- (void)slideUp;
- (void)slideDown;
- (void)fullScreen;
- (void)hideDetails;
*/

@end

@protocol ArticleViewDelegate

@optional
- (void)articleViewDidRequestAddComment:(ArticleView *)articleView;
- (void)articleViewDidRequestLove:(ArticleView *)articleView;
- (void)articleViewDidRequestShare:(ArticleView *)articleView;

@end