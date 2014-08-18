//
//  RequestCell.h
//  PeggSite
//
//  Created by Jennifer Duffey on 5/23/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FollowCell.h"

@class Request;
@interface RequestCell : FollowCell

@property (nonatomic, strong) Request *request;

- (IBAction)choiceClicked:(id)sender;

@end
