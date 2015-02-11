//
//  RequestOperation.h
//  PeggSite
//
//  Created by Jennifer Duffey on 7/17/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ROCompletionHandler)(NSURLResponse *response, NSData *data, id delegate, NSError *error);
typedef void (^ROProgressHandler)(float progress, NSInteger bytesTransferred, NSInteger totalBytes);
typedef void (^ROAuthenticationChallengeHandler)(NSURLAuthenticationChallenge *challenge);

@interface RequestOperation : NSObject
<NSURLConnectionDataDelegate>

@property (nonatomic, strong, readonly) NSURLRequest *request;
@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, strong) NSURLResponse *responseReceived;
@property (nonatomic, strong) NSMutableData *accumulatedData;
@property (nonatomic, weak) id <DataManagerDelegate> delegate;

@property (nonatomic, copy) NSSet *autoRetryErrorCodes;
@property (nonatomic, assign) NSTimeInterval autoRetryDelay;
@property (nonatomic, assign) BOOL autoRetry;


@property (nonatomic, getter = isExecuting) BOOL executing;
@property (nonatomic, getter = isFinished) BOOL finished;
@property (nonatomic, getter = isCancelled) BOOL cancelled;

@property (nonatomic, copy) ROCompletionHandler completionHandler;
@property (nonatomic, copy) ROProgressHandler uploadProgressHandler, downloadProgressHandler;
@property (nonatomic, copy) ROAuthenticationChallengeHandler authenticationChallengeHandler;

+ (instancetype)operationWithRequest:(NSURLRequest *)request andDelegate:(id)del;
- (instancetype)initWithRequest:(NSURLRequest *)request andDelegate:(id)del;

- (void)start;
- (void)cancel;
- (void)finish;

@end
