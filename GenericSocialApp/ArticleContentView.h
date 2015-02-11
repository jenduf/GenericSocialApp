//
//  ArticleContentView.h
//  PeggSite
//
//  Created by Jennifer Duffey on 6/13/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArticleContentView : UIView

@property (nonatomic, assign) AddContentType contentType;
@property (nonatomic, weak) IBOutlet PeggTextField *titleTextField;
@property (nonatomic, weak) IBOutlet PeggTextView *contentTextView;

@end
