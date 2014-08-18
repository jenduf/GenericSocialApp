//
//  Article.m
//  PeggSite
//
//  Created by Jennifer Duffey on 3/3/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import "Article.h"

@implementation Article

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    
    if(self)
    {
        _articleID = dictionary[@"article_id"];
        _articleTypeID = [dictionary[@"article_type_id"] intValue];
        _userID = [dictionary[@"user_id"] intValue];
        _source = dictionary[@"src"];
        _sourceWidth = [dictionary[@"src_width"] floatValue];
        _sourceHeight = [dictionary[@"src_height"] floatValue];
        _regionNumber = [dictionary[@"region_num"] intValue];
        _contentScale = [dictionary[@"content_scale"] intValue];
        _contentTop = [dictionary[@"content_top"] intValue];
        _contentLeft = [dictionary[@"content_left"] intValue];
        _dateAdded = [Utils dateFromString:[Utils replaceIfNullString:dictionary[@"date_added"]] withFormat:DATE_FORMAT_STRING_SANS_ZONE];
        _dateRemoved = [Utils dateFromString:[Utils replaceIfNullString:dictionary[@"date_removed"]] withFormat:DATE_FORMAT_STRING_SANS_ZONE];
        _isOnBoard = [dictionary[@"is_on_board"] intValue];
        _caption = [Utils replaceIfNullString:dictionary[@"caption"]];
        _text = [Utils replaceIfNullString:dictionary[@"text"]];
        _externalMediaID = dictionary[@"external_media_id"];
        _avatar = dictionary[@"avatar"];
        _userName = dictionary[@"username"];
        _layoutID = [dictionary[@"layoutId"] intValue];
        _activityCount = [[Utils replaceIfNullValue:dictionary[@"activity_count"]] intValue];
        _iLove = [dictionary[@"i_love"] intValue];
        
        if(_articleTypeID != ArticleTypeText)
        {
             NSURL *imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PEGGSITE_IMAGE_URL, _source]];
            
            [[SDWebImageManager sharedManager] downloadWithURL:imageURL options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize)
            {
                
            }
            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished)
            {
                _articleImage = image;
            }];
        }
    }
    
    return self;
}

- (void)setILove:(NSInteger)iLove
{
    _iLove = iLove;
    
    if(iLove)
        self.activityCount++;
    else
        self.activityCount--;
}

static Article *currentArticleObject;

+ (Article *)currentArticle
{
    return currentArticleObject;
}

+ (void)setCurrentArticle:(Article *)article
{
    currentArticleObject = article;
}

@end
