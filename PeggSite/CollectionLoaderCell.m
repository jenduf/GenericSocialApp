//
//  CollectionLoaderCell.m
//  PeggSite
//
//  Created by Bart Lewis on 7/16/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import "CollectionLoaderCell.h"

@implementation CollectionLoaderCell

- (void)awakeFromNib
{
    self.tag = LOADING_CELL_TAG;
}

-(void)startAnimating
{
    [self.activityIndicator startAnimating];
}

@end
