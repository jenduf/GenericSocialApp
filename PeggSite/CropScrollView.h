//
//  CropContentView.h
//  PeggSite
//
//  Created by Jennifer Duffey on 6/18/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CropScrollView : UIScrollView
<UIScrollViewDelegate>

@property (nonatomic, strong) UIImageView *scrollImageView;

- (void)displayImage:(UIImage *)image;

@end
