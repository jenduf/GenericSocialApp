//
//  ShareView.h
//  PeggSite
//
//  Created by Jennifer Duffey on 7/1/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ShareViewDelegate;

@interface ShareView : UIView

@property (nonatomic, weak) id <ShareViewDelegate> delegate;

@end

@protocol ShareViewDelegate

- (void)shareViewDidRequestShareFacebook:(ShareView *)shareView;
- (void)shareViewDidRequestShareTwitter:(ShareView *)shareView;
- (void)shareViewDidRequestShareEmail:(ShareView *)shareView;
- (void)shareViewDidRequestShareURL:(ShareView *)shareView;

@end