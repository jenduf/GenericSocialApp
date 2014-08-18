//
//  FriendCellTableViewCell.h
//  PeggSite
//
//  Created by Jennifer Duffey on 3/5/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NotificationView;
@interface FriendCell : UITableViewCell

@property (nonatomic, strong) Friend *friend;
@property (nonatomic, weak) IBOutlet AvatarView *avatarView;
@property (nonatomic, weak) IBOutlet UILabel *friendLabel;
@property (nonatomic, weak) IBOutlet NotificationView *noteView;

@end
