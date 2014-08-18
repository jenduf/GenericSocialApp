//
//  ArticleContentView.m
//  PeggSite
//
//  Created by Jennifer Duffey on 6/13/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import "ArticleContentView.h"

@implementation ArticleContentView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        self.contentType = self.tag;
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineSpacing = CAPTION_LINE_SPACING;
    paraStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    
    NSDictionary *nameAttributes = @{NSFontAttributeName : [UIFont fontWithName:FONT_PROXIMA_REGULAR size:FONT_SIZE_TEXT_CONTENT], NSForegroundColorAttributeName : [UIColor colorWithHexString:COLOR_BUTTON_TEXT], NSParagraphStyleAttributeName : paraStyle};
    
    [self.contentTextView setTypingAttributes:nameAttributes];
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
