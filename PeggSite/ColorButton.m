//
//  LoginButton.m
//  PeggSite
//
//  Created by Jennifer Duffey on 3/6/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import "ColorButton.h"

@implementation ColorButton

- (void)awakeFromNib
{
   // NSLog(@"Button Style: %@", @(self.buttonStyle));
}

- (id)initWithButtonStyle:(ButtonStyle)buttonStyle title:(NSString *)title andFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if(self)
    {
        [self setTitle:title forState:UIControlStateNormal];
        
        [self setButtonStyle:buttonStyle];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        [self setButtonStyle:(ButtonStyle)self.tag];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //self.titleLabel.font = [UIFont fontWithName:FONT_PROXIMA_REGULAR size:self.titleLabel.font.pointSize];
}

- (void)setButtonStyle:(ButtonStyle)buttonStyle
{
    _buttonStyle = buttonStyle;
    
    [self setNeedsDisplay];
}

- (UIColor *)getBackgroundColor
{
    UIColor *returnColor;
    
    switch (self.buttonStyle)
    {
        case ButtonStyleNone:
        case ButtonStyleEdit:
            returnColor = [UIColor clearColor];
            break;
            
        case ButtonStyleOrange:
            returnColor = [UIColor colorWithHexString:COLOR_ORANGE_BUTTON];
            break;
            
        case ButtonStyleGreen:
            returnColor = [UIColor colorWithHexString:COLOR_GREEN_BUTTON];
            break;
            
        case ButtonStyleLogin:
            returnColor = [[UIColor colorWithHexString:COLOR_LOGIN_BUTTON] colorWithAlphaComponent:1.0];
            break;
            
        case ButtonStyleForgotPassword:
            returnColor = [UIColor colorWithHexString:COLOR_FORGOT_PASSWORD_BUTTON];
            break;
            
        case ButtonStyleArticle:
            returnColor = [UIColor colorWithHexString:COLOR_ARTICLE_BUTTON];
            break;
            
        case ButtonStyleBrown:
            returnColor = [UIColor colorWithHexString:COLOR_BROWN_BUTTON];
            break;
            
        case ButtonStyleBeige:
            returnColor = [UIColor colorWithHexString:COLOR_BEIGE_BUTTON];
            break;
            
        case ButtonStyleAdd:
            returnColor = [UIColor colorWithHexString:COLOR_ADD_BUTTON];
            break;
            
        case ButtonStyleCancel:
            returnColor = [UIColor colorWithHexString:COLOR_CANCEL_BUTTON];
            break;
            
        default:
            break;
    }
    
    return returnColor;
}

- (UIColor *)getSelectedBackgroundColor
{
    UIColor *returnColor;
    
    switch (self.buttonStyle)
    {
        case ButtonStyleNone:
        case ButtonStyleEdit:
            returnColor = [UIColor clearColor];
            break;
            
        case ButtonStyleOrange:
            returnColor = [UIColor colorWithHexString:COLOR_ORANGE_BUTTON];
            break;
            
        case ButtonStyleGreen:
            returnColor = [UIColor colorWithHexString:COLOR_GREEN_BUTTON];
            break;
            
        case ButtonStyleLogin:
            returnColor = [[UIColor colorWithHexString:COLOR_LOGIN_BUTTON] colorWithAlphaComponent:1.0];
            break;
            
        case ButtonStyleForgotPassword:
            returnColor = [UIColor colorWithHexString:COLOR_FORGOT_PASSWORD_BUTTON];
            break;
            
        case ButtonStyleArticle:
            returnColor = [UIColor colorWithHexString:COLOR_ARTICLE_BUTTON];
            break;
            
        case ButtonStyleBrown:
            returnColor = [UIColor colorWithHexString:COLOR_BROWN_BUTTON];
            break;
            
        case ButtonStyleBeige:
            returnColor = [UIColor colorWithHexString:COLOR_BEIGE_BUTTON];
            break;
            
        case ButtonStyleAdd:
            returnColor = [UIColor colorWithHexString:COLOR_ADD_BUTTON_SELECTED];
            break;
            
        case ButtonStyleCancel:
            returnColor = [UIColor colorWithHexString:COLOR_CANCEL_BUTTON];
            break;
            
        default:
            break;
    }
    
    return returnColor;
}

