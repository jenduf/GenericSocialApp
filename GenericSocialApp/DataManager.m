 //
//  DataManager.m
//  PeggSite
//
//  Created by Jennifer Duffey on 3/5/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import "DataManager.h"
#import "PSViewController.h"
#import "RequestOperation.h"
#import "RequestQueueManager.h"

@interface DataManager ()
<NSURLConnectionDataDelegate, NSURLSessionTaskDelegate, NSURLSessionDelegate, NSURLSessionDataDelegate>

@property (nonatomic, strong) NSURLConnection *activeConnection;
@property (nonatomic, strong) NSMutableData *responseData;
@property (nonatomic, strong) NSHTTPURLResponse *response;
@property (nonatomic, strong) NSString *userName, *password;
@property (nonatomic, strong) NSHTTPCookie *storedCookie;
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSURLSessionTask *currentTask;

@end

@implementation DataManager

static DataManager *sharedInstance = nil;

+ (DataManager *)sharedInstance
{
    static dispatch_once_t pred;
    
    dispatch_once(&pred, ^
    {
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (id)init
{
    self = [super init];
    
    if(self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cookiesChanged:) name:NSHTTPCookieManagerCookiesChangedNotification object:nil];
    }
    
    return self;
}

- (NSURLSession *)configureSession
{
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    return session;
}

- (void)cookiesChanged:(NSNotification *)note
{
  //  for(NSHTTPCookie *cookie in [NSHTTPCookieStorage sharedHTTPCookieStorage].cookies)
   // {
        //NSLog(@"Cookie name: %@ value: %@, properties: %@ date: %@", cookie.name, cookie.value, cookie.properties, cookie.expiresDate);
   // }
}

- (void)updateCookies:(NSArray *)cookies
{
    if(cookies.count > 0)
    {
        for(NSHTTPCookie *newCookie in cookies)
        {
            //  NSLog(@"New Cookie name: %@ value: %@", newCookie.name, newCookie.value);
            
            NSLog(@"New Cookie name: %@ value: %@", newCookie.name, newCookie.value);
            
            if([newCookie.name isEqualToString:COOKIE_HEADER])
            {
                NSArray *oldCookies = [NSHTTPCookieStorage sharedHTTPCookieStorage].cookies;
                for(NSHTTPCookie *c in oldCookies)
                {
                    [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:c];
                }
                
                self.storedCookie = newCookie;
                
                [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
                [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:self.storedCookie];
            }
        }
    }
}

- (id)parseJSONResponse:(NSData *)json
{
    if(!json)
    {
        return nil;
    }
    
    NSError *error = nil;
    
    id data = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:&error];
    
    if(error)
    {
        NSLog(@"JSON ERROR: %@", error);
        return nil;
    }
    
    return data;
}

- (NSData *)dictionaryToJSON:(NSDictionary *)dict
{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    if(jsonData.length > 0 && error == nil)
    {
        //NSLog(@"Successful serialization of dictionary %@", jsonData);
        //NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        //NSLog(@"JSON String: %@", jsonString);
    }
    else if(jsonData.length == 0 && error == nil)
    {
        NSLog(@"No data was returned after serialization");
    }
    else if(error != nil)
    {
        NSLog(@"An error happened = %@", error);
    }
    
    return jsonData;
}

- (void)userLoggedOut
{
    self.userName = nil;
    self.password = nil;
    
    self.delegate = nil;
    
    self.storedCookie = nil;
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:KEY_LOGIN_USERNAME];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:KEY_LOGIN_PASSWORD];
}


#pragma mark - Login Requests
- (BOOL)checkUserName:(NSString *)userName
{
    NSString *newURL = [NSString stringWithFormat:@"%@is_valid_username/%@", PEGGSITE_API_URL, userName];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:newURL]];
    request.HTTPMethod = HTTP_GET;
    
    NSURLResponse *URLResponse = nil;
    NSError *error = nil;
    
    NSData *json = [NSURLConnection sendSynchronousRequest:request returningResponse:&URLResponse error:&error];
    
    BOOL output = [[self parseJSONResponse:json] boolValue];
    
    return output;
}

- (void)loginWithUserName:(NSString *)userName andPassword:(NSString *)password delegate:(id)delegate
{
    self.delegate = delegate;
    
    self.requestType = RequestTypeLogin;
    
    self.userName = userName;
    self.password = password;
    
    NSString *params = [NSString stringWithFormat:@"username=%@&password=%@&platform=ios", userName, password];
    
    NSData *postData = [NSData dataWithData:[params dataUsingEncoding:NSUTF8StringEncoding]];
    
    [self startRequest:@"login" method:HTTP_POST postData:postData isJSON:NO];
}

