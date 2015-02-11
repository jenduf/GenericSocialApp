//
//  AddViewController.h
//  PeggSite
//
//  Created by Jennifer Duffey on 6/13/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import "PSViewController.h"

@interface AddViewController : PSViewController

@property (nonatomic, assign) AddContentType contentType;
@property (nonatomic, strong) Article *article;

@end
