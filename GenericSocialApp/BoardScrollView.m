//
//  BoardScrollView.m
//  PeggSite
//
//  Created by Jennifer Duffey on 5/29/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import "BoardScrollView.h"
#import "WhiteBoxView.h"
#import "EmptyArticleView.h"
#import "MediaContentView.h"

@implementation BoardScrollView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        self.delegate = self;
    
        self.placeholders = [[NSMutableArray alloc] init];
        self.media = [[NSMutableArray alloc] init];
        
        self.backgroundColor = [UIColor clearColor];
        
        [self drawShadow];
        
        [self drawBackgroundLayer];
        
       // [self addSubview:shadowImageView];
    }
    
    return self;
}

- (void)layoutSubviews
{
    self.shadowLayer.frame = CGRectMake(SHADOW_OFFSET, self.height - SHADOW_HEIGHT - SMALL_GAP, SHADOW_WIDTH, SHADOW_HEIGHT);
    
    self.backgroundLayer.frame = CGRectMake(PADDING, PADDING, MAX(self.width + ARTICLE_OFFSET, self.contentSize.width) - ARTICLE_OFFSET, self.height - BOARD_BOTTOM_OFFSET);
    
    [super layoutSubviews];
}

- (void)drawShadow
{
    if(!self.shadowLayer)
    {
        UIImage *shadowImage = [UIImage imageNamed:IMAGE_BOARD_SHADOW];
    
        self.shadowLayer = [CALayer layer];
        [self.shadowLayer setContents:(id)shadowImage.CGImage];
    
        [self.layer insertSublayer:self.shadowLayer atIndex:0];
    }
}

- (void)drawBackgroundLayer
{
    if(!self.backgroundLayer)
    {
        self.backgroundLayer = [CAShapeLayer layer];
        self.backgroundLayer.cornerRadius = BOARD_BACKGROUND_CORNER_RADIUS;
        self.backgroundLayer.backgroundColor = [UIColor whiteColor].CGColor;
        [self.layer insertSublayer:self.backgroundLayer atIndex:1];
    }
}

- (Region *)getAvailableRegion
{
    for(EmptyArticleView *emptyArticleView in self.placeholders)
    {
        if(!emptyArticleView.region.article)
            return emptyArticleView.region;
    }
    
    return nil;
}

- (Region *)getOccupiedRegion
{
    for(EmptyArticleView *emptyArticleView in self.placeholders)
    {
        if(emptyArticleView.region.article)
            return emptyArticleView.region;
    }
    
    return nil;
}

- (void)setEditMode:(BOOL)editMode
{
    _editMode = editMode;
    
    for(MediaContentView *mcv in self.media)
    {
        [mcv setEditMode:editMode];
        
        if(editMode)
        {
            //if(mcv.article.articleTypeID == ArticleTypeText)
              //  mcv.mediaTextView.editable = YES;
            
            UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(crop:)];
            doubleTap.numberOfTapsRequired = 2;
            mcv.gestureRecognizers = nil;
            [mcv addGestureRecognizer:doubleTap];
            
            UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressed:)];
            [mcv addGestureRecognizer:longPress];
        }
        else
        {
           // if(mcv.article.articleTypeID == ArticleTypeText)
             //   mcv.mediaTextView.editable = NO;
            
            if(mcv != self.selectedMediaContentView)
            {
                mcv.gestureRecognizers = nil;
                UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mediaTapped:)];
                [mcv addGestureRecognizer:tapRecognizer];
            }
        }
    }
}