- (void)logoutWithDelegate:(id)delegate
{
    self.delegate = delegate;
    
    self.requestType = RequestTypeLogout;
    
    [self startRequest:@"logout" method:HTTP_POST postData:nil isJSON:NO];
}

- (void)addPushTokenWithDelegate:(id)delegate
{
    self.delegate = delegate;
    
    self.requestType = RequestTypeSetToken;
    
    if(self.deviceToken)
    {
        NSString *newURL = [NSString stringWithFormat:@"device_token/%@", self.deviceToken];
    
        [self startRequest:newURL method:HTTP_POST postData:nil isJSON:NO];
    }
}

- (void)deletePushTokenWithDelegate:(id)delegate
{
    self.delegate = delegate;
    
    self.requestType = RequestTypeDeleteToken;
    
    NSString *newURL = [NSString stringWithFormat:@"device_token/%@", self.deviceToken];
    
    [self startRequest:newURL method:HTTP_DELETE postData:nil isJSON:NO];
}

#pragma mark - User Requests
- (void)getUser:(NSString *)userName delegate:(id)delegate
{
    self.delegate = delegate;
    
    self.requestType = RequestTypeGetUser;
    
    NSString *newURL = [NSString stringWithFormat:@"user/%@", userName];
    
    [self startRequest:newURL method:HTTP_GET postData:nil isJSON:NO];
}

- (void)updatePasswordWithCurrentPassword:(NSString *)current newPassword:(NSString *)newPassword andVerifiedPassword:(NSString *)verified delegate:(id)delegate
{
    self.delegate = delegate;
    
    self.requestType = RequestTypeUpdatePassword;
    
    NSString *passwordURL = [NSString stringWithFormat:@"user/%@/password", [User currentUser].userName];
    
    NSString *params = [NSString stringWithFormat:@"current-password=%@&new-password=%@&verify-password=%@", current, newPassword, verified];
    
    NSData *postData = [NSData dataWithData:[params dataUsingEncoding:NSUTF8StringEncoding]];
    
    [self startRequest:passwordURL method:HTTP_POST postData:postData isJSON:NO];
}

- (void)requestPasswordWithUsername:(NSString *)userName delegate:(id)delegate
{
    self.delegate = delegate;
    
    self.requestType = RequestTypeRequestPassword;
    
    NSString *passwordURL = [NSString stringWithFormat:@"password/request/%@", userName];
    [self startRequest:passwordURL method:HTTP_POST postData:nil isJSON:NO];
}

- (void)createUserWithUserName:(NSString *)userName password:(NSString *)password email:(NSString *)email delegate:(id)delegate
{
    self.delegate = delegate;
    
    self.requestType = RequestTypeCreateUser;
    
    self.userName = userName;
    self.password = password;
    
    /*
    NSDictionary *userDict = @{
                               KEY_USERNAME : userName,
                               KEY_EMAIL    : email,
                               KEY_PASSWORD : password,
                               KEY_PLATFORM : @"ios"
                               };
    */
    
   // NSString *params = [NSString stringWithFormat:@"{\"username\":\"%@\",\"email\":\"%@\",\"password\":\"%@\",\"platform\":\"ios\"}", userName, email, password];
    
    NSString *params = [NSString stringWithFormat:@"username=%@&email=%@&password=%@&platform=ios", userName, email, password];
    
    NSData *postData = [NSData dataWithData:[params dataUsingEncoding:NSUTF8StringEncoding]];
    
    [self startRequest:@"user" method:HTTP_POST postData:postData isJSON:NO];
}

