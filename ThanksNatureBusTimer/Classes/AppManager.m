//
//  AppManager.m
//  illustCamera
//
//  Created by Kashima Takumi on 2014/02/22.
//  Copyright (c) 2014年 TEAM TAKOYAKI. All rights reserved.
//

#import "AppManager.h"

@interface AppManager()
@end

@implementation AppManager
static AppManager* sharedInstance = nil;
 
+ (id)sharedManager
{
    //static SingletonTest* sharedSingleton;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[AppManager alloc]init];
    });
    return sharedInstance;
}

- (id)init
{
    AppManager *manager = [super init];
    if (manager) {
        [self initWithSettings];
    }
    return manager;
}

- (void)initWithSettings
{
    self.busStop = [[NSMutableArray alloc] init];
    [_busStop addObject:[[BusStop alloc] init]];
    [_busStop addObject:[[BusStop alloc] init]];    
}

@end