- (void)addPlaceholdersForRegions:(NSArray *)regions
{
   // [self removeAllSubviewsFromView];
    
    for(EmptyArticleView *eView in self.placeholders)
    {
        [eView removeFromSuperview];
    }
    
    for(MediaContentView *mView in self.media)
    {
        [mView removeFromSuperview];
    }
    
    [self.placeholders removeAllObjects];
    
    [self.media removeAllObjects];
    
    NSSortDescriptor *ascendingSort = [[NSSortDescriptor alloc] initWithKey:@"regionNumber" ascending:YES];
    
    NSArray *sortedRegions = [NSArray arrayWithArray:[regions sortedArrayUsingDescriptors:@[ascendingSort]]];
    
    float nextX = ARTICLE_OFFSET;
    float nextY = ARTICLE_OFFSET;
    float nextWidth = MEDIA_WIDTH;
    float nextHeight = self.height - (ARTICLE_OFFSET + BOARD_BOTTOM_OFFSET);

    for(Region *region in sortedRegions)
    {
        EmptyArticleView *emptyArticleView = [[EmptyArticleView alloc] initWithRegion:region andFrame:CGRectMake(nextX, nextY, nextWidth, nextHeight)];
        [self addSubview:emptyArticleView];
        
        [self.placeholders addObject:emptyArticleView];
        
        if(region.regionNumber == 2 || region.regionNumber == 5 || region.regionNumber == 7)
        {
            nextY = (emptyArticleView.bottom + PADDING);
        }
        else
        {
            nextX += (nextWidth + PADDING);
            nextY = ARTICLE_OFFSET;
        }
        
        nextWidth = ((region.regionNumber == 3 || region.regionNumber == 8) ? MEDIA_WIDTH : SMALL_ARTICLE_SIZE);
        nextHeight = ((region.regionNumber == 3 || region.regionNumber == 8) ? (self.height - (ARTICLE_OFFSET + BOARD_BOTTOM_OFFSET)) : (self.height - (BOARD_BOTTOM_OFFSET + ARTICLE_OFFSET)) / 2 - SMALL_PADDING);
    }
    
    [self setContentSize:CGSizeMake(nextX + PADDING, self.height)];
    
    [self loadMediaContent];
}

- (void)loadMediaContent
{
    for(EmptyArticleView *emptyArticleView in self.placeholders)
    {
        if(emptyArticleView.region.article)
        {
            MediaContentView *mediaContentView = [[MediaContentView alloc] initWithFrame:emptyArticleView.frame];
            mediaContentView.delegate = self;
            [mediaContentView setArticle:emptyArticleView.region.article];
           // mediaContentView.mediaTextView.delegate = self;
            
            UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mediaTapped:)];
            [mediaContentView addGestureRecognizer:tapRecognizer];
            
            [self addSubview:mediaContentView];
            
            [self.media addObject:mediaContentView];
        }
    }
}


- (NSInteger)getRegionForPage:(NSInteger)page
{
    NSInteger regionNumber = 0;
    
    switch (page)
    {
        case 0:
            regionNumber = 1;
            break;
            
        case 1:
            regionNumber = 2;
            break;
            
        case 2:
            regionNumber = 4;
            break;
            
        case 3:
            regionNumber = 5;
            break;
            
        case 4:
            regionNumber = 7;
            break;
            
        case 5:
            regionNumber = 9;
            break;
            
        default:
            break;
    }
    
    return regionNumber;
}

- (void)scrollToRegionNumber:(NSInteger)regionNumber animated:(BOOL)animated
{
    for(EmptyArticleView *eav in self.placeholders)
    {
        if(eav.region.regionNumber == regionNumber)
        {
            [self setContentOffset:CGPointMake(eav.left - ((self.width - eav.width) / 2), 0) animated:animated];
        }
    }
}

- (void)setContentSize:(CGSize)contentSize
{
    [super setContentSize:contentSize];
    
    [self setNeedsLayout];
    
    //[self.backgroundLayer setFrame:CGRectInset(CGRectMake(self.left, self.top, self.contentSize.width, self.height), SMALL_PADDING, 0)];
    
   // self.backgroundLayer.frame = CGRectMake(PADDING, PADDING, self.contentSize.width - ARTICLE_OFFSET, self.height - BOARD_BOTTOM_OFFSET);
}

- (void)changeScrollBarColor
{
    for(UIView *v in self.subviews)
    {
        //NSLog(@"SCROLL VIEW TAG: %li", (long)v.tag);
        
        if(v.tag == 0 && [v isKindOfClass:[UIImageView class]])
        {
            //NSLog(@" ------- %f - %f - %f - %f", v.left, v.top, v.width, v.height);
            
            UIImageView *imageView = (UIImageView *)v;
            imageView.backgroundColor = [UIColor clearColor];
        }
    }
}

