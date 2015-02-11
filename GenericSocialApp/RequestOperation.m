//
//  RequestOperation.m
//  PeggSite
//
//  Created by Jennifer Duffey on 7/17/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import "RequestOperation.h"

@implementation RequestOperation

+ (instancetype)operationWithRequest:(NSURLRequest *)request andDelegate:(id)del
{
    return [[self alloc] initWithRequest:request andDelegate:del];
}

- (instancetype)initWithRequest:(NSURLRequest *)request andDelegate:(id)del
{
    self = [super init];
    
    if(self)
    {
        _delegate = del;
        
        _request = request;
        _autoRetryDelay = 5.0;
        _connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
    }
    
    return self;
}

- (BOOL)isConcurrent
{
    return YES;
}

- (void)start
{
    @synchronized (self)
    {
        if(!self.executing && !self.cancelled)
        {
            [self willChangeValueForKey:@"isExecuting"];
            self.executing = YES;
            [self.connection scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
            [self.connection start];
            [self didChangeValueForKey:@"isExecuting"];
        }
    }
}

- (void)cancel
{
    @synchronized(self)
    {
        if(!self.cancelled)
        {
            [self willChangeValueForKey:@"isCancelled"];
            self.cancelled = YES;
            [self.connection cancel];
            [self didChangeValueForKey:@"isCancelled"];
            
            // callback
            NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorCancelled userInfo:nil];
            [self connection:self.connection didFailWithError:error];
        }
    }
}

- (void)finish
{
    @synchronized(self)
    {
        if(self.executing && !self.finished)
        {
            [self willChangeValueForKey:@"isExecuting"];
            [self willChangeValueForKey:@"isFinished"];
            self.executing = NO;
            self.finished = YES;
            [self didChangeValueForKey:@"isFinished"];
            [self didChangeValueForKey:@"isExecuting"];
        }
    }
}

- (NSSet *)autoRetryErrorCodes
{
    if(!_autoRetryErrorCodes)
    {
        static NSSet *codes = nil;
        
        if(!codes)
        {
            codes = [NSSet setWithObjects:
                     @(NSURLErrorTimedOut),
                     @(NSURLErrorCannotFindHost),
                     @(NSURLErrorCannotConnectToHost),
                     @(NSURLErrorDNSLookupFailed),
                     @(NSURLErrorNotConnectedToInternet),
                     @(NSURLErrorNetworkConnectionLost)
                     , nil];
        }
        
        return codes;
    }
    
    return _autoRetryErrorCodes;
}

#pragma mark - NSURLConnectionDelegate Methods
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if(self.autoRetry && [self.autoRetryErrorCodes containsObject:@(error.code)])
    {
        self.connection = [[NSURLConnection alloc] initWithRequest:self.request delegate:self startImmediately:NO];
        [self.connection performSelector:@selector(start) withObject:nil afterDelay:self.autoRetryDelay];
    }
    else
    {
        [self finish];
        
        if(self.completionHandler)
        {
            self.completionHandler(self.responseReceived, self.accumulatedData, self.delegate, error);
        }
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    if(self.authenticationChallengeHandler)
    {
        self.authenticationChallengeHandler(challenge);
    }
    else
    {
        [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.responseReceived = response;
}

- (void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{
    if(self.uploadProgressHandler)
    {
        float progress = (float)totalBytesWritten / (float)totalBytesExpectedToWrite;
        self.uploadProgressHandler(progress, totalBytesWritten, totalBytesExpectedToWrite);
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if(!self.accumulatedData)
    {
        self.accumulatedData = [[NSMutableData alloc] initWithCapacity:MAX(0, self.responseReceived.expectedContentLength)];
    }
    
    [self.accumulatedData appendData:data];
    
    if(self.downloadProgressHandler)
    {
        NSInteger bytesTransferred = self.accumulatedData.length;
        NSInteger totalBytes = MAX(0, self.responseReceived.expectedContentLength);
        self.downloadProgressHandler((float)bytesTransferred / (float)totalBytes, bytesTransferred, totalBytes);
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self finish];
    
    NSError *error = nil;
    
    if([self.responseReceived respondsToSelector:@selector(statusCode)])
    {
        // treat status codes >= 400 as an error
        NSInteger statusCode = [(NSHTTPURLResponse *)self.responseReceived statusCode];
        if(statusCode / 100 >= 4)
        {
            NSString *message = [NSString stringWithFormat:NSLocalizedString(@"The server returned a %i error", @"RequestQueue HTTPResponse error message format"), statusCode];
            NSDictionary *infoDict = @{ NSLocalizedDescriptionKey : message };
            error = [NSError errorWithDomain:HTTP_RESPONSE_ERROR_DOMAIN code:statusCode userInfo:infoDict];
        }
    }
    
    if(self.completionHandler)
        self.completionHandler(self.responseReceived, self.accumulatedData, self.delegate, error);
}

@end
