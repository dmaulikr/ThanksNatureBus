//
//  AppManager.m
//  illustCamera
//
//  Created by Kashima Takumi on 2014/02/22.
//  Copyright (c) 2014年 TEAM TAKOYAKI. All rights reserved.
//

#import "BusStop.h"

@interface BusStop()
@end

@implementation BusStop

- (id)init
{
    BusStop *busStop = [super init];
    if (busStop) {
        [self initWithSettings];
    }
    return busStop;
}

- (void)initWithSettings
{
    self.name = @"Hello, world";
}

@end
