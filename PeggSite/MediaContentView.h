//
//  GalleryImageView.h
//  PeggSite
//
//  Created by Jennifer Duffey on 3/7/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CropControlsView.h"

@protocol MediaContentViewDelegate;

@class EmptyArticleView;
@interface MediaContentView : UIView

@property (nonatomic, strong) Article *article;
@property (nonatomic, weak) id <MediaContentViewDelegate> delegate;
@property (nonatomic, assign) NSInteger regionID;
@property (nonatomic, assign) BOOL editMode, active;
@property (nonatomic, strong) UIImageView *mediaImageView;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) PeggTextView *mediaTextView;
@property (nonatomic, strong) PeggTextField *mediaTextField;
@property (nonatomic, strong) CropControlsView *cropControlsView;
@property (nonatomic, strong) EmptyArticleView *emptyArticleView;
@property (nonatomic, assign) CGPoint currentPoint;

@end

@protocol MediaContentViewDelegate
@optional
- (void)mediaContentView:(MediaContentView *)mediaContentView didRequestCropArticle:(Article *)article;
- (void)mediaContentView:(MediaContentView *)mediaContentView didRequestDeleteArticle:(Article *)article;
- (void)mediaContentViewBeganDragging:(MediaContentView *)mediaContentView;
- (void)mediaContentView:(MediaContentView *)mediaContentView isMovingToNewLocation:(CGPoint)newLocation withDelta:(CGFloat)delta;
- (void)mediaContentView:(MediaContentView *)mediaContentView didMoveToLocation:(CGPoint)newLocation;
- (void)mediaContentViewDidRequestPlay:(MediaContentView *)mediaContentView;

@end