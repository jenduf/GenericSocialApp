//
//  SocialButtonView.h
//  PeggSite
//
//  Created by Jennifer Duffey on 5/8/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SocialButtonView : UIView

@property (nonatomic, weak) IBOutlet UIImageView *iconImageView;
@property (nonatomic, weak) IBOutlet PeggLabel *headerLabel, *titleLabel;

@end
