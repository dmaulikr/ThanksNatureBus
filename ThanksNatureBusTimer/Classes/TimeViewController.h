//
//  TimeViewController.h
//  ThanksNatureBusTimer
//
//  Created by Kashima Takumi on 2012/12/03.
//  Copyright (c) 2012年 TEAM TAKOYAKI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimeViewController : UIViewController
@property (nonatomic, assign) NSInteger rootType;
@property (retain, nonatomic) IBOutlet UILabel *nearStopLabel;
@end
