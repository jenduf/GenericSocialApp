//
//  MenuCell.m
//  PeggSite
//
//  Created by Jennifer Duffey on 4/29/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import "MenuCell.h"

@implementation MenuCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
