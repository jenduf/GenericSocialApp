//
//  FriendListCell.h
//  PeggSite
//
//  Created by Jennifer Duffey on 3/14/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FriendListCellDelegate;

@interface FriendListCell : UITableViewCell

@property (nonatomic, strong) Friend *friend;
@property (nonatomic, weak) IBOutlet UIImageView *avatarImageView;
@property (nonatomic, weak) IBOutlet UILabel *friendLabel;
@property (nonatomic, weak) IBOutlet UIButton *addButton;
@property (nonatomic, weak) IBOutlet id <FriendListCellDelegate> delegate;

- (IBAction)add:(id)sender;

@end

@protocol FriendListCellDelegate

- (void)friendListCellRequestedAdd:(FriendListCell *)friendListCell;

- (void)friendListCellRequestedRemove:(FriendListCell *)friendListCell;

@end