- (UIColor *)getHighlightedBackgroundColor
{
    UIColor *returnColor;
    
    switch (self.buttonStyle)
    {
        case ButtonStyleNone:
        case ButtonStyleEdit:
            returnColor = [UIColor clearColor];
            break;
            
        case ButtonStyleOrange:
            returnColor = [UIColor colorWithHexString:COLOR_ORANGE_BUTTON];
            break;
            
        case ButtonStyleGreen:
            returnColor = [UIColor colorWithHexString:COLOR_GREEN_BUTTON];
            break;
            
        case ButtonStyleLogin:
            returnColor = [[UIColor colorWithHexString:COLOR_LOGIN_BUTTON] colorWithAlphaComponent:1.0];
            break;
            
        case ButtonStyleForgotPassword:
            returnColor = [UIColor colorWithHexString:COLOR_FORGOT_PASSWORD_BUTTON];
            break;
            
        case ButtonStyleArticle:
            returnColor = [UIColor colorWithHexString:COLOR_ARTICLE_BUTTON];
            break;
            
        case ButtonStyleBrown:
            returnColor = [UIColor colorWithHexString:COLOR_BROWN_BUTTON];
            break;
            
        case ButtonStyleBeige:
            returnColor = [UIColor colorWithHexString:COLOR_BEIGE_BUTTON];
            break;
            
        case ButtonStyleAdd:
            returnColor = [UIColor colorWithHexString:COLOR_ADD_BUTTON_SELECTED];
            break;
            
        case ButtonStyleCancel:
            returnColor = [UIColor colorWithHexString:COLOR_CANCEL_BUTTON];
            break;
            
        default:
            break;
    }
    
    return returnColor;
}

- (CGFloat)getAlpha
{
    CGFloat returnAlpha = 1.0;
    
    switch (self.buttonStyle)
    {
        case ButtonStyleOrange:
        case ButtonStyleForgotPassword:
        case ButtonStyleGreen:
        case ButtonStyleBrown:
        case ButtonStyleEdit:
        case ButtonStyleAdd:
        case ButtonStyleCancel:
            returnAlpha = 1.0;
            break;
            
        case ButtonStyleLogin:
        case ButtonStyleBeige:
            returnAlpha = 0.85;
            break;
            
        case ButtonStyleArticle:
            returnAlpha = 0.6;
            break;
            
        default:
            break;
    }
    
    return returnAlpha;
}

- (UIColor *)getStrokeColor
{
    UIColor *strokeColor;
    
    switch (self.buttonStyle)
    {
        case ButtonStyleOrange:
        case ButtonStyleLogin:
        case ButtonStyleForgotPassword:
        case ButtonStyleBeige:
        case ButtonStyleArticle:
        case ButtonStyleAdd:
        case ButtonStyleCancel:
            strokeColor = nil;
            break;
            
        case ButtonStyleGreen:
            strokeColor = [UIColor colorWithHexString:COLOR_GREEN_BUTTON_BORDER];
            break;
            
        case ButtonStyleBrown:
            strokeColor = [UIColor colorWithHexString:COLOR_BROWN_BUTTON_BORDER];
            break;
            
        case ButtonStyleEdit:
            strokeColor = [UIColor whiteColor];
            break;
            
        default:
            break;
    }
    
    return strokeColor;
}

