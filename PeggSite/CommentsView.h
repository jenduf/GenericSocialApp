//
//  CommentView.h
//  PeggSite
//
//  Created by Jennifer Duffey on 4/9/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ColorButton;
@interface CommentsView : UIView

@property (nonatomic, strong) Article *article;
@property (nonatomic, weak) IBOutlet UIScrollView *activitiesScrollView;
//@property (nonatomic, strong) PeggTextField *commentTextField;
//@property (nonatomic, strong) ColorButton *sendButton;

- (id)initWithArticle:(Article *)article andFrame:(CGRect)frame;

@end
