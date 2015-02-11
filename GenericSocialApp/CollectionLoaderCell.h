//
//  CollectionLoaderCell.h
//  PeggSite
//
//  Created by Bart Lewis on 7/16/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionLoaderCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

-(void)startAnimating;

@end
