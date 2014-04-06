//
//  StopTime.h
//  ThanksNatureBusTimer
//
//  Created by Kashima Takumi on 2012/12/03.
//  Copyright (c) 2012年 TEAM TAKOYAKI. All rights reserved.
//

@interface CSVReader:NSObject
@property (nonatomic, retain) NSArray *lineOfFile;
- (id)initWithFile:(NSString *)filePath;
- (NSInteger)numberOfLine;
- (NSArray *)lineAtNumber:(NSInteger)number forDelimiter:(NSString *)delimiter;
@end