- (void)updateCurrentUser:(User *)user delegate:(id)delegate
{
    self.delegate = delegate;
    
    self.requestType = RequestTypeUpdateUser;
    
    NSDictionary *userDict = @{
                               KEY_FIRST_NAME : user.firstName,
                               KEY_LAST_NAME :  user.lastName,
                               KEY_USERNAME : user.userName,
                               KEY_EMAIL    : user.email,
                               KEY_SHORT_BIO : user.shortBio,
                               KEY_LOCATION : user.location,
                               KEY_LAYOUT_ID : @(user.layoutID),
                               KEY_IS_NOTIFY_COMMENT : @(user.isNotifyComment),
                               KEY_IS_NOTIFY_LOVE : @(user.isNotifyLove),
                               KEY_IS_NOTIFY_FOLLOW : @(user.isNotifyFollow),
                               KEY_IS_PRIVATE : @(user.isPrivate),
                               KEY_PLATFORM : @"ios"
                               };
    
    NSData *jsonData = [self dictionaryToJSON:userDict];
    
    NSString *newURL = [NSString stringWithFormat:@"user/%@", [User currentUser].userName];
    
  //  NSString *params = [NSString stringWithFormat:@"{\"first_name\":\"%@\", \"last_name\":\"%@\",\"username\":\"%@\",\"email\":\"%@\",\"short_bio\":\"%@\",\"location\":\"%@\",\"layout_id\":%li,\"is_notify_comment\":%i,\"is_notify_love\":%i,\"is_notify_follow\":%i}", firstName, lastName, userName, email, shortBio, location, (long)layoutID, isComment, isLove, isFollow];
    
    [self startRequest:newURL method:HTTP_PATCH postData:jsonData isJSON:YES];
}

- (void)updateCurrentUserActivityWithDelegate:(id)delegate
{
    self.delegate = delegate;
    
    self.requestType = RequestTypeUpdateActivity;
    
    NSDictionary *userDict = @{
                               KEY_DATE_VIEWED_ACTIVITY : @"1"
                               };
    
    NSData *jsonData = [self dictionaryToJSON:userDict];
    
    NSString *newURL = [NSString stringWithFormat:@"user/%@", [User currentUser].userName];
    
    [self startRequest:newURL method:HTTP_PATCH postData:jsonData isJSON:YES];
}

- (void)getActivityForUser:(NSString *)userName offset:(NSInteger)offset delegate:(id)delegate
{
    self.delegate = delegate;
    
    self.requestType = RequestTypeGetUserActivity;
    
    NSString *newURL = [NSString stringWithFormat:@"user/%@/activity?offset=%ld", userName, (long)offset];

    [self startRequest:newURL method:HTTP_GET postData:nil isJSON:NO];
}

- (void)getRequestsForUser:(NSString *)userName delegate:(id)delegate
{
    [self getRequestsForUser:userName limit:DEFAULT_LIMIT offset:0 delegate:delegate];
}

- (void)getRequestsForUser:(NSString *)userName offset:(NSInteger)offset delegate:(id)delegate
{
    [self getRequestsForUser:userName limit:DEFAULT_LIMIT offset:offset delegate:delegate];
}

- (void)getRequestsForUser:(NSString *)userName limit:(NSInteger)limit offset:(NSInteger)offset delegate:(id)delegate
{
    self.delegate = delegate;
    
    self.requestType = RequestTypeGetRequests;
    
    NSString *newURL = [NSString stringWithFormat:@"user/%@/requests?limit=%li&offset=%li", userName, (long)limit, (long)offset];
    
    [self startRequest:newURL method:HTTP_GET postData:nil isJSON:NO];
}

#pragma mark - Friend Requests
- (void)updateFavoritedFriend:(User *)user isFavorite:(BOOL)isFavorite delegate:(id)delegate
{
    self.delegate = delegate;
    
    self.requestType = RequestTypeFavoritedFriend;
    
    NSString *newURL = [NSString stringWithFormat:@"friend/%ld", (long)user.userID];
    
    NSDictionary *userDict = @{
                               KEY_IS_FAVORITE : @(isFavorite)
                               };
    
    NSData *jsonData = [self dictionaryToJSON:userDict];
    
    [self startRequest:newURL method:HTTP_PUT postData:jsonData isJSON:YES];
}

- (void)updateDateVisitedFriend:(User *)user delegate:(id)delegate
{
    self.delegate = delegate;
    
    self.requestType = RequestTypeVisitedFriend;
    
    NSString *newURL = [NSString stringWithFormat:@"friend/%ld", (long)user.userID];
    
    NSDate *newDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:newDate];
    
    NSDictionary *userDict = @{
                               KEY_DATE_VISITED : dateString
                               };
    
    NSData *jsonData = [self dictionaryToJSON:userDict];
    
    [self startRequest:newURL method:HTTP_PUT postData:jsonData isJSON:YES];
}

- (void)getFriendsForUser:(NSString *)userName delegate:(id)delegate
{
    [self getFriendsForUser:userName limit:DEFAULT_LIMIT offset:0 filter:@"" delegate:delegate];
}

