//
//  Article.h
//  PeggSite
//
//  Created by Jennifer Duffey on 3/3/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Article : NSObject

@property (nonatomic, strong) NSString *articleID;
@property (nonatomic, assign) NSInteger userID;
@property (nonatomic, assign) ArticleType articleTypeID;
@property (nonatomic, strong) NSString *source;
@property (nonatomic, assign) CGFloat sourceWidth, sourceHeight;
@property (nonatomic, assign) NSInteger regionNumber;
@property (nonatomic, assign) CGFloat contentScale, contentTop, contentLeft;
@property (nonatomic, strong) NSDate *dateAdded, *dateRemoved;
@property (nonatomic, assign) NSInteger isOnBoard;
@property (nonatomic, strong) NSString *caption;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *externalMediaID;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, assign) NSInteger layoutID;
@property (nonatomic, assign) NSInteger activityCount;
@property (nonatomic, assign) NSInteger iLove;
@property (nonatomic, strong) NSArray *activities;
@property (nonatomic, assign) BOOL isNew;
@property (nonatomic, strong) UIImage *articleImage;

+ (Article *)currentArticle;
+ (void)setCurrentArticle:(Article *)article;

@end
