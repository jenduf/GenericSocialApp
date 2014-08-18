//
//  PeggTextField.m
//  PeggSite
//
//  Created by Jennifer Duffey on 4/11/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import "PeggTextField.h"

@implementation PeggTextField

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        if([self.font.fontName hasSuffix:@"Bold"] || [self.font.fontName hasSuffix:@"Medium"])
        {
            self.font = [UIFont fontWithName:FONT_PROXIMA_BOLD size:self.font.pointSize];
        }
        else
        {
            self.font = [UIFont fontWithName:FONT_PROXIMA_REGULAR size:self.font.pointSize];
        }
    }
    
    return self;
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx
{
    if(!self.borderStyle == UITextBorderStyleNone)
    {
        layer.backgroundColor = [UIColor whiteColor].CGColor;
        layer.borderColor = [[UIColor colorWithHexString:COLOR_CONTENT_STROKE] colorWithAlphaComponent:0.25].CGColor;
        layer.borderWidth = 1.0;
        layer.cornerRadius = CONTENT_CORNER_RADIUS;
    }
}

- (void)drawPlaceholderInRect:(CGRect)rect
{
    if(self.placeholder)
    {
        // color of placeholder text
        UIColor *placeHolderTextColor = [UIColor colorWithHexString:COLOR_PLACEHOLDER_TEXT];
        
        CGSize drawSize = [self.placeholder sizeWithAttributes:@{NSFontAttributeName: self.font}];
        
        CGRect drawRect = rect;
        
        // vertically align text
        drawRect.origin.y = (rect.size.height - drawSize.height) * 0.5;
        
        // set alignment
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = self.textAlignment;
        
        // dictionary of attributes, font, paragraphStyle, and color
        NSDictionary *drawAttributes = @{NSFontAttributeName : self.font, NSParagraphStyleAttributeName : paragraphStyle, NSForegroundColorAttributeName : placeHolderTextColor};
        
        // draw
        [self.placeholder drawInRect:drawRect withAttributes:drawAttributes];
    }
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}


@end