- (void)getFriendsForUser:(NSString *)userName offset:(NSInteger)offset delegate:(id)delegate
{
    [self getFriendsForUser:userName limit:DEFAULT_LIMIT offset:offset filter:@"" delegate:delegate];
}

- (void)getFriendsForUser:(NSString *)userName limit:(NSInteger)limit offset:(NSInteger)offset filter:(NSString *)filter delegate:(id)delegate
{
    self.delegate = delegate;
    
    self.requestType = RequestTypeGetFriends;
    
    NSString *newURL = [NSString stringWithFormat:@"user/%@/friends?limit=%li&offset=%li&filter=%@", userName, (long)limit, (long)offset, filter];
    
    [self startRequest:newURL method:HTTP_GET postData:nil isJSON:NO];
}

- (void)getFriendsOfUser:(NSString *)userName delegate:(id)delegate
{
    [self getFriendsOfUser:userName limit:DEFAULT_LIMIT offset:0 delegate:delegate];
}

- (void)getFriendsOfUser:(NSString *)userName offset:(NSInteger)offset delegate:(id)delegate
{
    [self getFriendsOfUser:userName limit:DEFAULT_LIMIT offset:offset delegate:delegate];
}

- (void)getFriendsOfUser:(NSString *)userName limit:(NSInteger)limit offset:(NSInteger)offset delegate:(id)delegate
{
    self.delegate = delegate;
    
    self.requestType = RequestTypeGetFollowers;
    
    NSString *newURL = [NSString stringWithFormat:@"user/%@/friend_of?limit=%li&offset=%li", userName, (long)limit, (long)offset];
    
    [self startRequest:newURL method:HTTP_GET postData:nil isJSON:NO];
}

- (void)addFriend:(NSInteger)friendID delegate:(id)delegate
{
    self.delegate = delegate;
    
    self.requestType = RequestTypeAddFriend;
    
    NSString *newURL = [NSString stringWithFormat:@"friend/%li", (long)friendID];
    
    [self startRequest:newURL method:HTTP_POST postData:nil isJSON:NO];
}

- (void)removeFriend:(NSInteger)friendID delegate:(id)delegate
{
    self.delegate = delegate;
    
    self.requestType = RequestTypeRemoveFriend;
    
    NSString *newURL = [NSString stringWithFormat:@"friend/%li", (long)friendID];
    
    [self startRequest:newURL method:HTTP_DELETE postData:nil isJSON:NO];
}

- (void)acceptRequest:(NSInteger)friendID delegate:(id)delegate
{
    self.delegate = delegate;
    
    self.requestType = RequestTypeRequestAcceptFriend;
    
    NSString *newURL = [NSString stringWithFormat:@"request/%li", (long)friendID];
    
    [self startRequest:newURL method:HTTP_PUT postData:nil isJSON:NO];
}

- (void)declineRequest:(NSInteger)friendID delegate:(id)delegate
{
    self.delegate = delegate;
    
    self.requestType = RequestTypeRequestDeclineFriend;
    
    NSString *newURL = [NSString stringWithFormat:@"request/%li", (long)friendID];
    
    [self startRequest:newURL method:HTTP_DELETE postData:nil isJSON:NO];
}

- (void)searchUsersWithFilter:(NSString *)filter delegate:(id)delegate;
{
    self.delegate = delegate;
    self.requestType = RequestTypeSearchUsers;
    
    NSString *newURL = [NSString stringWithFormat:@"user/search/%@", filter];
    
    [self startRequest:newURL method:HTTP_GET postData:nil isJSON:NO];
}

#pragma mark - Article Requests
- (void)getArticleWithID:(NSString *)articleID delegate:(id)delegate
{
    self.delegate = delegate;
    
    self.requestType = RequestTypeGetArticle;
    
    NSString *newURL = [NSString stringWithFormat:@"article/%@", articleID];
    
    [self startRequest:newURL method:HTTP_GET postData:nil isJSON:NO];
}

