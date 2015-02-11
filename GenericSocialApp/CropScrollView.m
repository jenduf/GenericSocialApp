//
//  CropContentView.m
//  PeggSite
//
//  Created by Jennifer Duffey on 6/18/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import "CropScrollView.h"

@implementation CropScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if(self)
    {
        self.delegate = self;
        
        self.scrollImageView = [[UIImageView alloc] initWithFrame:frame];
        [self addSubview:self.scrollImageView];
    }
    
    return self;
}

#pragma mark -
#pragma mark Override layoutSubviews to center content

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // center the image as it becomes smaller than the size of the screen
    CGSize boundsSize = self.bounds.size;
    CGRect frameToCenter = self.scrollImageView.frame;
    
    // center horizontally
    if(frameToCenter.size.width < boundsSize.width)
        frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
    else
        frameToCenter.origin.x = 0;
    
    // center vertically
    if(frameToCenter.size.height < boundsSize.height)
        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2;
    else
        frameToCenter.origin.y = 0;
    
    self.scrollImageView.frame = frameToCenter;
}

#pragma mark -
#pragma mark UIScrollView delegate methods
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.scrollImageView;
}

#pragma mark -
#pragma mark Configure scrollView to display new image
- (void)displayImage:(UIImage *)image
{
    [self.scrollImageView setImage:image];
    
    [self.scrollImageView sizeToFit];
    
    [self.scrollImageView centerInSuperView];
    
    // reset our zoom scale to 1.0 before doing any further calculations
    self.zoomScale = 1.0;
    
    self.contentSize = image.size;
    
    [self setMaxMinZoomScalesForCurrentBounds];
    
    self.zoomScale = self.minimumZoomScale;
}

- (void)setMaxMinZoomScalesForCurrentBounds
{
    CGSize boundsSize = self.bounds.size;
    CGSize imageSize = self.scrollImageView.bounds.size;
    
    // calculate min/max zoom scale
    CGFloat xScale = boundsSize.width / imageSize.width; // the scale needed to perfectly fit the image width-wise
    CGFloat yScale = boundsSize.height / imageSize.height; // the scale needed to perfectly fit the image height-wise
    CGFloat minScale = MIN(xScale, yScale); // use minimum of these to allow the image to become fully visible
    
    // on high resolution screens we have double the pixel density, so we will be seeing every pixel if we limit the
    // maximum zoom scale to 0.5.
    CGFloat maxScale = 1.0 / [[UIScreen mainScreen] scale];
    
    // don't let minScale exceed maxScale. (If the image is smaller than the screen, we don't want to force it to be zoomed.)
    if(minScale > maxScale)
        minScale = maxScale;
    
    self.maximumZoomScale = maxScale;
    self.minimumZoomScale = minScale;
}

#pragma mark -
#pragma mark Methods called during rotation to preserve the zoomScale and the visible portion of the image

// returns the center point, in image coordinate space, to try to restore after rotation.
- (CGPoint)pointToCenterAfterRotation
{
    CGPoint boundsCenter = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    return [self convertPoint:boundsCenter toView:self.scrollImageView];
}

// returns the zoom scale to attempt to restore after rotation.
- (CGFloat)scaleToRestoreAfterRotation
{
    CGFloat contentScale = self.zoomScale;
    
    // If we're at the minimum zoom scale, preserve that by returning 0, which will be converted to the minimum
    // allowable scale when the scale is restored.
    if(contentScale <= self.minimumZoomScale + FLT_EPSILON)
        contentScale = 0;
    
    return contentScale;
}

- (CGPoint)maximumContentOffset
{
    CGSize contentSize = self.contentSize;
    CGSize boundsSize = self.bounds.size;
    return CGPointMake(contentSize.width - boundsSize.width, contentSize.height - boundsSize.height);
}

- (CGPoint)minimumContentOffset
{
    return CGPointZero;
}

// Adjusts content offset and scale to try to preserve the old zoomscale and center.
- (void)restoreCenterPoint:(CGPoint)oldCenter scale:(CGFloat)oldScale
{
    // Step 1: restore zoom scale, first making sure it is within the allowable range.
    self.zoomScale = MIN(self.maximumZoomScale, MAX(self.minimumZoomScale, oldScale));
    
    // Step 2: restore center point, first making sure it is within the allowable range.
    
    // 2a: convert our desired center point back to our own coordinate space
    CGPoint boundsCenter = [self convertPoint:oldCenter fromView:self.scrollImageView];
    // 2b: calculate the content offset that would yield that center point
    CGPoint offset = CGPointMake(boundsCenter.x - self.bounds.size.width / 2.0, boundsCenter.y - self.bounds.size.height / 2.0);
    // 2c: restore offset, adjusted to be within the allowable range
    CGPoint maxOffset = [self maximumContentOffset];
    CGPoint minOffset = [self minimumContentOffset];
    offset.x = MAX(minOffset.x, MIN(maxOffset.x, offset.x));
    offset.y = MAX(minOffset.y, MIN(maxOffset.y, offset.y));

    self.contentOffset = offset;
}

@end
