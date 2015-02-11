//
//  DrawingHelper.h
//  Trivie
//
//  Created by Jennifer Duffey on 3/20/12.
//  Copyright (c) 2012 Trivie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface DrawingHelper : NSObject

CGSize getAdjustedScale(float width, float height);

CGRect getApplicationFrame();

CGSize getContentSize();

void drawLinearGradient(CGContextRef context, CGRect rect, CGColorRef startColor, CGColorRef  endColor);

void drawRadialGradient(CGContextRef context, CGRect rect, CGPoint startCenter, CGPoint endCenter, CGFloat startRadius, CGFloat endRadius, CGColorRef startColor, CGColorRef  endColor);

CGRect rectFor1PxStroke(CGRect rect);

void drawStroke(CGContextRef context, CGPoint startPoint, CGPoint endPoint, CGColorRef color, CGFloat lineWidth);

void drawGlossAndGradient(CGContextRef context, CGRect rect, CGColorRef startColor, CGColorRef endColor);

static inline double radians (double degrees) { return degrees * M_PI/180; }

CGMutablePathRef createRoundedRectForRect(CGRect rect, CGFloat radius);

@end
