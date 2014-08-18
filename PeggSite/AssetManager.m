//
//  AssetManager.m
//  PeggSite
//
//  Created by Jennifer Duffey on 6/13/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import "AssetManager.h"

@implementation AssetManager

static AssetManager *sharedInstance = nil;

+ (AssetManager *)sharedInstance
{
    static dispatch_once_t pred;
    
    dispatch_once(&pred, ^
    {
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

+ (ALAssetsLibrary *)defaultAssetsLibrary
{
    static dispatch_once_t pred = 0;
    static ALAssetsLibrary *library = nil;
    dispatch_once(&pred, ^
    {
        library = [[ALAssetsLibrary alloc] init];
    });
    
    return library;
}

- (id)init
{
    self = [super init];
    
    if(self)
    {
        
    }
    
    return self;
}

- (void)loadThumbnailAssetWithCompletionBlock:(void (^)(UIImage *image, NSError *error))completionBlock
{
    ALAssetsLibrary *library = [AssetManager defaultAssetsLibrary];
    
    dispatch_queue_t dispatchQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(dispatchQueue, ^(void)
   {
       [library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop)
        {
            [group enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop)
             {
                 __block BOOL foundThePhoto = NO;
                 
                 if(foundThePhoto)
                 {
                     *stop = YES;
                 }
                 
                 NSString *assetType = [result valueForProperty:ALAssetPropertyType];
                 
                 if([assetType isEqualToString:ALAssetTypePhoto])
                 {
                     foundThePhoto = YES;
                     *stop = YES;
                     
                     dispatch_async(dispatch_get_main_queue(), ^(void)
                    {
                        CGImageRef imageReference = [result thumbnail];
                                        
                        // construct the image
                        UIImage *image = [[UIImage alloc] initWithCGImage:imageReference];
                                        
                        completionBlock(image, nil);
                    });
                 }
                 
             }];
        }
        failureBlock:^(NSError *error)
        {
            completionBlock(nil, error);
            
            NSLog(@"Error loading image: %@", error);
        }];
   });
}

- (void)loadImageAssetWithCompletionBlock:(void (^)(UIImage *image, NSError *error))completionBlock
{
    ALAssetsLibrary *library = [AssetManager defaultAssetsLibrary];
    
    dispatch_queue_t dispatchQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(dispatchQueue, ^(void)
    {
        [library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop)
         {
             [group enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop)
             {
                 __block BOOL foundThePhoto = NO;
                 
                 if(foundThePhoto)
                 {
                     *stop = YES;
                 }
                 
                 NSString *assetType = [result valueForProperty:ALAssetPropertyType];
                 
                 if([assetType isEqualToString:ALAssetTypePhoto])
                 {
                     foundThePhoto = YES;
                     *stop = YES;
                     
                     // Get the asset's representation object
                     ALAssetRepresentation *assetRep = [result defaultRepresentation];
                     
                     // we need the scale and orientation to be able to construct a properly oriented and scaled UIImage out of the representation object
                     CGFloat imageScale = [assetRep scale];
                     
                     UIImageOrientation imageOrientation = (UIImageOrientation)[assetRep orientation];
                     
                     dispatch_async(dispatch_get_main_queue(), ^(void)
                    {
                        CGImageRef imageReference = [assetRep fullResolutionImage];
                        
                        // construct the image
                        UIImage *image = [[UIImage alloc] initWithCGImage:imageReference scale:imageScale orientation:imageOrientation];
                        
                        completionBlock(image, nil);
                    });
                 }
                 
              }];
        }
        failureBlock:^(NSError *error)
        {
             completionBlock(nil, error);
             
             NSLog(@"Error loading image: %@", error);
         }];
    });
}

- (void)loadAssetsWithCompletionBlock:(void (^)(NSArray *assets, NSError *error))completionBlock
{
    NSMutableArray *assetArray = [NSMutableArray array];
    
    ALAssetsLibrary *library = [AssetManager defaultAssetsLibrary];
    
    [library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop)
    {
        [group enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop)
        {
            if(result)
            {
                [assetArray addObject:result];
            }
        }];
        
        completionBlock(assetArray, nil);
    }
    failureBlock:^(NSError *error)
    {
        completionBlock(nil, error);
        
        NSLog(@"Error loading images: %@", error);
    }];
}

@end
