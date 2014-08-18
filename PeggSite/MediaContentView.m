//
//  GalleryImageView.m
//  PeggSite
//
//  Created by Jennifer Duffey on 3/7/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import "MediaContentView.h"
#import "PeggTextView.h"
#import "EmptyArticleView.h"

@implementation MediaContentView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        
        self.contentMode = UIViewContentModeScaleAspectFit;
        
        self.layer.masksToBounds = YES;
    }
    
    return self;
}

- (void)setArticle:(Article *)article
{
    _article = article;
    
    CGRect scaledRect = [Utils getScaledSizeWithSourceSize:CGSizeMake(article.sourceWidth, article.sourceHeight) targetSize:self.size isLetterBox:NO];
    
    [self removeAllSubviewsFromView];
    
    switch (self.article.articleTypeID)
    {
        case ArticleTypeImage:
        case ArticleTypeYouTube:
        case ArticleTypeVimeo:
        case ArticleTypeSound:
        {
            self.mediaImageView = [[UIImageView alloc] initWithFrame:scaledRect];
            self.mediaImageView.clipsToBounds = YES;
            [self addSubview:self.mediaImageView];
            [self.mediaImageView centerInSuperView];
            
            if(self.article.articleImage)
            {
                self.mediaImageView.image = self.article.articleImage;
            }
            else
            {
                NSURL *imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PEGGSITE_IMAGE_URL, self.article.source]];
                
                [[SDWebImageManager sharedManager] downloadWithURL:imageURL options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize)
                 {
                     
                 }
                completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished)
                 {
                     self.article.articleImage = image;
                     self.mediaImageView.image = image;
                 }];
            }
            
            
            if(self.article.articleTypeID != ArticleTypeImage)
            {
                NSString *imageName = (self.article.articleTypeID == ArticleTypeSound ? IMAGE_PLAY_AUDIO : IMAGE_PLAY_VIDEO);
                UIImage *playImage = [UIImage imageNamed:imageName];
                UIButton *playButton = [UIButton buttonWithType:UIButtonTypeCustom];
                [playButton setBackgroundImage:playImage forState:UIControlStateNormal];
                [playButton setFrame:CGRectMake(0, 0, playImage.size.width, playImage.size.height)];
                [playButton addTarget:self action:@selector(play:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:playButton];
                
                [playButton centerInSuperView];
            }
            
        }
            break;
            
        case ArticleTypeText:
        {
            UIView *textView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
            [textView setBackgroundColor:[UIColor colorWithHexString:COLOR_TEXT_BACKGROUND]];
            [self addSubview:textView];
            
            self.mediaTextField = [[PeggTextField alloc] initWithFrame:CGRectMake(HEADER_PADDING, HEADER_PADDING, self.width - (HEADER_PADDING * 2), LABEL_HEIGHT)];
            self.mediaTextField.font = [UIFont fontWithName:FONT_PROXIMA_BOLD size:FONT_SIZE_TEXT_BOX];
            self.mediaTextField.text = self.article.caption;
            [textView addSubview:self.mediaTextField];
            [self.mediaTextField sizeToFit];
            
            NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
            paraStyle.lineSpacing = CAPTION_LINE_SPACING;
            paraStyle.lineBreakMode = NSLineBreakByWordWrapping;
            paraStyle.alignment = NSTextAlignmentLeft;
            
            NSDictionary *nameAttributes = @{NSFontAttributeName : [UIFont fontWithName:FONT_PROXIMA_REGULAR size:FONT_SIZE_TEXT_BOX], NSForegroundColorAttributeName : [UIColor colorWithHexString:COLOR_BUTTON_TEXT], NSParagraphStyleAttributeName : paraStyle};
            
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[Utils removeHTMLFromString:self.article.text] attributes:nameAttributes];
            
            //self.backgroundColor = [UIColor colorWithHexString:COLOR_TEXT_BACKGROUND];
            self.mediaTextView = [[PeggTextView alloc] initWithFrame:CGRectMake(PADDING, self.mediaTextField.bottom + SMALL_PADDING, self.width - (PADDING * 2), self.height - self.mediaTextField.bottom - PADDING - HEADER_PADDING) andFontSize:FONT_SIZE_TEXT_BOX];
           // self.mediaTextView.font = [UIFont fontWithName:FONT_PROXIMA_REGULAR size:FONT_SIZE_TEXT_BOX];
           // self.mediaTextView.textColor = [UIColor colorWithHexString:COLOR_BUTTON_TEXT];
           // self.mediaTextView.text = [Utils removeHTMLFromString:self.article.text];
            self.mediaTextView.editable = NO;
            self.mediaTextView.selectable = NO;
            self.mediaTextView.dataDetectorTypes = UIDataDetectorTypeAll;
           // self.mediaTextView.delegate = self;
            [self.mediaTextView setAttributedText:attributedString];
            [textView addSubview:self.mediaTextView];
        }
            break;
            
        case ArticleTypeUnknown:
        default:
            break;
    }
    
    if(article.isNew)
    {
        UIImageView *newImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:IMAGE_NEW_POST]];
        [self addSubview:newImageView];
        [newImageView setTop:0];
        [newImageView setRight:self.width];
    }
    
    UIImage *deleteImage = [UIImage imageNamed:IMAGE_DELETE_ICON];
    self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.closeButton setImage:deleteImage forState:UIControlStateNormal];
    [self.closeButton setFrame:CGRectMake(self.width - self.closeButton.width - DELETE_BUTTON_PADDING, PADDING, deleteImage.size.width, deleteImage.size.height)];
    [self.closeButton addTarget:self action:@selector(deleteArticle:) forControlEvents:UIControlEventTouchUpInside];
    [self.closeButton setHidden:YES];
    [self addSubview:self.closeButton];
}

