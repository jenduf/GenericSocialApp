//
//  CropView.m
//  PeggSite
//
//  Created by Jennifer Duffey on 6/10/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import "CropView.h"
#import "CropScrollView.h"

@implementation CropView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        
        // the shade
        self.shadeView = [[ShadeView alloc] initWithFrame:self.frame];
        self.shadeView.userInteractionEnabled = NO;
        
        // the image
        self.cropImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        [self.cropImageView setContentMode:UIViewContentModeScaleAspectFill];
        //self.cropImageView.clipsToBounds = YES;
        self.cropImageView.userInteractionEnabled = YES;
        self.cropImageView.exclusiveTouch = YES;
        
        // scroll view
      //  self.cropScrollView = [[CropScrollView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
      //  self.cropScrollView.exclusiveTouch = YES;
        
        UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panImage:)];
        [self.cropImageView addGestureRecognizer:panRecognizer];
        
       // UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchImage:)];
        //[self.cropImageView addGestureRecognizer:pinchRecognizer];
        
        // the hole
        self.cropAreaView = [[UIView alloc] initWithFrame:CGRectMake(ARTICLE_OFFSET, CROP_OFFSET, MEDIA_WIDTH, MEDIA_HEIGHT)];
        self.cropAreaView.opaque = NO;
        self.cropAreaView.backgroundColor = [UIColor clearColor];
        self.cropAreaView.userInteractionEnabled = NO;
        
        self.cropControlsView = [[CropControlsView alloc] initWithFrame:self.cropAreaView.frame];
        self.cropControlsView.userInteractionEnabled = NO;
        
       
        [self addSubview:self.cropImageView];
     //   [self addSubview:self.cropScrollView];
        [self addSubview:self.shadeView];
        [self addSubview:self.cropAreaView];
        [self addSubview:self.cropControlsView];
        
        self.imageFrameInView = CGRectMake(0, 0, self.width, self.height);
        //self.cropImageView.frame = self.imageFrameInView;
        
        // add title label
        self.headerLabel = [[PeggLabel alloc] initWithText:TEXT_SCALE_EDIT color:[UIColor whiteColor] font:[UIFont fontWithName:FONT_PROXIMA_BOLD size:FONT_SIZE_CROP_TEXT] andFrame:CGRectZero];
        [self addSubview:self.headerLabel];
        [self.headerLabel sizeToFit];
        [self.headerLabel setTop:CROP_TITLE_OFFSET];
        [self.headerLabel centerHorizontallyInSuperView];
        
        // add cancel button
        self.cancelButton = [[ColorButton alloc] initWithButtonStyle:ButtonStyleEdit title:TEXT_CANCEL andFrame:CGRectMake(ARTICLE_OFFSET, self.height - EDIT_BUTTON_HEIGHT - ARTICLE_BUTTON_PADDING, EDIT_BUTTON_WIDTH, EDIT_BUTTON_HEIGHT)];
        [self.cancelButton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.cancelButton];
        
        // add save button
        self.saveButton = [[ColorButton alloc] initWithButtonStyle:ButtonStyleEdit title:TEXT_SAVE andFrame:CGRectMake(self.width - EDIT_BUTTON_WIDTH - ARTICLE_OFFSET, self.height - EDIT_BUTTON_HEIGHT - ARTICLE_BUTTON_PADDING, EDIT_BUTTON_WIDTH, EDIT_BUTTON_HEIGHT)];
        [self.saveButton addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.saveButton];
    }
    
    return self;
}

- (void)setImageToCrop:(UIImage *)imageToCrop
{
    _imageToCrop = imageToCrop;
    
   // [self.cropScrollView displayImage:imageToCrop];
    
   // self.cropImageView.image = imageToCrop;
    
 //   [self.cropImageView sizeToFit];
  
    /*
    CGFloat frameWidth = self.width;
    CGFloat frameHeight = self.height;
    CGFloat imageWidth = imageToCrop.size.width;
    CGFloat imageHeight = imageToCrop.size.height;
    BOOL isPortrait = imageHeight > imageWidth;
    NSInteger x, y;
    NSInteger scaledImageWidth, scaledImageHeight;
    
    if(isPortrait)
    {
        self.imageScale = imageHeight / frameHeight;
        scaledImageWidth = imageWidth / self.imageScale;
        x = (frameWidth - scaledImageWidth) / 2;
        y = 0;
    }
    else
    {
        self.imageScale = imageWidth / frameWidth;
        scaledImageHeight = imageHeight / self.imageScale;
        x = 0;
        y = (frameHeight - scaledImageHeight) / 2;
    }
    */
    self.cropImageView.image = imageToCrop;
}

