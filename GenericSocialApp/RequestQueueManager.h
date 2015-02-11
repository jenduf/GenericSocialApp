//
//  RequestQueueManager.h
//  PeggSite
//
//  Created by Jennifer Duffey on 7/17/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RequestOperation.h"

@interface RequestQueueManager : NSObject

@property (nonatomic, assign) NSUInteger maxConcurrentRequestCount;
@property (nonatomic, getter = isSuspended) BOOL suspended;
@property (nonatomic, readonly) NSUInteger requestCount;
@property (nonatomic, copy, readonly) NSArray *requests;
@property (nonatomic, assign) RequestQueueMode queueMode;
@property (nonatomic, assign) BOOL allowDuplicateRequests;

+ (instancetype)mainQueue;

- (void)addOperation:(RequestOperation *)operation;
- (void)addRequest:(NSURLRequest *)request withDelegate:(id)del completionHandler:(ROCompletionHandler)completionHandler;
- (void)cancelRequest:(NSURLRequest *)request;
- (void)cancelAllRequests;

@end
