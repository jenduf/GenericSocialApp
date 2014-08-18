//
//  CommentView.m
//  PeggSite
//
//  Created by Jennifer Duffey on 4/9/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import "CommentsView.h"
#import "Activity.h"
#import "ColorButton.h"
#import "Divider.h"
#import "NSDate+PSFoundation.h"

@implementation CommentsView

- (id)initWithArticle:(Article *)article andFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        _article = article;
        
        float nextY = 0;
        
       // HeaderView *commentHeaderView = [[HeaderView alloc] initWithFrame:CGRectMake(0, nextY, self.width, LABEL_HEIGHT) andText:TEXT_HEADER_COMMENTS];
       // [self addSubview:commentHeaderView];
       // [commentHeaderView centerHorizontallyInSuperView];
        
        Divider *divider = [[Divider alloc] initWithFrame:CGRectMake(0, 0, self.width, 1)];
        [self addSubview:divider];
        [divider centerHorizontallyInSuperView];
        
        nextY += (divider.height + SMALL_PADDING);
        
        /*
        
        if(self.article.activities && self.article.activities.count > 0)
        {
            self.activitiesScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(SMALL_GAP, nextY, self.width - (SMALL_GAP * 2), (self.height - (nextY * 2)))];
            
            NSLog(@"Scroll height: %@", NSStringFromCGRect(self.activitiesScrollView.frame));
                   
            [self addSubview:self.activitiesScrollView];
            
            nextY = 0;
            
            for(Activity *activity in article.activities)
            {
                UIView *commentView = [[UIView alloc] initWithFrame:CGRectMake(SMALL_GAP, nextY, self.width - (SMALL_GAP * 2), AVATAR_SIZE + (SMALL_PADDING * 2))];
                commentView.backgroundColor = [UIColor clearColor];
                [self.activitiesScrollView addSubview:commentView];
                
                UIImageView *imageView = [[UIImageView alloc] initWithImage:activity.activityThumbnail];
                [commentView addSubview:imageView];
                [imageView centerVerticallyInSuperView];
                
                PeggLabel *name = [[PeggLabel alloc] initWithText:[NSString stringWithFormat:@"%@", activity.userName] color:[UIColor colorWithHexString:COLOR_ORANGE_BUTTON] font:[UIFont fontWithName:FONT_PROXIMA_BOLD size:FONT_SIZE_ACTIVITY] andFrame:CGRectZero];
                [commentView addSubview:name];
                [name sizeToFit];
                [name centerVerticallyInSuperView];
                [name setLeft:(imageView.right + PADDING)];
                
                PeggLabel *comment = [[PeggLabel alloc] initWithText:@"" color:[UIColor colorWithHexString:COLOR_CAPTION_TEXT] font:[UIFont fontWithName:FONT_PROXIMA_REGULAR size:FONT_SIZE_ACTIVITY] andFrame:CGRectMake(name.right, name.top, (commentView.width - name.right), 0)];
                comment.numberOfLines = 0;
                comment.lineBreakMode = NSLineBreakByWordWrapping;
                
                if(activity.activityType == ActivityTypeLove)
                {
                    comment.text  = @" loved this";
                }
                else
                {
                    comment.text = [NSString stringWithFormat:@": \"%@\"", activity.comment];
                }
                
                [commentView addSubview:comment];
                
                [comment sizeToFit];
                
               // [commentView sizeToFit];
                
                //NSLog(@"Comment height: %f", comment.height);
                
                nextY += (commentView.height + PADDING);
            }
            
            [self.activitiesScrollView setContentSize:CGSizeMake(self.activitiesScrollView.width, nextY)];
            
            [self.activitiesScrollView setContentOffset:CGPointMake(0, self.activitiesScrollView.contentSize.height - self.activitiesScrollView.height) animated:YES];
            
            [self.activitiesScrollView setHeight:MIN(COMMENTS_HEIGHT, self.height)];
        
            Divider *divider2 = [[Divider alloc] initWithFrame:CGRectMake(0, nextY, self.width, 1)];
            [self addSubview:divider2];
            [divider2 centerHorizontallyInSuperView];
            
            nextY += ARTICLE_DETAIL_PADDING;
        }
        
        nextY += PADDING;
        
        self.commentTextField = [[PeggTextField alloc] initWithFrame:CGRectMake(SMALL_GAP, nextY, COMMENT_TEXT_WIDTH, COMMENT_TEXT_HEIGHT)];
        self.commentTextField.font = [UIFont fontWithName:FONT_PROXIMA_REGULAR size:FONT_SIZE_ACTIVITY];
        self.commentTextField.borderStyle = UITextBorderStyleLine;
        self.commentTextField.placeholder = @"Leave a comment";
        [self addSubview:self.commentTextField];
        
        self.sendButton = [[ColorButton alloc] initWithButtonStyle:ButtonStyleGreen title:@"Send" andFrame:CGRectMake(COMMENT_TEXT_WIDTH + SMALL_PADDING, self.commentTextField.top, SEND_BUTTON_WIDTH, COMMENT_TEXT_HEIGHT)];
        [self addSubview:self.sendButton];
        
        PeggLabel *timeLabel = [[PeggLabel alloc] initWithText:@"" color:[UIColor colorWithHexString:COLOR_TIME_TEXT] font:[UIFont fontWithName:FONT_PROXIMA_EXTRA_BOLD size:FONT_SIZE_TIME] andFrame:CGRectZero];
        
        NSString *dateString = [article.dateAdded prettyDate];
        
        timeLabel.text = [dateString uppercaseString];
        [self addSubview:timeLabel]; 

        [timeLabel sizeToFit];
        [timeLabel centerHorizontallyInSuperView];
        [timeLabel setTop:(divider2.bottom + PADDING)];
        */
        /*
        UIButton *viewAllButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [viewAllButton setTitle:TEXT_VIEW_ALL forState:UIControlStateNormal];
        [viewAllButton setTitleColor:[[UIColor colorWithHexString:COLOR_ARTICLE_TEXT] colorWithAlphaComponent:0.4] forState:UIControlStateNormal];
        [viewAllButton.titleLabel setFont:[UIFont fontWithName:FONT_HELVETICA_NEUE_BOLD size:FONT_SIZE_SUBHEADER]];
        [self addSubview:viewAllButton];
        [viewAllButton sizeToFit];
        [viewAllButton centerHorizontallyInSuperView];
        [viewAllButton setTop:nextY];
        
        nextY += (viewAllButton.height + PADDING);
        
        HeaderView *loveHeaderView = [[HeaderView alloc] initWithFrame:CGRectMake(0, nextY, self.width, LABEL_HEIGHT) andText:TEXT_HEADER_LOVES];
        [self addSubview:loveHeaderView];
        [loveHeaderView centerHorizontallyInSuperView];
        
        nextY += (loveHeaderView.height + SMALL_GAP);
        
        NSMutableArray *loveArray = [NSMutableArray array];
        
        for(Love *love in loves)
        {
            [loveArray addObject:love.userName];
        }
        
        NSString *loveString = [loveArray componentsJoinedByString:@", "];
        
        PeggLabel *loveLabel = [[PeggLabel alloc] initWithText:loveString color:[UIColor colorWithHexString:COLOR_ARTICLE_TEXT] andFont:[UIFont fontWithName:FONT_GOTHAM_MEDIUM size:FONT_SIZE_SUBHEADER]];
        [self addSubview:loveLabel];
        [loveLabel sizeToFit];
        [loveLabel setOrigin:CGPointMake(0, nextY)];
        
        nextY += (loveLabel.height + SMALL_PADDING);
        
        UIButton *viewAllButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
        [viewAllButton2 setTitle:TEXT_VIEW_ALL forState:UIControlStateNormal];
        [viewAllButton2 setTitleColor:[[UIColor colorWithHexString:COLOR_ARTICLE_TEXT] colorWithAlphaComponent:0.4] forState:UIControlStateNormal];
        [viewAllButton2.titleLabel setFont:[UIFont fontWithName:FONT_HELVETICA_NEUE_BOLD size:FONT_SIZE_SUBHEADER]];
        [self addSubview:viewAllButton2];
        [viewAllButton2 sizeToFit];
        [viewAllButton2 centerHorizontallyInSuperView];
        [viewAllButton2 setTop:nextY];
         */
    }
    
    return self;
}

