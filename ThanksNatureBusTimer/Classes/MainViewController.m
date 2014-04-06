//
//  ViewController.m
//  ThanksNatureBusTimer
//
//  Created by Kashima Takumi on 2012/12/03.
//  Copyright (c) 2012年 TEAM TAKOYAKI. All rights reserved.
//

#import "MainViewController.h"
#import "AppManager.h"
#import "CustomCell.h"

// 現在地を特定するまでの位置情報更新回数
#define MAX_UPDATE_LOCATION_COUNT 3

@interface MainViewController () <CLLocationManagerDelegate>
@property (nonatomic, assign) NSInteger updateLocationCount;
@end

@implementation MainViewController 

- (void)viewDidLoad
{
    [super viewDidLoad];

    // TableViewの準備
    _tableView.delegate = self;
    [_tableView registerNib:[UINib nibWithNibName:@"CustomCell" bundle:nil] forCellReuseIdentifier:@"CustomCell"];
    
    _updateLocationCount = 0;

    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    if ([CLLocationManager locationServicesEnabled] == YES) {
        locationManager.delegate = self;
        [locationManager startUpdatingLocation];
    } else {
        NSLog(@"位置情報サービスが有効ではありません");
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *busStop = [[AppManager sharedManager] busStop];
    return [busStop count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CustomCell"];
    BusStop *busStop = [[[AppManager sharedManager] busStop] objectAtIndex:indexPath.row];
    cell.label.text = busStop.name;
    
    return cell;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    _updateLocationCount += 1;
    
    if (MAX_UPDATE_LOCATION_COUNT <= _updateLocationCount) {
        // 位置情報の更新をとめる
        [manager stopUpdatingLocation];
        
        NSLog(@"現在地: %f, %f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
}

@end