- (UIColor *)getSelectedStrokeColor
{
    UIColor *strokeColor;
    
    switch (self.buttonStyle)
    {
        case ButtonStyleOrange:
        case ButtonStyleLogin:
        case ButtonStyleForgotPassword:
        case ButtonStyleBeige:
        case ButtonStyleArticle:
        case ButtonStyleCancel:
            strokeColor = nil;
            break;
            
        case ButtonStyleGreen:
            strokeColor = [UIColor colorWithHexString:COLOR_GREEN_BUTTON_BORDER];
            break;
            
        case ButtonStyleBrown:
            strokeColor = [UIColor colorWithHexString:COLOR_BROWN_BUTTON_BORDER];
            break;
            
        case ButtonStyleEdit:
            strokeColor = [UIColor whiteColor];
            break;
            
        case ButtonStyleAdd:
            strokeColor = [UIColor colorWithHexString:COLOR_ADD_BUTTON_BORDER_SELECTED];
            break;
            
        default:
            break;
    }
    
    return strokeColor;
}

- (UIColor *)getHighlightedStrokeColor
{
    UIColor *strokeColor;
    
    switch (self.buttonStyle)
    {
        case ButtonStyleOrange:
        case ButtonStyleLogin:
        case ButtonStyleForgotPassword:
        case ButtonStyleBeige:
        case ButtonStyleArticle:
        case ButtonStyleCancel:
            strokeColor = nil;
            break;
            
        case ButtonStyleGreen:
            strokeColor = [UIColor colorWithHexString:COLOR_GREEN_BUTTON_BORDER];
            break;
            
        case ButtonStyleBrown:
            strokeColor = [UIColor colorWithHexString:COLOR_BROWN_BUTTON_BORDER];
            break;
            
        case ButtonStyleEdit:
            strokeColor = [UIColor whiteColor];
            break;
            
        case ButtonStyleAdd:
            strokeColor = [UIColor colorWithHexString:COLOR_ADD_BUTTON_BORDER_SELECTED];
            break;
            
        default:
            break;
    }
    
    return strokeColor;
}

- (CGFloat)getCornerRadius
{
    CGFloat cornerRadius = 0;
    
    switch (self.buttonStyle)
    {
        case ButtonStyleOrange:
        case ButtonStyleLogin:
        case ButtonStyleForgotPassword:
        case ButtonStyleBeige:
            cornerRadius = 0;
            break;
           
        case ButtonStyleAdd:
        case ButtonStyleGreen:
        case ButtonStyleBrown:
        case ButtonStyleCancel:
            cornerRadius = 5;
            break;
            
        case ButtonStyleArticle:
        case ButtonStyleEdit:
            cornerRadius = 4;
            break;
            
        default:
            break;
    }
    
    return cornerRadius;
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    
    [self setNeedsDisplay];
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    [self setNeedsDisplay];
}


/*
- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx
{
    layer.backgroundColor = [self getBackgroundColor].CGColor;
    layer.opacity = 0.5;
   // layer.cornerRadius = 5;
}*/


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    UIBezierPath *bPath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:[self getCornerRadius]];
    
    UIColor *backgroundColor;
    
    if(self.selected)
        backgroundColor = [self getSelectedBackgroundColor];
    else if(self.highlighted)
        backgroundColor = [self getHighlightedBackgroundColor];
    else
        backgroundColor = [self getBackgroundColor];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(context);
    CGContextSetFillColorWithColor(context, backgroundColor.CGColor);
    CGContextSetAlpha(context, [self getAlpha]);
    CGContextAddPath(context, bPath.CGPath);
    CGContextClip(context);
    CGContextAddPath(context, bPath.CGPath);
    CGContextFillPath(context);
    CGContextRestoreGState(context);
    
    UIColor *strokeColor;
    
    if(self.selected)
        strokeColor = [self getSelectedStrokeColor];
    else if(self.highlighted)
        strokeColor = [self getHighlightedStrokeColor];
    else
        strokeColor = [self getStrokeColor];
    
    if(strokeColor)
    {
        CGContextSaveGState(context);
        CGContextSetLineWidth(context, 2);
        CGContextSetStrokeColorWithColor(context, strokeColor.CGColor);
        CGContextAddPath(context, bPath.CGPath);
        CGContextClip(context);
        CGContextAddPath(context, bPath.CGPath);
        CGContextStrokePath(context);
        CGContextRestoreGState(context);
    }
}


@end