- (void)mediaTapped:(UITapGestureRecognizer *)recognizer
{
    MediaContentView *mcv = (MediaContentView *)recognizer.view;
    
    [self.boardScrollDelegate boardScrollView:self didRequestViewMedia:mcv];
}

- (void)crop:(UIGestureRecognizer *)recognizer
{
    MediaContentView *mcv = (MediaContentView *)recognizer.view;
    
    if(mcv.article.articleTypeID == ArticleTypeText)
    {
         [self.boardScrollDelegate boardScrollView:self didRequestEditArticle:mcv.article];
    }
    else
    {
        //  mcv.mediaImageView.clipsToBounds = NO;
    
        //  [mcv.mediaImageView sizeToFit];
    
        [self scrollToRegionNumber:mcv.article.regionNumber animated:YES];
    
        //  [self setContentOffset:CGPointMake(mcv.left - BOARD_PADDING, 0)];
    
        [self.boardScrollDelegate boardScrollView:self didRequestCropMedia:mcv];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(CGRectMake(rect.origin.x, rect.origin.y, self.contentSize.width, rect.size.height), PADDING, PADDING) cornerRadius:BOARD_BACKGROUND_CORNER_RADIUS];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(context);
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextAddPath(context, bezierPath.CGPath);
    CGContextDrawPath(context, kCGPathFill);
    CGContextRestoreGState(context);
}
*/

- (void)longPressed:(UILongPressGestureRecognizer *)recognizer
{
 //   [self setEditMode:NO];
    
     self.selectedMediaContentView = (MediaContentView *)recognizer.view;
    
    if(recognizer.state == UIGestureRecognizerStateBegan || recognizer.state == UIGestureRecognizerStateChanged)
    {
        [UIView animateWithDuration:0.2 animations:^
         {
             self.selectedMediaContentView.alpha = 0.8;
             self.selectedMediaContentView.transform =
             CGAffineTransformConcat(CGAffineTransformMakeScale(0.9, 0.9), CGAffineTransformMakeRotation(RADIANS(-2.0)));
             
         }
        completion:^(BOOL finished)
         {
             
         }];
        
        self.selectedMediaContentView.center = [recognizer locationInView:self];
        
        [self bringSubviewToFront:self.selectedMediaContentView];
    }
    
    // autoscroll
    if(recognizer.state == UIGestureRecognizerStateChanged)
    {
        CGPoint loc = [recognizer locationInView:self];
        CGRect f = self.bounds;
        CGPoint off = self.contentOffset;
        CGSize sz = self.contentSize;
        CGPoint c = self.selectedMediaContentView.center;
        
        // to the right
        if(loc.x > CGRectGetMaxX(f) - 30)
        {
            CGFloat margin = sz.width - CGRectGetMaxX(self.bounds);
            
            if(margin > 6)
            {
                off.x += 5;
                self.contentOffset = off;
                c.x += 5;
                self.selectedMediaContentView.center = c;
                [self keepDragging:recognizer];
            }
        }
        
        // to the left
        if(loc.x < f.origin.x + 30)
        {
            CGFloat margin = off.x;
            if(margin > 6)
            {
                off.x -= 5;
                self.contentOffset = off;
                c.x -= 5;
                self.selectedMediaContentView.center = c;
                [self keepDragging:recognizer];
            }
        }
        
        // to the bottom
        if(loc.y > CGRectGetMaxY(f) - 30)
        {
            CGFloat margin = sz.height - CGRectGetMaxY(self.bounds);
            if(margin > 6)
            {
                
            }
        }
        
        // to the top
        if(loc.y < f.origin.y + 30)
        {
            CGFloat margin = off.y;
            if(margin > 6)
            {
                
            }
        }
        
        [self checkForActive];
    }
    
    if(recognizer.state == UIGestureRecognizerStateEnded)
    {
        [UIView animateWithDuration:0.2 animations:^
         {
             self.selectedMediaContentView.alpha = 1.0;
             self.selectedMediaContentView.transform =
             CGAffineTransformIdentity;
             
         }
        completion:^(BOOL finished)
         {
             
         }];
        
        [self checkForMatch];
    }
    
    /*
    
    if(recognizer.state == UIGestureRecognizerStateBegan)
    {
        self.selectedMediaContentView = (MediaContentView *)recognizer.view;
        
        self.originalFrame = self.selectedMediaContentView.frame;
        
        [UIView animateWithDuration:0.2 animations:^
         {
             self.selectedMediaContentView.alpha = 0.8;
             self.selectedMediaContentView.transform =
             CGAffineTransformConcat(CGAffineTransformMakeScale(0.9, 0.9), CGAffineTransformMakeRotation(RADIANS(-2.0)));
             
         }
        completion:^(BOOL finished)
         {
             
         }];
        
        self.selectedMediaContentView.center = [recognizer locationInView:self];
        
        [self bringSubviewToFront:self.selectedMediaContentView];
        
        return;
    }
    
    if(recognizer.state == UIGestureRecognizerStateChanged)
    {
        NSInteger xDelta = self.selectedMediaContentView.center.x - [recognizer locationInView:self].x;
        self.selectedMediaContentView.center = [recognizer locationInView:self];
        
        [self scrollIfNeeded:[recognizer locationInView:self.superview] withDelta:xDelta];
        
        [self checkForActive];
    }
    
    if(recognizer.state == UIGestureRecognizerStateEnded)
    {
        [UIView animateWithDuration:0.2 animations:^
         {
             self.selectedMediaContentView.alpha = 1.0;
             self.selectedMediaContentView.transform =
             CGAffineTransformIdentity;
             
         }
        completion:^(BOOL finished)
         {
             
         }];
        
        [self checkForMatch];
    }
    
    
    if(recognizer.state == UIGestureRecognizerStateEnded)
    {
        CGPoint matchPoint = [recognizer locationInView:self];
        
        MediaContentView *matchedView = nil;
        
        EmptyArticleView *emptyArticleView = nil;
        
        for(MediaContentView *mcv in self.media)
        {
            if(CGRectContainsPoint(mcv.frame, matchPoint))
            {
                matchedView = mcv;
                [matchedView setActive:YES];
                [self.selectedMediaContentView setFrame:matchedView.frame];
                [matchedView setFrame:self.originalFrame];
                NSLog(@"MATCHED");
                break;
            }
        }
        
        if(!matchedView)
        {
            for(EmptyArticleView *eav in self.placeholders)
            {
                if(CGRectContainsPoint(eav.frame, matchPoint))
                {
                    emptyArticleView = eav;
                    [emptyArticleView setActive:YES];
                    [self.selectedMediaContentView setFrame:emptyArticleView.frame];
                    NSLog(@"Matched Empty");
                    break;
                }
            }
        }
     
     self.selectedMediaContentView = nil;
    }
     */
}

