//
//  DataManager.h
//  PeggSite
//
//  Created by Jennifer Duffey on 3/5/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DataManagerDelegate;

@interface DataManager : NSObject

@property (nonatomic, assign) RequestType requestType;
@property (nonatomic, weak) id <DataManagerDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *layouts;
@property (nonatomic, strong) NSString *deviceToken;

+ (DataManager *)sharedInstance;

#pragma mark - Login Requests
- (BOOL)checkUserName:(NSString *)userName;
- (void)createUserWithUserName:(NSString *)userName password:(NSString *)password email:(NSString *)email delegate:(id)delegate;
- (void)loginWithUserName:(NSString *)userName andPassword:(NSString *)password delegate:(id)delegate;
- (void)logoutWithDelegate:(id)delegate;
- (void)updatePasswordWithCurrentPassword:(NSString *)current newPassword:(NSString *)newPassword andVerifiedPassword:(NSString *)verified delegate:(id)delegate;
- (void)requestPasswordWithUsername:(NSString *)userName delegate:(id)delegate;
- (void)userLoggedOut;
- (void)addPushTokenWithDelegate:(id)delegate;
- (void)deletePushTokenWithDelegate:(id)delegate;

#pragma mark - User Requests
- (void)getUser:(NSString *)userName delegate:(id)delegate;
- (void)updateCurrentUser:(User *)user delegate:(id)delegate;
- (void)updateCurrentUserActivityWithDelegate:(id)delegate;
- (void)getActivityForUser:(NSString *)userName offset:(NSInteger)offset delegate:(id)delegate;

#pragma mark - Friend Requests
- (void)updateDateVisitedFriend:(User *)user delegate:(id)delegate;
- (void)updateFavoritedFriend:(User *)user isFavorite:(BOOL)isFavorite delegate:(id)delegate;
- (void)getFriendsForUser:(NSString *)userName limit:(NSInteger)limit offset:(NSInteger)offset filter:(NSString *)filter delegate:(id)delegate;
- (void)getFriendsForUser:(NSString *)userName offset:(NSInteger)offset delegate:(id)delegate;
- (void)getFriendsForUser:(NSString *)userName delegate:(id)delegate;
- (void)getFriendsOfUser:(NSString *)userName limit:(NSInteger)limit offset:(NSInteger)offset delegate:(id)delegate;
- (void)getFriendsOfUser:(NSString *)userName offset:(NSInteger)offset delegate:(id)delegate;
- (void)getFriendsOfUser:(NSString *)userName delegate:(id)delegate;
- (void)getRequestsForUser:(NSString *)userName delegate:(id)delegate;
- (void)getRequestsForUser:(NSString *)userName offset:(NSInteger)offset delegate:(id)delegate;
- (void)getRequestsForUser:(NSString *)userName limit:(NSInteger)limit offset:(NSInteger)offset delegate:(id)delegate;
- (void)addFriend:(NSInteger)friendID delegate:(id)delegate;
- (void)removeFriend:(NSInteger)friendID delegate:(id)delegate;
- (void)acceptRequest:(NSInteger)friendID delegate:(id)delegate;
- (void)declineRequest:(NSInteger)friendID delegate:(id)delegate;
- (void)searchUsersWithFilter:(NSString *)filter delegate:(id)delegate;

#pragma mark - Article Requests
- (void)getArticleWithID:(NSString *)articleID delegate:(id)delegate;
- (void)updateArticle:(Article *)article delegate:(id)delegate;
//- (void)updateArticleWithArticleID:(NSString *)articleID isLoved:(NSInteger)isLoved delegate:(id)delegate;
- (void)createArticleWithExternalMediaID:(NSString *)externalMediaID articleType:(ArticleType)articleType regionNumber:(NSInteger)regionNumber text:(NSString *)text caption:(NSString *)caption delegate:(id)delegate;
- (void)deleteArticle:(NSString *)articleID delegate:(id)delegate;
- (void)getLayoutsWithCompletionBlock:(void (^)(NSArray *layouts, NSError *error))completionBlock;
//- (void)getLoveForArticleID:(NSString *)articleID delegate:(id)delegate;
//- (void)getCommentsForArticleID:(NSString *)articleID delegate:(id)delegate;
- (void)postLoveForArticleID:(NSString *)articleID delegate:(id)delegate;
- (void)deleteLoveForArticleID:(NSString *)articleID delegate:(id)delegate;
- (void)postComment:(NSString *)comment forArticleID:(NSString *)articleID delegate:(id)delegate;
- (void)getActivityForArticleID:(NSString *)articleID delegate:(id)delegate;

#pragma mark - Image Upload Requests
- (void)uploadImage:(UIImage *)image toRegionNumber:(NSInteger)regionNumber delegate:(id)delegate;
- (void)uploadAvatar:(UIImage *)image delegate:(id)delegate;

@end

@protocol DataManagerDelegate

- (void)dataManager:(DataManager *)dataManager didReturnData:(id)data;
@optional
- (void)dataManager:(DataManager *)dataManager downloadProgress:(double)progress;
- (void)dataManager:(DataManager *)dataManager uploadProgress:(double)progress;

@end
