//
//  FacebookUser.h
//  PeggSite
//
//  Created by Jennifer Duffey on 3/24/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FacebookUser : NSObject

@property (nonatomic, strong) NSString *name, *firstName, *lastName, *userName, *userID, *email, *pictureURL, *coverURL, *userLocation;
@property (nonatomic, strong) NSData *profileImageData, *coverImageData;
@property (nonatomic, assign) BOOL isInstalled, isFollowing;

@end
