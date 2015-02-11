//
//  FacebookUser.m
//  PeggSite
//
//  Created by Jennifer Duffey on 3/24/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import "FacebookUser.h"

@implementation FacebookUser

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    
    if(self)
    {
        _userID = dictionary[@"id"];
        _name = dictionary[@"name"];
        _firstName = dictionary[@"first_name"];
        _lastName = dictionary[@"last_name"];
        _userName = dictionary[@"username"];
        _email = dictionary[@"email"];
        _userLocation = dictionary[@"location"][@"name"];
        _isInstalled = [dictionary[@"installed"] boolValue];
        _pictureURL = dictionary[@"picture"][@"data"][@"url"];
        
        
        _coverURL = dictionary[@"cover"][@"source"];
        
        // [self downloadPicAtURL:coverURL];
    }
    
    return self;
}

- (void)downloadPicAtURL:(NSString *)url
{
    dispatch_async(kBGQueue, ^
                   {
                       NSURL *imageURL = [NSURL URLWithString:url];
                       
                       dispatch_sync(kBGQueue, ^
                                     {
                                         self.coverImageData = [[NSData alloc] initWithContentsOfURL:imageURL];
                                         
                                     });
                       
                   });
}

@end