/*
- (void)addCropControlsWithImage:(UIImage *)image
{
    self.cropControlsView = [[PECropView alloc] initWithFrame:self.containerView.bounds];
    [self.cropControlsView setImage:image];
    [self.containerView addSubview:self.cropControlsView];
    
    if(self.imageCropperView)
    {
        [self.imageCropperView removeFromSuperview];
        self.imageCropperView = nil;
    }
    
    self.imageCropperView = [[YKImageCropperView alloc] initWithImage:image];
    [self.imageContainerView addSubview:self.imageCropperView];
    
   // [self.imageCropperView setImage:image];
}
*/

- (void)panImage:(UIPanGestureRecognizer *)recognizer
{
    switch (recognizer.state)
    {
        case UIGestureRecognizerStateBegan:
        case UIGestureRecognizerStateChanged:
        {
            NSLog(@"CHANGED");
            
            CGPoint newPoint = self.cropImageView.center;
            CGPoint delta = [recognizer translationInView:self];
            
            newPoint.x += delta.x;
            newPoint.y += delta.y;
            
            // set new location
            self.cropImageView.center = newPoint;
            
            [recognizer setTranslation:CGPointZero inView:self];
        }
            break;
            
        default:
            break;
    }
}

- (void)pinchImage:(UIPinchGestureRecognizer *)recognizer
{
    self.cropImageView.transform = CGAffineTransformScale(self.cropImageView.transform, recognizer.scale, recognizer.scale);
}

- (void)save:(id)sender
{
    [self.delegate cropView:self didRequestSaveNewImage:[self processedImage]];
}

- (void)cancel:(id)sender
{
    [self.delegate cropViewDidRequestCancelEditing:self];
}

- (void)reset
{
    [self.cropImageView centerInSuperView];
    self.cropImageView.clipsToBounds = NO;
}

- (UIImage *)processedImage
{
    CGFloat scale = self.cropImageView.image.size.width / self.cropImageView.width;
    
    CGRect rect = self.cropAreaView.frame;
    
    rect.origin.x = (rect.origin.x - self.cropImageView.left) * scale;
    rect.origin.y = (rect.origin.y - self.cropImageView.top) * scale;
    rect.size.width *= scale;
    rect.size.height *= scale;
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextClipToRect(c, CGRectMake(0, 0, rect.size.width, rect.size.height));
    [self.cropImageView.image drawInRect:CGRectMake(-rect.origin.x, -rect.origin.y, self.cropImageView.image.size.width, self.cropImageView.image.size.height)];
    
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return result;
    
   /* CGFloat scale = [[UIScreen mainScreen] scale];
    
    UIGraphicsBeginImageContextWithOptions(self.cropScrollView.contentSize, YES, scale);
    
    CGContextRef graphicsContext = UIGraphicsGetCurrentContext();
    
    [self.cropImageView.layer renderInContext:graphicsContext];
    
    UIImage *finalImage = nil;
    UIImage *sourceImage = UIGraphicsGetImageFromCurrentImageContext();
    
    CGRect targetFrame = CGRectMake(self.cropImageView.x * scale,
                                    self.cropImageView.contentOffset.y * scale,
                                    self.cropScrollView.frame.size.width * scale,
                                    self.cropScrollView.frame.size.height * scale);
    
    CGImageRef contextImage = CGImageCreateWithImageInRect([sourceImage CGImage], targetFrame);
    
    if (contextImage != NULL)
    {
        finalImage = [UIImage imageWithCGImage:contextImage
                                         scale:scale
                                   orientation:UIImageOrientationUp];
        
        CGImageRelease(contextImage);
    }
    
    UIGraphicsEndImageContext();
    
    return finalImage;*/
    
   // self.cropImageView.clipsToBounds = YES;
    
   // UIImage *croppedImage = [self.cropImageView.image subImageWithBounds:self.cropAreaView.frame];
   // return croppedImage;
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    
}
 */

@end
