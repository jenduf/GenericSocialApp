//
//  ModalAlertDelegate.m
//  PeggSite
//
//  Created by Jennifer Duffey on 4/29/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import "ModalAlert.h"

@implementation ModalAlert

- (id)init
{
    self = [super init];
    
    if(self)
    {
        
    }
    
    return self;
}

+ (instancetype)delegateWithAlert:(UIAlertView *)alert
{
    return [[ModalAlert alloc] init];
}

/*
- (id)initwithAlert:(UIAlertView *)alert
{
    self = [super init];
    
    if(self)
    {
        
    }
    
    return self;
}*/

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
}

- (NSInteger)show
{
    return 0;
}

@end