- (void)setEditMode:(BOOL)editMode
{
    _editMode = editMode;
    
    [self.closeButton setHidden:!editMode];
    
 /*   if(editMode)
   {
     //   UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(crop:)];
     //   doubleTap.numberOfTapsRequired = 2;
     //   self.gestureRecognizers = nil;
      //  [self addGestureRecognizer:doubleTap];
        
     //   UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
     //   [self addGestureRecognizer:panRecognizer];
    }
    else
    {
        self.gestureRecognizers = nil;
    }*/
}



/*
- (void)setCropMode:(BOOL)cropMode
{
    _cropMode = cropMode;
    
    if(cropMode)
    {
        self.cropControlsView = [[CropControlsView alloc] initWithFrame:self.frame];
        [self addSubview:self.cropControlsView];
    }
    else
    {
        [self.cropControlsView removeFromSuperview];
    }
}
 */

/*
- (void)longPress:(UILongPressGestureRecognizer *)longRecognizer
{
    if(longRecognizer.state == UIGestureRecognizerStateBegan || longRecognizer.state == UIGestureRecognizerStateChanged)
    {
        CGPoint point = [longRecognizer locationInView:self];
        [self setCenter:CGPointMake(self.center.x + point.x, self.center.y + point.y)];
        
        CGPoint locationInSuperview = [self convertPoint:CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds)) toView:self.superview];
        [self.delegate mediaContentView:self wasMovedToNewLocation:locationInSuperview];
        CGPoint newLocation = [longRecognizer locationInView:self.superview];
        NSLog(@"locations: %@ %@", NSStringFromCGPoint(locationInSuperview), NSStringFromCGPoint(newLocation));
    }
}
*/

- (void)setActive:(BOOL)active
{
    _active = active;
    
    [self setNeedsDisplay];
}


/*
#pragma mark - Touch Delegate Methods
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"BEGAN");
    
    // save the original location
    self.currentPoint = [[touches anyObject] locationInView:self];
    
    // Promote the touched view
    [self.superview bringSubviewToFront:self];
    
    // Hide close button
    [self.closeButton setHidden:YES];
    
    [UIView animateWithDuration:0.2 animations:^
     {
         // initiate animation for dragging
         self.transform =  CGAffineTransformConcat(CGAffineTransformMakeScale(0.9, 0.9), CGAffineTransformMakeRotation(RADIANS(-2.0)));
         self.alpha = 0.8;
     }
    completion:^(BOOL finished)
     {
         // notify the delegate
         [self.delegate mediaContentViewBeganDragging:self];
     }];
}



- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Get active location upon move
    CGPoint activePoint = [[touches anyObject] locationInView:self];
    
    // determine new point based on where the touch is now located
    CGPoint newPoint = CGPointMake(self.center.x + (activePoint.x - self.currentPoint.x),
                                   self.center.y + (activePoint.y - self.currentPoint.y));
    
    // Make sure we stay within bounds of the parent view
   float midPointX = CGRectGetMidX(self.bounds);
    // if too far right...
    if(newPoint.x > self.superview.bounds.size.width - midPointX)
        newPoint.x = self.superview.bounds.size.width - midPointX;
    else if(newPoint.x < midPointX) // too far left...
        newPoint.x = midPointX;
    
    float midPointY = CGRectGetMidY(self.bounds);
    // if too far down
    if(newPoint.y > self.superview.bounds.size.height - midPointY)
        newPoint.y = self.superview.bounds.size.height - midPointY;
    else if(newPoint.y < midPointY) // if too far up
        newPoint.y = midPointY;
 
    // set new center location
    self.center = newPoint;
    
    // notify delegate
    [self.delegate mediaContentView:self isMovingToNewLocation:newPoint withDelta:self.currentPoint.x];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.closeButton setHidden:NO];
    
    [UIView animateWithDuration:0.1 animations:^
     {
         self.alpha = 1.0;
         self.transform = CGAffineTransformIdentity;
     }];
    
    [self.delegate mediaContentView:self didMoveToLocation:self.center];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.closeButton setHidden:NO];
    
    [UIView animateWithDuration:0.1 animations:^
     {
         self.alpha = 1.0;
         self.transform = CGAffineTransformIdentity;
     }];
}

- (void)handlePan:(UIPanGestureRecognizer *)recognizer
{
    CGPoint translation = [recognizer translationInView:self.superview];
    self.center = CGPointMake(self.previousLocation.x + translation.x, self.previousLocation.y + translation.y);
    
    if(recognizer.state == UIGestureRecognizerStateChanged)
    {
        [self.delegate mediaContentView:self isMovingToNewLocation:translation withDelta:self.center.x];
    }
    else if(recognizer.state == UIGestureRecognizerStateEnded)
    {
        [self.delegate mediaContentView:self didMoveToLocation:translation];
    }
}

    
    CGPoint newCenter = CGPointMake(self.previousLocation.x + translation.x, self.previousLocation.y + translation.y);
     
     // Restrict movement within the parent bounds
     float halfX = CGRectGetMidX(self.bounds);
     newCenter.x = MAX(halfX, newCenter.x);
     newCenter.x = MIN(self.superview.bounds.size.width - halfX, newCenter.x);
     
     float halfY = CGRectGetMidY(self.bounds);
     newCenter.y = MAX(halfY, newCenter.y);
     newCenter.y = MIN(self.superview.bounds.size.height - halfY, newCenter.y);
     
     // set new location
     self.center = newCenter;
}
*/

