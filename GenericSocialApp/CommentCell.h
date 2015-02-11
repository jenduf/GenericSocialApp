//
//  CommentCell.h
//  PeggSite
//
//  Created by Jennifer Duffey on 4/4/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Activity;
@interface CommentCell : UITableViewCell

@property (nonatomic, weak) IBOutlet PeggLabel *userName, *commentText, *dateAdded;
@property (nonatomic, weak) IBOutlet AvatarView *avatarView;
@property (nonatomic, weak) IBOutlet UIImageView *commentImageView;

@property (nonatomic, strong) Activity *activity;

@end
