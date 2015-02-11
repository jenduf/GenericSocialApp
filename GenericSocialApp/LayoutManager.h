//
//  LayoutManager.h
//  PeggSite
//
//  Created by Jennifer Duffey on 3/21/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LayoutManager : NSObject


@property (nonatomic, strong) NSMutableArray *layouts;

+ (LayoutManager *)sharedInstance;

- (void)getRegionsForUser:(User *)user withCompletionBlock:(void (^)(NSArray *regions, NSError *error))completionBlock;

@end
