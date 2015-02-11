//
//  GradientView.h
//  Toric
//
//  Created by Jennifer Duffey on 8/1/13.
//  Copyright (c) 2013 Jennifer Duffey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GradientView : UIView

@property (nonatomic, strong) CAGradientLayer *backgroundLayer;

@property (nonatomic, strong) NSArray *colors, *locations;

@property (nonatomic, assign) CGFloat cornerRadius;

- (void)setColors:(NSArray *)colors andLocations:(NSArray *)locations;

@end
