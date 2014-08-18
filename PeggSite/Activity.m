//
//  Activity.m
//  PeggSite
//
//  Created by Jennifer Duffey on 4/14/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import "Activity.h"

@implementation Activity

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    
    if(self)
    {
        _activityID = dictionary[@"id"];
        NSString *type = dictionary[@"type"];
        _activityType = [self getActivityTypeFromString:type];
        _dateAdded = [Utils dateFromString:[Utils replaceIfNullString:dictionary[@"date_added"]] withFormat:DATE_FORMAT_STRING_SANS_ZONE];
        _userName = dictionary[@"username"];
        _userID = [dictionary[@"user_id"] intValue];
        _avatar = [Utils replaceIfNullString:dictionary[@"avatar"]];
        
        if(dictionary[@"extra"])
        {
            NSDictionary *extra = [NSDictionary dictionaryWithDictionary:dictionary[@"extra"]];
            _articleID = extra[@"article_id"];
            _articleType = [extra[@"article_type_id"] intValue];
            _isPrivate = [extra[@"is_private"] boolValue];
            _isPrivateBypass = [extra[@"is_private_bypass"] boolValue];
            _isAuthUserFriend = [extra[@"is_auth_user_friend"] boolValue];
            _comment = extra[@"comment"];
            
            _mentionUser = extra[@"username"];
            
            _thumbnail = extra[@"src"];
            
            if(_thumbnail)
            {
                NSURL *imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PEGGSITE_IMAGE_URL, _thumbnail]];
                
                [[SDWebImageManager sharedManager] downloadWithURL:imageURL options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize)
                 {
                     
                 }
                completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished)
                 {
                     _activityThumbnail = image;
                 }];
            }
        }
        else
        {
            _comment = dictionary[@"comment"];
        }
    }
    
    return self;
}
           
- (ActivityType)getActivityTypeFromString:(NSString *)activityString
{
    if([activityString isEqualToString:@"comment"])
        return ActivityTypeComment;
    else if([activityString isEqualToString:@"follow"])
        return ActivityTypeFollow;
    else if([activityString isEqualToString:@"mention"])
        return ActivityTypeMention;
    
    return ActivityTypeLove;
}

- (BOOL)isEqual:(id)object
{
    if (![object isKindOfClass:[Activity class]])
    {
        return NO;
    }

    Activity *other = (Activity *)object;
    return [other.activityID isEqualToString:self.activityID];
}

@end