- (void)setArticle:(Article *)article
{
    _article = article;
    
    if(article.activities && article.activities.count > 0)
    {
        float nextY = 0;
        
        for(Activity *activity in article.activities)
        {
            UIView *commentView = [[UIView alloc] initWithFrame:CGRectMake(SMALL_GAP, nextY, self.width - (SMALL_GAP * 2), AVATAR_SIZE + (SMALL_PADDING * 2))];
            commentView.backgroundColor = [UIColor clearColor];
            [self.activitiesScrollView addSubview:commentView];
            
            UIImageView *imageView = [[UIImageView alloc] initWithImage:activity.activityThumbnail];
            [commentView addSubview:imageView];
            [imageView centerVerticallyInSuperView];
            
            PeggLabel *name = [[PeggLabel alloc] initWithText:[NSString stringWithFormat:@"%@", activity.userName] color:[UIColor colorWithHexString:COLOR_ORANGE_BUTTON] font:[UIFont fontWithName:FONT_PROXIMA_BOLD size:FONT_SIZE_ACTIVITY] andFrame:CGRectZero];
            [commentView addSubview:name];
            [name sizeToFit];
            [name centerVerticallyInSuperView];
            [name setLeft:(imageView.right + PADDING)];
            
            PeggLabel *comment = [[PeggLabel alloc] initWithText:@"" color:[UIColor colorWithHexString:COLOR_CAPTION_TEXT] font:[UIFont fontWithName:FONT_PROXIMA_REGULAR size:FONT_SIZE_ACTIVITY] andFrame:CGRectMake(name.right, name.top, (commentView.width - name.right), 0)];
            comment.numberOfLines = 0;
            comment.lineBreakMode = NSLineBreakByWordWrapping;
            
            if(activity.activityType == ActivityTypeLove)
            {
                comment.text  = @" loved this";
            }
            else
            {
                comment.text = [NSString stringWithFormat:@": \"%@\"", activity.comment];
            }
            
            [commentView addSubview:comment];
            
            [comment sizeToFit];
            
            // [commentView sizeToFit];
            
            //NSLog(@"Comment height: %f", comment.height);
            
            nextY += (commentView.height + PADDING);
        }
        
        [self.activitiesScrollView setContentSize:CGSizeMake(self.activitiesScrollView.width, nextY)];
        
        [self setHeight:MIN(COMMENTS_HEIGHT, nextY)];
        
       //  [self.activitiesScrollView setContentOffset:CGPointMake(0, self.activitiesScrollView.contentSize.height - self.activitiesScrollView.height) animated:YES];
    }
    else
    {
        [self setHeight:0];
    }
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
