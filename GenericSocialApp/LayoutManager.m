//
//  LayoutManager.m
//  PeggSite
//
//  Created by Jennifer Duffey on 3/21/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import "LayoutManager.h"
#import "DataManager.h"
#import "Layout.h"
#import "Region.h"
#import "User.h"

@interface LayoutManager()
{
    User *currentUser;
    void(^returnBlock)(NSArray *regions, NSError *error);
}
@end

@implementation LayoutManager

static LayoutManager *sharedInstance = nil;

+ (LayoutManager *)sharedInstance
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
        
    }
    
    return self;
}

- (void)getLayouts
{
    self.layouts = [[NSMutableArray alloc] init];
    
    [[DataManager sharedInstance] getLayoutsWithCompletionBlock:^(NSArray *layouts, NSError *error)
     {
         for(NSDictionary *dict in layouts)
         {
             Layout *layout = [[Layout alloc] initWithDictionary:dict];
             
             [self.layouts addObject:layout];
         }
         
         [self getRegionsForUser:currentUser withCompletionBlock:returnBlock];
     }];
}

- (void)getRegionsForUser:(User *)user withCompletionBlock:(void (^)(NSArray *regions, NSError *error))completionBlock
{
    if(!self.layouts)
    {
        currentUser = user;
        returnBlock = completionBlock;
        [self getLayouts];
        return;
    }
    
   //  NSMutableDictionary *regionDictionary = [NSMutableDictionary dictionary];
     
     for(Layout *layout in self.layouts)
     {
         if(layout.layoutID == user.layoutID)
         {
             completionBlock(layout.regions, nil);
             //for(Region *region in layout.regions)
             //{
               //  regionDictionary[@(region.regionNumber)] = region;
             //}
             
             break;
         }
     }
     
    // completionBlock(regionDictionary, nil);
}

@end
