//
//  TimeViewController.m
//  ThanksNatureBusTimer
//
//  Created by Kashima Takumi on 2012/12/03.
//  Copyright (c) 2012年 TEAM TAKOYAKI. All rights reserved.
//

#import "TimeViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "CSVReader.h"

#define KRootStartNumber 1
#define KRootEndNumber   7
#define YRootStartNumber 8
#define YRootEndNumber   15

@interface TimeViewController () <CLLocationManagerDelegate>

@end

@implementation TimeViewController
@synthesize nearStopLabel = _nearStopLabel;
@synthesize rootType = _rootType;

NSInteger startNumber;
NSInteger endNumber;
CLLocationManager *locationManager;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (NSDate *)nearStopTimeFromStop:(NSInteger)stopNumber andDate:(NSDate *)date
{
    NSDate *nearStopTime = nil;
    NSString *formatDateString;
    NSDictionary *dateDictionary = [self dictionaryFromDate:date];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"stoptime" ofType:@"csv"];
    CSVReader *csvReader = [[CSVReader alloc] initWithFile:filePath];
    
    NSArray *timeOfStops = [csvReader lineAtNumber:stopNumber forDelimiter:nil];
    NSString *timeOfStop;
    
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"ja_JP"] autorelease]];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"JST"]];
    [formatter setDateFormat:@"YYYYMMddHHmm"];
    
    NSDate *stopTime;
    NSDictionary *stopTimeDictionary;
    NSInteger timeHour = [[dateDictionary objectForKey:@"hour"] intValue];
    NSInteger timeMinute = [[dateDictionary objectForKey:@"minute"] intValue];
    for (NSInteger x = 3; x < [timeOfStops count]; x++) {
        timeOfStop = [timeOfStops objectAtIndex:x];
        formatDateString = [NSString stringWithFormat:@"%@%@%@%@",
                                [dateDictionary objectForKey:@"year"],
                                [dateDictionary objectForKey:@"month"],
                                [dateDictionary objectForKey:@"day"], timeOfStop];
        stopTime = [formatter dateFromString:formatDateString];
        stopTimeDictionary = [self dictionaryFromDate:stopTime];
        NSInteger stopTimeHour = [[stopTimeDictionary objectForKey:@"hour"] intValue];
        NSInteger stopTimeMinute = [[stopTimeDictionary objectForKey:@"minute"] intValue];
        
        if (timeHour < stopTimeHour || (timeHour == stopTimeHour && timeMinute <= stopTimeMinute)) {
            nearStopTime = stopTime;
            break;
        }
    }
    return nearStopTime;
}

- (NSDictionary *)dictionaryFromDate:(NSDate *)date
{
    NSDateComponents* components = [[NSCalendar currentCalendar]
                                        components:NSYearCalendarUnit   |
                                                   NSMonthCalendarUnit  |
                                                   NSDayCalendarUnit    |
                                                   NSHourCalendarUnit   |
                                                   NSMinuteCalendarUnit |
                                                   NSSecondCalendarUnit
                                          fromDate:date];
    NSString *year = [NSString stringWithFormat:@"%d", [components year] + 1];
    NSString *month = [NSString stringWithFormat:@"%d", [components month]];
    NSString *day = [NSString stringWithFormat:@"%d", [components day]];
    NSString *hour = [NSString stringWithFormat:@"%d", [components hour]];
    NSString *minute = [NSString stringWithFormat:@"%d", [components minute]];
    NSString *second = [NSString stringWithFormat:@"%d", [components second]];
    
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys: year, @"year", month, @"month", day, @"day", hour, @"hour", minute, @"minute", second, @"second", nil];
    
    return dictionary;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    CLLocation *nowLocation = [[CLLocation alloc] initWithLatitude:[newLocation coordinate].latitude longitude:[newLocation coordinate].longitude];
    NSInteger nearStopNumber = [self getNearStopNumberAtLocation:nowLocation AndRootType:0];
    
    if (nearStopNumber >= 0) {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"stoptime" ofType:@"csv"];
        CSVReader *csvReader = [[CSVReader alloc] initWithFile:filePath];
    
        NSArray *timeOfStops = [csvReader lineAtNumber:nearStopNumber forDelimiter:nil];
        NSString *nearStop = [timeOfStops objectAtIndex:0];
    
        NSDate *nearStopTime = [self nearStopTimeFromStop:nearStopNumber andDate:[NSDate date]];
        [_nearStopLabel setText:[NSString stringWithFormat:@"%@\n%@", nearStop, nearStopTime]];
        [locationManager stopUpdatingLocation];
    } else {
        [_nearStopLabel setText:@"近くにThanks Nature Busの停留所はありません"];
    }
}

- (NSInteger)getNearStopNumberAtLocation:(CLLocation *)nowLocation AndRootType:(NSInteger)rootType
{
    NSInteger nearStopNumber = 0;
    double nearStopLocation = 9999999;
    NSArray *timeOfStop;
    CLLocation *stopLocation;
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"stoptime" ofType:@"csv"];
    CSVReader *csvReader = [[CSVReader alloc] initWithFile:filePath];

    if (_rootType == KRootStartNumber) {
        startNumber = KRootStartNumber - 1;
        endNumber   = KRootEndNumber;
    } else if (_rootType == YRootStartNumber) {
        startNumber = YRootStartNumber - 1;
        endNumber   = YRootEndNumber;
    } else {
        startNumber = 0;
        endNumber = [csvReader numberOfLine];
    }
    
    for (int x = startNumber; x < endNumber; x++) {
        timeOfStop = [csvReader lineAtNumber:x forDelimiter:nil];
        stopLocation = [[CLLocation alloc] initWithLatitude:[[timeOfStop objectAtIndex:1] doubleValue] longitude:[[timeOfStop objectAtIndex:2] doubleValue]];
        CLLocationDistance distance = [stopLocation distanceFromLocation:nowLocation];
    
        if (distance < nearStopLocation) {
            nearStopNumber = x;
            nearStopLocation = distance;
        }
    }
    
    if (nearStopLocation > 1000) {
        return -1;
    }
    NSLog(@"%f", nearStopLocation);
    return nearStopNumber;
}

// 測位失敗時や、5位置情報の利用をユーザーが「不許可」とした場合などに呼ばれる
- (void)locationManager:(CLLocationManager *)manager 
didFailWithError:(NSError *)error{
    [_nearStopLabel setText:@"位置を取得できませんでした"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    locationManager = [[CLLocationManager alloc] init];
    if ([CLLocationManager locationServicesEnabled] == YES) {
        locationManager.delegate = self;
        [locationManager startUpdatingLocation];
    } else {
        NSLog(@"Location services not available");
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_nearStopLabel release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setNearStopLabel:nil];
    [super viewDidUnload];
}
@end
