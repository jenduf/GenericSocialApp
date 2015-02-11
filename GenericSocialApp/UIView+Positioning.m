#import "UIView+Positioning.h"


@implementation UIView (Positioning)

- (void)centerInRect:(CGRect)rect
{
	[self setCenter:CGPointMake(floorf(CGRectGetMidX(rect)) + ((int)floorf([self width]) % 2 ? .5 : 0) , floorf(CGRectGetMidY(rect)) + ((int)floorf([self height]) % 2 ? .5 : 0))];
}

- (void)centerVerticallyInRect:(CGRect)rect
{
	[self centerVerticallyInRect:rect withPadding:0];
}

- (void)centerVerticallyInRect:(CGRect)rect withPadding:(CGFloat)padding
{
    [self setCenter:CGPointMake([self center].x + padding, (floorf(CGRectGetMidY(rect)) + ((int)floorf([self height]) % 2 ? .5 : 0)) + padding)];
}

- (void)centerHorizontallyInRect:(CGRect)rect
{
	[self setCenter:CGPointMake(floorf(CGRectGetMidX(rect)) + ((int)floorf([self width]) % 2 ? .5 : 0), [self center].y)];
}

- (void)bottomAlignVertically
{
    [self setRight:self.superview.right];
    [self setBottom:self.superview.bottom];
}

- (void)centerInSuperView
{
	[self centerInRect:[[self superview] bounds]];
}

- (void)centerVerticallyInSuperView
{
	[self centerVerticallyInRect:[[self superview] bounds]];
}

- (void)centerHorizontallyInSuperView
{
	[self centerHorizontallyInRect:[[self superview] bounds]];
}

- (void)rightAlignInSuperView
{
    [self rightAlignInSuperViewWithPadding:0 handleVertical:NO];
}

- (void)alignWithHorizontalAlignmentType:(UIControlContentHorizontalAlignment)horizontalType andVerticalAlignmentType:(UIControlContentVerticalAlignment)verticalType
{
    switch (horizontalType)
    {
        case UIControlContentHorizontalAlignmentCenter:
            
            break;
            
        case UIControlContentHorizontalAlignmentRight:
            [self rightAlignInSuperView];
            break;
            
        
            
        default:
            break;
    }
    
    switch (verticalType)
    {
        case UIControlContentVerticalAlignmentBottom:
            [self bottomAlignVertically];
            break;
            
        default:
            break;
    }
}

- (void)rightAlignInSuperViewWithPadding:(CGFloat)padding
{
    [self rightAlignInSuperViewWithPadding:padding handleVertical:NO];
}

- (void)rightAlignInSuperViewWithPadding:(CGFloat)padding handleVertical:(BOOL)handleVertical
{
    [self rightAlignInRect:[[self superview] bounds] padding:padding handleVertical:handleVertical];
}

- (void)leftAlignInSuperViewWithPadding:(CGFloat)padding verticalPosition:(UIControlContentVerticalAlignment)verticalPosition
{
    [self leftAlignInRect:[[self superview] bounds] padding:padding verticalPosition:verticalPosition];
}

- (void)leftAlignInRect:(CGRect)rect padding:(CGFloat)padding verticalPosition:(UIControlContentVerticalAlignment)verticalPosition
{
    [self setLeft:padding];
    
    switch(verticalPosition)
    {
        case UIControlContentVerticalAlignmentCenter:
            [self centerVerticallyInSuperView];
            break;
            
        case UIControlContentVerticalAlignmentBottom:
            [self setBottom:(CGRectGetMaxY(rect))];
            break;
            
        case UIControlContentVerticalAlignmentTop:
            [self setTop:0];
            break;
            
        default:
            break;
    }
}

- (void)rightAlignInSuperViewWithPadding:(CGFloat)padding verticalPosition:(UIControlContentVerticalAlignment)verticalPosition
{
    [self rightAlignInRect:[[self superview] bounds] padding:padding verticalPosition:verticalPosition];
}

- (void)rightAlignInRect:(CGRect)rect padding:(CGFloat)padding
{
    [self rightAlignInRect:rect padding:padding handleVertical:NO];
}

- (void)rightAlignInRect:(CGRect)rect padding:(CGFloat)padding handleVertical:(BOOL)handleVertical
{
    if(handleVertical)
        [self rightAlignInRect:rect padding:padding verticalPosition:UIControlContentVerticalAlignmentCenter];
    else
        [self setRight:(CGRectGetMaxX(rect) - padding)];
}

