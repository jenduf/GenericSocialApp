//
//  RequestQueueManager.m
//  PeggSite
//
//  Created by Jennifer Duffey on 7/17/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import "RequestQueueManager.h"

@interface RequestQueueManager ()

@property (strong, nonatomic) NSMutableArray *operations;

@end

@implementation RequestQueueManager

+ (instancetype)mainQueue
{
    static RequestQueueManager *mainQueue = nil;
    if(mainQueue == nil)
    {
        mainQueue = [[RequestQueueManager alloc] init];
    }
    
    return mainQueue;
}

- (id)init
{
    self = [super init];
    
    if(self)
    {
        _queueMode = RequestQueueModeFirstInFirstOut;
        _operations = [[NSMutableArray alloc] init];
        _maxConcurrentRequestCount = 2;
        _allowDuplicateRequests = NO;
    }
    
    return self;
}

- (NSUInteger)requestCount
{
    return self.operations.count;
}

- (NSArray *)requests
{
    return [self.operations valueForKeyPath:@"request"];
}

- (void)dequeueOperations
{
    if(!self.suspended)
    {
        NSInteger count = MIN(self.operations.count, self.maxConcurrentRequestCount ?: INT_MAX);
        for(NSInteger i = 0; i < count; i++)
        {
            [(RequestOperation *)self.operations[i] start];
        }
    }
}

#pragma mark - Public Methods
- (void)setSuspended:(BOOL)suspended
{
    _suspended = suspended;
    
    [self dequeueOperations];
}

- (void)addOperation:(RequestOperation *)operation
{
    if(!self.allowDuplicateRequests)
    {
        for(RequestOperation *op in [self.operations reverseObjectEnumerator])
        {
            if([op.request isEqual:operation.request])
            {
                [op cancel];
            }
        }
    }
    
    NSUInteger index = 0;
    if(self.queueMode == RequestQueueModeFirstInFirstOut)
    {
        index = self.operations.count;
    }
    else
    {
        for(RequestOperation *op in self.operations)
        {
            if(![op isExecuting])
            {
                break;
            }
            
            index++;
        }
    }
    
    if(index < self.operations.count)
    {
        [self.operations insertObject:operation atIndex:index];
    }
    else
    {
        [self.operations addObject:operation];
    }
    
    [operation addObserver:self forKeyPath:@"isExecuting" options:NSKeyValueObservingOptionNew context:NULL];
    
    [self dequeueOperations];
}

- (void)addRequest:(NSURLRequest *)request withDelegate:(id)del completionHandler:(ROCompletionHandler)completionHandler
{
    RequestOperation *operation = [RequestOperation operationWithRequest:request andDelegate:del];
    operation.completionHandler = completionHandler;
    [self addOperation:operation];
}

- (void)cancelRequest:(NSURLRequest *)request
{
    for(RequestOperation *op in self.operations.reverseObjectEnumerator)
    {
        if(op.request == request)
        {
            [op cancel];
        }
    }
}

- (void)cancelAllRequests
{
    NSArray *operationsCopy = self.operations;
    self.operations = [NSMutableArray array];
    [operationsCopy makeObjectsPerformSelector:@selector(cancel)];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"isExecuting"])
    {
        RequestOperation *operation = object;
        if(!operation.executing)
        {
            [operation removeObserver:self forKeyPath:keyPath];
            [self.operations removeObject:operation];
            [self dequeueOperations];
        }
    }
}


@end
