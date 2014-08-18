//
//  LoaderCell.m
//  PeggSite
//
//  Created by Bart Lewis on 7/14/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import "LoaderCell.h"

@implementation LoaderCell

- (void)awakeFromNib
{
    self.tag = LOADING_CELL_TAG;
}

-(void)startAnimating
{
    [self.activityIndicator startAnimating];
}


@end
