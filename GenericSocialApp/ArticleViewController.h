//
//  ArticleViewController.h
//  PeggSite
//
//  Created by Jennifer Duffey on 5/27/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import "PSViewController.h"

@interface ArticleViewController : PSViewController

@property (nonatomic, strong) Article *article;
@property (nonatomic, strong) NSString *articleID;
@property (nonatomic, assign) PostType postType;

@end
