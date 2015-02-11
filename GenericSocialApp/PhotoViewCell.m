//
//  PhotoViewCell.m
//  PeggSite
//
//  Created by Jennifer Duffey on 6/13/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import "PhotoViewCell.h"
#import "PhotoView.h"

@implementation PhotoViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setAsset:(ALAsset *)asset
{
    _asset = asset;
    
    UIImage *img = [UIImage imageWithCGImage:[asset thumbnail]];
    
    self.photoView.photoImageView.image = img;
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    [self.photoView setSelected:selected];
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