- (void)keepDragging:(UILongPressGestureRecognizer *)recognizer
{
    float delay = 0.1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delay * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^
    {
        [self longPressed:recognizer];
    });
}

- (void)checkForActive
{
    for(EmptyArticleView *eav in self.placeholders)
    {
        if(CGRectContainsPoint(eav.frame, self.selectedMediaContentView.center))
        {
            [eav setActive:YES];
        }
        else
        {
            [eav setActive:NO];
        }
    }
    
    for(MediaContentView *mcv in self.media)
    {
        if(![mcv.article.articleID isEqualToString:self.selectedMediaContentView.article.articleID])
        {
            if(CGRectContainsPoint(mcv.frame, self.selectedMediaContentView.center))
            {
                [mcv setActive:YES];
            }
            else
            {
                [mcv setActive:NO];
            }
        }
    }
}

- (CGFloat)getCurrentPageWidth
{
    if(self.currentPage == 0 || self.currentPage == 2 || self.currentPage == 3 || self.currentPage == 5)
        return SMALL_PAGE_GAP;
    
    return PAGE_GAP;
}

- (void)checkForMatch
{
    BOOL foundMatch = NO;
    
    for(MediaContentView *mcv in self.media)
    {
        if(![mcv.article.articleID isEqualToString:self.selectedMediaContentView.article.articleID])
        {
            if(CGRectContainsPoint(mcv.frame, self.selectedMediaContentView.center))
            {
                [self.selectedMediaContentView setFrame:mcv.frame];
                [mcv setFrame:self.originalFrame];
                mcv.active = NO;
                foundMatch = YES;
                NSInteger regionNumber = self.selectedMediaContentView.article.regionNumber;
                self.selectedMediaContentView.article.regionNumber = mcv.article.regionNumber;
                mcv.article.regionNumber = regionNumber;
                NSArray *articles = @[self.selectedMediaContentView.article, mcv.article];
                //[self.boardScrollDelegate boardScrollView:self didRequestUpdateArticle:self.selectedMediaContentView.article];
                //[self.boardScrollDelegate boardScrollView:self didRequestUpdateArticle:mcv.article];
                [self.boardScrollDelegate boardScrollView:self didRequestUpdateArticles:articles];
                break;
            }
        }
    }
    
    if(!foundMatch)
    {
        for(EmptyArticleView *eav in self.placeholders)
        {
            if(CGRectContainsPoint(eav.frame, self.selectedMediaContentView.center))
            {
                [self.selectedMediaContentView setFrame:eav.frame];
                eav.active = NO;
                foundMatch = YES;
                self.selectedMediaContentView.article.regionNumber = eav.region.regionNumber;
                [self.boardScrollDelegate boardScrollView:self didRequestUpdateArticle:self.selectedMediaContentView.article];
                break;
            }
        }
    }
    
    if(!foundMatch)
    {
        [self.selectedMediaContentView setFrame:self.originalFrame];
    }
}

