//
//  ViewController.h
//  ThanksNatureBusTimer
//
//  Created by Kashima Takumi on 2012/12/03.
//  Copyright (c) 2012年 TEAM TAKOYAKI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MainViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@end
