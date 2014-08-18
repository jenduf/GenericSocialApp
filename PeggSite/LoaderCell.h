//
//  LoaderCell.h
//  PeggSite
//
//  Created by Bart Lewis on 7/14/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoaderCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

-(void)startAnimating;

@end