- (void)scrollIfNeeded:(CGPoint)locationInScrollSuperview withDelta:(NSInteger)xDelta
{
    UIView *scrollSuperview = self.superview;
    CGRect bounds = scrollSuperview.bounds;
    CGPoint scrollOffset = self.contentOffset;
    NSInteger xOfs = 0;
    NSInteger speed = 10;
    
    if((locationInScrollSuperview.x > bounds.size.width * 0.7) && (xDelta < 0))
    {
        xOfs = speed * locationInScrollSuperview.x / bounds.size.width;
    }
    
    if((locationInScrollSuperview.x < bounds.size.width * 0.3) && (xDelta > 0))
    {
        xOfs = -speed * (1.0f - locationInScrollSuperview.x / bounds.size.width);
    }
    
    if(xOfs < 0)
    {
        if(scrollOffset.x == 0)
            return;
        
        if(xOfs < -scrollOffset.x)
            xOfs = -scrollOffset.x;
    }
    
    scrollOffset.x += xOfs;
    
    CGRect rect = CGRectMake(scrollOffset.x, 0, self.width, self.height);
    [self scrollRectToVisible:rect animated:NO];
    
    CGPoint center = self.selectedMediaContentView.center;
    center.x += xOfs;
    self.selectedMediaContentView.center = center;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self changeScrollBarColor];
    
    [UIView animateWithDuration:0.2 animations:^
    {
        //[self.scrollBackgroundView setAlpha:0.4];
    }];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if(!self.editMode)
    {
        CGFloat pageWidth = [self getCurrentPageWidth];
        
        self.currentPage = floor((self.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        
        NSLog(@"Dragging - You are now on page %li", (long)self.currentPage);
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    
    if(!self.editMode)
    {
        CGFloat pageWidth = [self getCurrentPageWidth];
        NSInteger newPage = 0;
        
        // slow dragging not lifting finger
        if(velocity.x == 0)
        {
            newPage = floor((targetContentOffset->x - pageWidth / 2) / pageWidth) + 1;
        }
        else
        {
            newPage = velocity.x > 0 ? self.currentPage + 1 : self.currentPage - 1;
            
            if(newPage < 0)
                newPage = 0;
            
            if(newPage > self.contentSize.width / pageWidth)
                newPage = ceil(self.contentSize.width / pageWidth) - 1.0;
        }
        
        NSLog(@"Dragging - You will be on %li page (from page %li)", (long)newPage, (long)self.currentPage);
        
        *targetContentOffset = CGPointMake(newPage * pageWidth, targetContentOffset->y);
        
        [self.boardScrollDelegate boardScrollView:self didChangePage:newPage];
        
        self.currentPage = newPage;
        
        [UIView animateWithDuration:0.2 animations:^
         {
             //[self.scrollBackgroundView setAlpha:0.0];
         }];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if(!self.editMode)
    {
        [self scrollToRegionNumber:[self getRegionForPage:self.currentPage] animated:YES];
    
        [UIView animateWithDuration:0.2 animations:^
         {
         
         }];
    }
}

#pragma mark -
#pragma mark - MediaContentView Delegate Methods
- (void)mediaContentViewBeganDragging:(MediaContentView *)mediaContentView
{
    self.originalFrame = mediaContentView.frame;
    
    NSLog(@"Began dragging");
}

- (void)mediaContentView:(MediaContentView *)mediaContentView isMovingToNewLocation:(CGPoint)newLocation withDelta:(CGFloat)delta
{
    CGPoint offset = self.contentOffset;
    CGPoint newCenter = mediaContentView.center;
    
    CGFloat RIGHT_MAX = (APP_WIDTH - ARTICLE_OFFSET);
    CGFloat LEFT_MAX = ARTICLE_OFFSET;
    
    // to the right
    if(newLocation.x > RIGHT_MAX)
    {
        CGFloat margin = self.contentSize.width - APP_WIDTH;
       
        if(margin > 6)
        {
            offset.x += 5;
            self.contentOffset = offset;
            
            newCenter.x += 5;
            mediaContentView.center = newCenter;
            
            // self keepDragging
        }
    }
    
    // to the left
    if(newLocation.x < LEFT_MAX)
    {
        CGFloat margin = offset.x;
        if(margin > 6)
        {
            offset.x -= 5;
            self.contentOffset = offset;
            
            newCenter.x -= 5;
            mediaContentView.center = newCenter;
        }
    }
    
        
        //self.contentOffset = CGPointMake(offset.x + 5, offset.y);
        
        /*
        CGFloat margin = self.contentSize.width - CGRectGetMaxX(self.bounds);
        if(margin > 6)
        {
            offset.x += 5;
            self.contentOffset = offset;
          //  [mediaContentView setCenter:CGPointMake(mediaContentView.center.x + 5, mediaContentView.center.y)];
           // [self keepDragging];
        }
         */
   // }
    
    // to the left
 //   if(newLocation.x < LEFT_MAX)
   // {
     //   self.contentOffset = CGPointMake(offset.x - 5, offset.y);
   // }
}

- (void)mediaContentView:(MediaContentView *)mediaContentView didMoveToLocation:(CGPoint)newLocation
{
    EmptyArticleView *emptyArticleView = nil;
    
    for(EmptyArticleView *eav in self.placeholders)
    {
        if(CGRectContainsPoint(eav.frame, newLocation))
        {
            emptyArticleView = eav;
            break;
        }
    }
    
    // check if match was found
    if(emptyArticleView != nil)
    {
        //[mediaContentView setActive:YES];
                
        [UIView animateWithDuration:0.35 delay:0.2 options:0 animations:^
        {
            mediaContentView.center = emptyArticleView.center;
            mediaContentView.transform = CGAffineTransformIdentity;
        }
        completion:^(BOOL finished)
        {
            [mediaContentView setActive:NO];
        }];
    }
    
    NSLog(@"Original Frame: %@", NSStringFromCGRect(self.originalFrame));
    
   // [mediaContentView setFrame:self.originalFrame];
    
   // [self scrollRectToVisible:self.originalFrame animated:YES];
}

- (void)mediaContentView:(MediaContentView *)mediaContentView didRequestDeleteArticle:(Article *)article
{
    self.selectedMediaContentView = mediaContentView;
    
    [self.boardScrollDelegate boardScrollView:self didRequestDeleteArticle:article];
}

- (void)mediaContentViewDidRequestPlay:(MediaContentView *)mediaContentView
{
    NSLog(@"Maybe allow play from here?");
    
    [self.boardScrollDelegate boardScrollView:self didRequestViewMedia:mediaContentView];
}

/*
#pragma mark -
#pragma mark UITextView Delegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    MediaContentView *mcv = (MediaContentView *)textView.superview.superview;
    
    self.selectedMediaContentView = mcv;
    
   // [self.boardScrollDelegate boardScrollView:self didRequestEditArticle:mcv.article];
    
    return NO;
}*/

@end
