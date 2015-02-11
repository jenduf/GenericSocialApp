//
//  ProgressView.h
//  PeggSite
//
//  Created by Jennifer Duffey on 3/16/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SpinnerView : UIView

@property (nonatomic, weak) IBOutlet UIImageView *spinnerImageView;

- (void)showSpinnerForType:(SpinnerType)type;
- (void)hideSpinner;

@end