- (void)updateArticle:(Article *)article delegate:(id)delegate
{
    self.delegate = delegate;
    
    self.requestType = RequestTypeUpdateArticle;
    
    NSMutableDictionary *userDict = [NSMutableDictionary dictionary];
    
    if(article.regionNumber > 0)
        userDict[KEY_REGION_NUMBER] = @(article.regionNumber);
    
    if(article.contentScale > 0)
        userDict[@"content_scale"] = @(article.contentScale);
    
    if(article.contentLeft > 0)
        userDict[@"content_left"] = @(article.contentLeft);
    
    if(article.contentTop > 0)
        userDict[@"content_top"] = @(article.contentTop);
    
    if(article.text)
        userDict[KEY_TEXT] = article.text;
    
    if(article.caption)
        userDict[KEY_CAPTION] = article.caption;
    
    NSData *jsonData = [self dictionaryToJSON:userDict];
    
    NSString *newURL = [NSString stringWithFormat:@"article/%@", article.articleID];
    
    [self startRequest:newURL method:HTTP_PATCH postData:jsonData isJSON:YES];
}

- (void)createArticleWithExternalMediaID:(NSString *)externalMediaID articleType:(ArticleType)articleType regionNumber:(NSInteger)regionNumber text:(NSString *)text caption:(NSString *)caption delegate:(id)delegate
{
    self.delegate = delegate;
    
    self.requestType = RequestTypeCreateArticle;
    
   // NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:<#(id), ...#>, nil]
    
   //  NSString *exMediaID = (externalMediaID ? [NSString stringWithFormat:@"\"external_media_id\":\"%@\",", externalMediaID] : @"");
    
    NSMutableDictionary *userDict = [NSMutableDictionary dictionary];
    
    if(externalMediaID)
        userDict[KEY_EXTERNAL_MEDIA_ID] = externalMediaID;
    
    userDict[KEY_ARTICLE_TYPE_ID] = @(articleType);
    
    userDict[KEY_REGION_NUMBER] = @(regionNumber);
    
    userDict[KEY_TEXT] = (text ? text : @"");
    
    userDict[KEY_CAPTION] = (caption ? caption : @"");
    
    userDict[KEY_SOURCE] = @"";
    
    NSData *jsonData = [self dictionaryToJSON:userDict];
    
   // NSString *params = [NSString stringWithFormat:@"{%@\"article_type_id\":%li,\"region_num\":%li,\"text\":\"%@\",\"caption\":\"%@\",\"src\":\"\"}", exMediaID, articleType, regionNumber, text, caption];
    
    //NSData *postData = [NSData dataWithData:[params dataUsingEncoding:NSUTF8StringEncoding]];
    
    [self startRequest:@"article" method:HTTP_POST postData:jsonData isJSON:YES];
}

- (void)deleteArticle:(NSString *)articleID delegate:(id)delegate
{
    self.delegate = delegate;
    
    self.requestType = RequestTypeDeleteArticle;
    
    NSString *newURL = [NSString stringWithFormat:@"article/%@", articleID];
    
    [self startRequest:newURL method:HTTP_DELETE postData:nil isJSON:NO];
}

- (void)getLayoutsWithCompletionBlock:(void (^)(NSArray *layouts, NSError *error))completionBlock
{
    self.requestType = RequestTypeGetLayouts;
    
    NSString *newURL = [NSString stringWithFormat:@"%@layouts", PEGGSITE_API_URL];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:newURL]];
    [request setHTTPMethod:HTTP_GET];
    
    NSLog(@"\nREQUEST: %@", newURL);
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
    {
        NSArray *jsonData = [self parseJSONResponse:data];
        
        NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"\nRESPONSE: %@", str);
        
        completionBlock(jsonData, connectionError);
    }];
}

- (void)postLoveForArticleID:(NSString *)articleID delegate:(id)delegate
{
    self.delegate = delegate;
    
    self.requestType = RequestTypePostLove;
    
    NSDictionary *articleDict = @{
                                  KEY_TYPE : KEY_LOVE
                                  };
    
    NSData *jsonData = [self dictionaryToJSON:articleDict];
    
    NSString *newURL = [NSString stringWithFormat:@"article/%@/activity", articleID];
    
    [self startRequest:newURL method:HTTP_POST postData:jsonData isJSON:YES];
}

- (void)deleteLoveForArticleID:(NSString *)articleID delegate:(id)delegate
{
    self.delegate = delegate;
    
    self.requestType = RequestTypeDeleteLove;
    
    NSString *newURL = [NSString stringWithFormat:@"article/%@/activity/love", articleID];
    
    [self startRequest:newURL method:HTTP_DELETE postData:nil isJSON:NO];
}

