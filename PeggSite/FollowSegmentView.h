//
//  FollowSegmentView.h
//  PeggSite
//
//  Created by Jennifer Duffey on 5/23/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FollowSegmentViewDelegate;

@interface FollowSegmentView : UIView

@property (nonatomic, weak) IBOutlet id <FollowSegmentViewDelegate> delegate;

- (IBAction)segmentSelected:(id)sender;

@end

@protocol FollowSegmentViewDelegate

- (void)followSegmentSelected:(NSInteger)segmentIndex;

@end
