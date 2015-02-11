//
//  ProgressView.m
//  PeggSite
//
//  Created by Jennifer Duffey on 3/16/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import "SpinnerView.h"

@implementation SpinnerView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if(self)
    {
      //  [self initialize];
    }
    
    return self;
}

/*
- (void)initialize
{
    self.brownLoader = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_0", IMAGE_BROWN_LOADER]]];
    [self.brownLoader setAnimationImages:[self loadImagesForLoaderNamed:IMAGE_BROWN_LOADER]];
    [self addSubview:self.brownLoader];
    [self.brownLoader centerInSuperView];
    [self.brownLoader setHidden:YES];
    
    self.grayLoader = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_0", IMAGE_GRAY_LOADER]]];
    [self.grayLoader setAnimationImages:[self loadImagesForLoaderNamed:IMAGE_GRAY_LOADER]];
    [self addSubview:self.grayLoader];
    [self.grayLoader centerInSuperView];
    [self.grayLoader setHidden:YES];
    
    self.pLoader = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_0", IMAGE_P_LOADER]]];
    [self.pLoader setAnimationImages:[self loadImagesForLoaderNamed:IMAGE_P_LOADER]];
    [self addSubview:self.pLoader];
    [self.pLoader centerInSuperView];
    [self.pLoader setHidden:YES];
}
 */

- (NSMutableArray *)loadImagesForSpinnerNamed:(NSString *)loaderName
{
    NSMutableArray *allImages = [NSMutableArray array];
    
    for(NSInteger i = 0; i < TOTAL_ANIMATED_IMAGES; i++)
    {
        NSString *imageName = [NSString stringWithFormat:@"%@_%li", loaderName, (long)i];
        UIImage *image = [UIImage imageNamed:imageName];
        [allImages addObject:image];
    }
    
    return allImages;
}

- (void)showSpinnerForType:(SpinnerType)type
{
    [self setHidden:NO];
    
    NSString *spinnerName;
    
    switch(type)
    {
        case SpinnerTypeBrown:
        {
             spinnerName = IMAGE_BROWN_LOADER;
        }
            break;
            
        case SpinnerTypeGray:
        {
            spinnerName = IMAGE_GRAY_LOADER;
        }
            break;
            
        case SpinnerTypeP:
        {
            spinnerName = IMAGE_P_LOADER;
        }
            break;
            
        default:
            break;
    }
    
    self.spinnerImageView.animationImages = [self loadImagesForSpinnerNamed:spinnerName];
    [self.spinnerImageView startAnimating];
}

- (void)hideSpinner
{
    [self setHidden:YES];
    
    [self.spinnerImageView stopAnimating];
    self.spinnerImageView.animationImages = nil;
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