- (void)postComment:(NSString *)comment forArticleID:(NSString *)articleID delegate:(id)delegate
{
    self.delegate = delegate;
    
    self.requestType = RequestTypePostComment;
    
    NSDictionary *userDict = @{
                               KEY_TYPE : KEY_COMMENT,
                               KEY_COMMENT : comment
                               };
    
    NSData *jsonData = [self dictionaryToJSON:userDict];
    
    NSString *newURL = [NSString stringWithFormat:@"article/%@/activity", articleID];
    
    [self startRequest:newURL method:HTTP_POST postData:jsonData isJSON:YES];
}

- (void)getActivityForArticleID:(NSString *)articleID delegate:(id)delegate
{
    self.delegate = delegate;
    
    self.requestType = RequestTypeGetActivity;
    
    NSString *newURL = [NSString stringWithFormat:@"article/%@/activity", articleID];
    
    [self startRequest:newURL method:HTTP_GET postData:nil isJSON:NO];
}


#pragma mark - Image Upload Requests
- (void)uploadImage:(UIImage *)image toRegionNumber:(NSInteger)regionNumber delegate:(id)delegate
{
    self.delegate = delegate;
    
    self.requestType = RequestTypeUpload;

    NSData *imageData = UIImageJPEGRepresentation(image, 0.8);
    
    NSString *newURL = [NSString stringWithFormat:@"%@upload", PEGGSITE_API_URL];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:newURL]];
    [request setHTTPMethod:HTTP_POST];
    
    if(self.storedCookie)
    {
        [request addValue:self.storedCookie.value forHTTPHeaderField:COOKIE_HEADER];
    }
    
    NSString *boundary = @"----WebKitFormBoundaryaQQAFt1Bk9KVqAw6";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    
    NSMutableData *body = [NSMutableData data];
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name=\"region_num\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%li\r\n", (long)regionNumber] dataUsingEncoding:NSUTF8StringEncoding]];
    
    if(imageData)
    {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Disposition: form-data; name=\"file\"; filename=picture.jpg\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:imageData];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setHTTPBody:body];
    
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[body length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    NSString *parameterString = [[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding];
    
    NSLog(@"URL Request: %@ with parameters: %@", newURL, parameterString);
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         //[(PSViewController *)self.delegate hideLoader];
         
         if(data.length > 0)
         {
             NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
             NSLog(@"SUCCESSFUL UPLOAD: %@", str);
             id jsonData = [self parseJSONResponse:data];
             [self.delegate dataManager:self didReturnData:jsonData];
         }
         
     }];
}

- (void)uploadAvatar:(UIImage *)image delegate:(id)delegate
{
    self.delegate = delegate;

    self.requestType = RequestTypeUpload;
    
  /*  NSString *newURL = [NSString stringWithFormat:@"%@user/%@", PEGGSITE_API_URL, [User currentUser].userName];
    
    NSURL *url = [NSURL URLWithString:newURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = HTTP_POST;
    [request addValue:@"image/png" forHTTPHeaderField:@"Content-Type"];
    
    if(self.storedCookie)
        [request addValue:self.storedCookie.value forHTTPHeaderField:COOKIE_HEADER];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    NSData *bytes = UIImagePNGRepresentation(image);
    NSURLSessionUploadTask *task = [session uploadTaskWithRequest:request fromData:bytes completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
    {
        if(!error && [(NSHTTPURLResponse *)response statusCode] < 300)
        {
            id jsonData = [self parseJSONResponse:data];
           // NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            
        }
    }];
    
    [task resume];
*/
    NSData *imageData = UIImageJPEGRepresentation(image, 0.8);

    NSString *newURL = [NSString stringWithFormat:@"%@user/%@", PEGGSITE_API_URL, [User currentUser].userName];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:newURL]];
    [request setHTTPMethod:HTTP_POST];

    if(self.storedCookie)
    {
        [request addValue:self.storedCookie.value forHTTPHeaderField:COOKIE_HEADER];
    }

    NSString *boundary = @"----WebKitFormBoundaryaQQAFt1Bk9KVqAw6";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:contentType forHTTPHeaderField:@"Content-Type"];


    NSMutableData *body = [NSMutableData data];

    if(imageData)
    {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Disposition: form-data; name=\"avatar\"; filename=picture.jpg\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:imageData];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }

    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];

    [request setHTTPBody:body];

    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[body length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];

    NSString *parameterString = [[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding];

    NSLog(@"URL Request: %@ with parameters: %@", newURL, parameterString);

    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         if(data.length > 0)
         {
             NSLog(@"SUCCESS");
             id jsonData = [self parseJSONResponse:data];
             [self.delegate dataManager:self didReturnData:jsonData];
         }
         
     }];
}

