//
//  FollowButtonView.h
//  PeggSite
//
//  Created by Jennifer Duffey on 3/31/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FollowButtonView : UIView

@property (nonatomic, weak) IBOutlet UILabel *countLabel, *textLabel;
@property (nonatomic, assign) BOOL active;

@end