- (void)rightAlignInRect:(CGRect)rect padding:(CGFloat)padding verticalPosition:(UIControlContentVerticalAlignment)verticalPosition
{
    [self setRight:(CGRectGetMaxX(rect) - padding)];
    
    switch(verticalPosition)
    {
        case UIControlContentVerticalAlignmentCenter:
            [self centerVerticallyInSuperView];
            break;
            
        case UIControlContentVerticalAlignmentBottom:
            [self setBottom:(CGRectGetMaxY(rect) - padding)];
            break;
            
        case UIControlContentVerticalAlignmentTop:
            [self setTop:0];
            break;
            
        default:
            break;
    }
}

- (void)rightAlignToTheLeftOf:(UIView *)view
{
    [self rightAlignToTheLeftOf:view padding:0];
}

- (void)rightAlignToTheLeftOf:(UIView *)view padding:(CGFloat)padding
{
    [self setRight:(view.left - padding)];
}

- (void)leftAlignInRect:(CGRect)rect padding:(CGFloat)padding handleVertical:(BOOL)handleVertical
{
    if(handleVertical)
        [self centerVerticallyInRect:rect withPadding:padding];
    
    [self setLeft:(CGRectGetMinX(rect) + padding)];
}

- (void)leftAlignInSuperView
{
    [self leftAlignInSuperViewWithPadding:0 handleVertical:NO];
}

- (void)leftAlignInSuperViewWithPadding:(CGFloat)padding handleVertical:(BOOL)handleVertical
{
    [self leftAlignInRect:[[self superview] bounds] padding:padding handleVertical:handleVertical];
}

- (void)leftAlignAbove:(UIView *)view
{
    [self leftAlignAbove:view padding:0];
}

- (void)leftAlignAbove:(UIView *)view padding:(CGFloat)padding
{
     [self setOrigin:CGPointMake(view.left, floorf(view.top - self.height - padding))];
}

- (void)leftAlignBelow:(UIView *)view
{
    [self leftAlignBelow:view padding:0];
}

- (void)leftAlignBelow:(UIView *)view padding:(CGFloat)padding
{
    [self setOrigin:CGPointMake(view.left, floorf(padding + CGRectGetMaxY([view frame]) + ([self height] / 2)))];
}

- (void)centerHorizontallyBelow:(UIView *)view padding:(CGFloat)padding
{
    // for now, could use screen relative positions.
	NSAssert([self superview] == [view superview], @"views must have the same parent");
  
	[self setCenter:CGPointMake([view center].x,
                              floorf(padding + CGRectGetMaxY([view frame]) + ([self height] / 2)))];
}

- (void)centerHorizontallyBelow:(UIView *)view
{
	[self centerHorizontallyBelow:view padding:0];
}

- (void)rightAlignAbove:(UIView *)view padding:(CGFloat)padding
{
    [self setRight:(CGRectGetMaxX(view.frame) - padding)];
    
    [self setBottom:(CGRectGetMinY(view.frame) - padding)];
}

- (void)centerHorizontallyAbove:(UIView *)view padding:(CGFloat)padding
{
	[self setCenter:CGPointMake(view.center.x, floorf(CGRectGetMinY(view.frame) - (self.height / 2) - padding))];
}

- (void)centerHorizontallyAbove:(UIView *)view
{
	[self centerHorizontallyAbove:view padding:0];
}




- (void)centerVerticallyToTheRightOf:(UIView *)view padding:(CGFloat)padding
{
	[self setCenter:CGPointMake(floorf(padding + CGRectGetMaxX([view frame]) + ([self width] / 2)), [view center].y)];
}

- (void)centerVerticallyToTheRightOf:(UIView *)view
{
	[self centerVerticallyToTheRightOf:view padding:0];
}

- (void)centerVerticallyToTheLeftOf:(UIView *)view padding:(CGFloat)padding
{
	[self setCenter:CGPointMake(floorf(CGRectGetMinX([view frame])) - (self.width / 2) - padding, [view center].y)];
}

- (void)centerVerticallyToTheLeftOf:(UIView *)view
{
	[self centerVerticallyToTheLeftOf:view padding:0];
}

- (void)removeAllSubviewsFromView
{
	for (UIView *subview in self.subviews)
		[subview removeFromSuperview];
}

@end