- (void)startRequest:(NSString *)requestStr method:(NSString *)httpMethod postData:(NSData *)postData isJSON:(BOOL)isJSON
{
    //[(PSViewController *)self.delegate showLoader];
    
    if(self.currentTask)
        return;
    
    if(!self.session)
        self.session = [self configureSession];
    
    NSString *newURL = [NSString stringWithFormat:@"%@%@", PEGGSITE_API_URL, requestStr];
    
    NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
    
    NSLog(@"\nREQUEST: %@ with post data: %@", newURL, jsonString);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:newURL]];
    [request setHTTPMethod:httpMethod];

    if(self.storedCookie)
    {
        NSLog(@"COOKIE HEADER: %@", self.storedCookie.value);
        
        [request addValue:self.storedCookie.value forHTTPHeaderField:COOKIE_HEADER];
    }
    
    if(isJSON)
    {
        [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];

        [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

        [request addValue:[NSString stringWithFormat:@"%lu", (unsigned long)postData.length] forHTTPHeaderField:@"Content-Length"];
    }
    
    if(postData)
        request.HTTPBody = postData;
    
    self.responseData = [NSMutableData data];
    
    self.currentTask = [self.session dataTaskWithRequest:request];
    
    [self.currentTask resume];
    
    // This will allow us to queue requests
    
  //  RequestOperation *operation = [RequestOperation operationWithRequest:request andDelegate:self.delegate];
 /*
    // add response handler
    operation.completionHandler = ^(NSURLResponse *response, NSData *data, id delegate, NSError *error)
    {
        NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"Status Code: %li \nRESPONSE: %@", (long)[(NSHTTPURLResponse *)response statusCode], str);
        
        if(error)
        {
            UIAlertView *alert = [Utils createAlertWithPrefix:STRING_FAILED_REQUEST_PREFIX customMessage:error.localizedDescription showOther:NO andDelegate:nil];
            [alert show];
        }
        else
        {
            if([(NSHTTPURLResponse *)response statusCode] == HTTP_CODE_SUCCESS)
            {
                NSArray *newCookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:PEGGSITE_API_URL]];
                [self updateAuthKey:newCookies];
                
                id jsonData = [self parseJSONResponse:data];
                
                if(delegate)
                    [delegate dataManager:self didReturnData:jsonData];
            }
            else
            {
                UIAlertView *alert = [Utils createAlertWithPrefix:STRING_FAILED_REQUEST_PREFIX customMessage:[NSString stringWithFormat:@"%@", str] showOther:NO andDelegate:nil];
                [alert show];
                
                NSLog(@"Received bad status code: %li", (long)self.response.statusCode);
            }
        }
    };
    
    // make request
    [[RequestQueueManager mainQueue] addOperation:operation];
    
    
    
    self.responseData = [NSMutableData data];
    
#ifdef ALLOW_DUMMY_DATA
    id jsonData = [self getDummyData];
    [self.delegate dataManager:self didReturnData:jsonData];
   // [(PSViewController *)self.delegate hideLoader];
#else
 //   self.activeConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
#endif
    */
}

#pragma mark - NSURLConnectionDataDelegate Methods
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.responseData.length = 0;
    
    self.response = (NSHTTPURLResponse *)response;
    
  //  NSDictionary *responseHeader = [[NSDictionary alloc] initWithDictionary:[((NSHTTPURLResponse *)response) allHeaderFields]];
    
    // Log all headers in response
   // NSArray *keys = [responseHeader allKeys];
 //   for(NSString *key in keys)
   // {
      //  NSLog(@"%@ %@", key, responseHeader[key]);
   // }

}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.responseData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //if(self.delegate)
    //    [(PSViewController *)self.delegate hideLoader];
    
    NSString *str = [[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding];
    NSLog(@"\nRESPONSE: %@", str);

    if(self.response.statusCode == HTTP_CODE_SUCCESS)
    {
        NSArray *newCookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:PEGGSITE_API_URL]];
        [self updateCookies:newCookies];
        
        id jsonData = [self parseJSONResponse:self.responseData];
        
        if(self.delegate)
            [self.delegate dataManager:self didReturnData:jsonData];
    }
    else
    {
        UIAlertView *alert = [Utils createAlertWithPrefix:STRING_FAILED_REQUEST_PREFIX customMessage:[NSString stringWithFormat:@"%@", str] showOther:NO andDelegate:nil];
        [alert show];
        
        NSLog(@"Received bad status code: %li", (long)self.response.statusCode);
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
   // [(PSViewController *)self.delegate hideLoader];
    
    UIAlertView *alert = [Utils createAlertWithPrefix:STRING_FAILED_REQUEST_PREFIX customMessage:error.localizedDescription showOther:NO andDelegate:nil];
    [alert show];
    
    NSLog(@"Error: %@", error);
}

- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    NSURLCredential *credential = [NSURLCredential credentialWithUser:self.userName password:self.password persistence:NSURLCredentialPersistenceSynchronizable];
    [challenge.sender useCredential:credential forAuthenticationChallenge:challenge];
}

#pragma mark - NSURLSessionTaskDelegate Methods
/*
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didSendBodyData:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend
{
    dispatch_async(dispatch_get_main_queue(), ^
    {
        [self.delegate dataManager:self uploadProgress:((double)totalBytesSent / (double)totalBytesExpectedToSend)];
    });
}*/

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    self.responseData.length = 0;
    
    self.response = (NSHTTPURLResponse *)response;
    
    NSInteger status = [self.response statusCode];
    NSLog(@"Got RESPONSE: %ld", (long)status);
    
    if(status == HTTP_CODE_SUCCESS)
    {
        completionHandler(NSURLSessionResponseAllow);
    }
    else
    {
        UIAlertView *alert = [Utils createAlertWithPrefix:STRING_FAILED_REQUEST_PREFIX customMessage:[NSString stringWithFormat:@"Status Code: %li", (long)status] showOther:NO andDelegate:nil];
        [alert show];
        
        NSLog(@"Received bad status code: %li", (long)self.response.statusCode);
    }
    
    self.currentTask = nil;
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    [self.responseData appendData:data];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    NSLog(@"completed; error: %@", error);
    self.currentTask = nil;
    
    if(error)
    {
        UIAlertView *alert = [Utils createAlertWithPrefix:STRING_FAILED_REQUEST_PREFIX customMessage:[NSString stringWithFormat:@"%@", error.localizedDescription] showOther:NO andDelegate:nil];
        [alert show];
    }
    else
    {
        NSString *str = [[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding];
        NSLog(@"\nRESPONSE: %@", str);
        
        NSArray *newCookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:PEGGSITE_API_URL]];
            [self updateCookies:newCookies];
            
        id jsonData = [self parseJSONResponse:self.responseData];
            
        if(self.delegate)
            [self.delegate dataManager:self didReturnData:jsonData];

    }
}

/*
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    if(error)
    {
        UIAlertView *alert = [Utils createAlertWithPrefix:STRING_FAILED_REQUEST_PREFIX customMessage:[NSString stringWithFormat:@"%@", error.localizedDescription] showOther:NO andDelegate:nil];
        [alert show];
    }
    else
    {
        
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential *))completionHandler
{
    NSURLCredential *credential = [NSURLCredential credentialWithUser:self.userName password:self.password persistence:NSURLCredentialPersistenceForSession];
    [challenge.sender useCredential:credential forAuthenticationChallenge:challenge];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task willPerformHTTPRedirection:(NSHTTPURLResponse *)response newRequest:(NSURLRequest *)request completionHandler:(void (^)(NSURLRequest *))completionHandler
{
    
}
*/
- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential *))completionHandler
{
    NSURLCredential *credential = [NSURLCredential credentialWithUser:self.userName password:self.password persistence:NSURLCredentialPersistenceForSession];
    [challenge.sender useCredential:credential forAuthenticationChallenge:challenge];
    completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
}

#pragma mark - Dummy Data for offline testing purposes
- (id)getDummyData
{
    NSError *error;
    NSString *dummyPath = [NSString stringWithFormat:@"dummy_response_%li", (long)self.requestType];
    NSString *fullPath = [[NSBundle mainBundle] pathForResource:dummyPath ofType:@"txt"];
    NSString *dummyString = [NSString stringWithContentsOfFile:fullPath encoding:NSUTF8StringEncoding error:&error];

    NSData *dummyData = [NSData dataWithData:[dummyString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSString *str = [[NSString alloc] initWithData:dummyData encoding:NSUTF8StringEncoding];
    NSLog(@"\nDummy Data RESPONSE: %@", str);

    return [self parseJSONResponse:dummyData];
}

@end
