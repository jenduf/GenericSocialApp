//
//  CropView.h
//  PeggSite
//
//  Created by Jennifer Duffey on 6/10/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShadeView.h"
#import "ColorButton.h"
#import "CropControlsView.h"

@protocol CropViewDelegate;

@class CropScrollView;
@interface CropView : UIView

@property (nonatomic, weak) IBOutlet id <CropViewDelegate> delegate;
@property (nonatomic, strong) UIView *cropAreaView;
@property (nonatomic, strong) ShadeView *shadeView;
@property (nonatomic, strong) UIImageView *cropImageView;
@property (nonatomic, strong) CropScrollView *cropScrollView;
@property (nonatomic, strong) UIImage *imageToCrop;
@property (nonatomic, assign) CGFloat imageScale;
@property (nonatomic, assign) CGRect imageFrameInView;
@property (nonatomic, strong) PeggLabel *headerLabel;
@property (nonatomic, strong) ColorButton *cancelButton, *saveButton;
@property (nonatomic, strong) CropControlsView *cropControlsView;

- (void)reset;

@end

@protocol CropViewDelegate

- (void)cropView:(CropView *)cropView didRequestSaveNewImage:(UIImage *)image;

- (void)cropViewDidRequestCancelEditing:(CropView *)cropView;

@end