- (void)play:(id)sender
{
    [self.delegate mediaContentViewDidRequestPlay:self];
}


 - (void)pan:(UIPanGestureRecognizer *)recognizer
{
    switch(recognizer.state)
    {
        case UIGestureRecognizerStateBegan:
        {
            [self.delegate mediaContentViewBeganDragging:self];
            
            [self.superview bringSubviewToFront:self];
            
            [self.closeButton setHidden:YES];
            
            [UIView animateWithDuration:0.2 animations:^
            {
                self.alpha = 0.8;
                self.transform =
                CGAffineTransformConcat(CGAffineTransformMakeScale(0.9, 0.9), CGAffineTransformMakeRotation(RADIANS(-2.0)));
                
            }
            completion:^(BOOL finished)
            {
               
            }];
        }
            break;
 
         case UIGestureRecognizerStateChanged:
         {
             NSLog(@"CHANGED");
             
             CGPoint newPoint = self.center;
             CGPoint delta = [recognizer translationInView:self.superview];
             
             newPoint.x += delta.x;
             
             // set new location
             self.center = newPoint;
             
             [recognizer setTranslation:CGPointZero inView:self.superview];
             
             CGPoint location = [recognizer locationInView:self.superview];
             
             // notify delegate
             [self.delegate mediaContentView:self isMovingToNewLocation:location withDelta:delta.x];
         
         }
            break;
 
 
        case UIGestureRecognizerStateEnded:
        {
            [self.delegate mediaContentView:self didMoveToLocation:self.center];
        }
 
        case UIGestureRecognizerStateCancelled:
        {
            [self.closeButton setHidden:NO];
            
            [UIView animateWithDuration:0.1 animations:^
             {
                 self.alpha = 1.0;
                 self.transform = CGAffineTransformIdentity;
             }];
        }
            break;
            
        default:
            break;
 
    }
}



/*

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    CGPoint pt;
    float halfSide = self.height / 2.0f;
    
    // normalize with centered origin
    pt.x = (point.x - halfSide) / halfSide;
    pt.y = (point.y - halfSide) / halfSide;
    
    float xSquared = pt.x * pt.x;
    float ySquared = pt.y * pt.y;
    
    // if the radius < 1, the point is within the clipped circle
    if((xSquared + ySquared) < 1.0)
        return YES;
    
    return NO;
}*/

- (void)deleteArticle:(id)sender
{
    [self.delegate mediaContentView:self didRequestDeleteArticle:self.article];
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx
{
    if(self.active)
    {
        layer.borderColor = [UIColor colorWithHexString:COLOR_HIGHLIGHT_BORDER].CGColor;
        layer.borderWidth = 4.0;
        layer.cornerRadius = 10.0;
    }
    else if(self.article.regionNumber != 1 && self.article.regionNumber != 4 && self.article.regionNumber != 9)
    {
        layer.cornerRadius = 8.0;
        layer.borderWidth = 0.0;
    }
    else
    {
        layer.borderWidth = 0.0;
        layer.cornerRadius = 0.0;
    }
    
    layer.backgroundColor = [UIColor whiteColor].CGColor;
}

- (void)drawRect:(CGRect)rect
{
    
}

@end
