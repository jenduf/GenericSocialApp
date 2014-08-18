//
//  ModalAlertDelegate.h
//  PeggSite
//
//  Created by Jennifer Duffey on 4/29/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModalAlert : NSObject
<UIAlertViewDelegate>


@property (nonatomic, strong) UIAlertView *alertView;
@property (nonatomic, assign) NSInteger index;

+ (instancetype)delegateWithAlert:(UIAlertView *)alert;
- (NSInteger)show;

@end
