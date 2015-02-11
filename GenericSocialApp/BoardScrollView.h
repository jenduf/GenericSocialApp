//
//  BoardScrollView.h
//  PeggSite
//
//  Created by Jennifer Duffey on 5/29/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MediaContentView.h"

@protocol BoardScrollViewDelegate;

@class WhiteBoxView;
@interface BoardScrollView : UIScrollView
<UIScrollViewDelegate, MediaContentViewDelegate>

@property (nonatomic, strong) CAShapeLayer *backgroundLayer;
@property (nonatomic, strong) CALayer *shadowLayer;
@property (nonatomic, weak) IBOutlet UIView *scrollBackgroundView;
@property (nonatomic, strong) NSMutableArray *placeholders, *media;
@property (nonatomic, assign) BOOL editMode;
@property (nonatomic, assign) CGRect originalFrame;
@property (nonatomic, weak) IBOutlet id <BoardScrollViewDelegate> boardScrollDelegate;
@property (nonatomic, strong) MediaContentView *selectedMediaContentView;
@property (nonatomic, assign) NSInteger currentPage;

- (void)addPlaceholdersForRegions:(NSArray *)regions;
- (Region *)getAvailableRegion;
- (Region *)getOccupiedRegion;
- (void)scrollToRegionNumber:(NSInteger)regionNumber animated:(BOOL)animated;

@end

@protocol BoardScrollViewDelegate

- (void)boardScrollView:(BoardScrollView *)boardScrollView didRequestViewMedia:(MediaContentView *)mediaContentView;
- (void)boardScrollView:(BoardScrollView *)boardScrollView didRequestDeleteArticle:(Article *)article;
- (void)boardScrollView:(BoardScrollView *)boardScrollView didRequestCropMedia:(MediaContentView *)mediaContentView;
- (void)boardScrollView:(BoardScrollView *)boardScrollView didRequestUpdateArticle:(Article *)article;
- (void)boardScrollView:(BoardScrollView *)boardScrollView didRequestUpdateArticles:(NSArray *)articles;
- (void)boardScrollView:(BoardScrollView *)boardScrollView didChangePage:(NSInteger)pageIndex;
- (void)boardScrollView:(BoardScrollView *)boardScrollView didRequestEditArticle:(Article *)article;

@end


