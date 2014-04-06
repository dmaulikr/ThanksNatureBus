//
//  StopTime.m
//  ThanksNatureBusTimer
//
//  Created by Kashima Takumi on 2012/12/03.
//  Copyright (c) 2012年 TEAM TAKOYAKI. All rights reserved.
//

#import "CSVReader.h"

@implementation CSVReader
@synthesize lineOfFile = _lineOfFile;

- (id)initWithFile:(NSString *)filePath
{
    NSString *fileStream = [NSString stringWithContentsOfFile:filePath
                                               encoding:NSUTF8StringEncoding
                                                  error:nil];
    _lineOfFile = [fileStream componentsSeparatedByString:@"\n"];
    
    return self;
}

- (NSInteger)numberOfLine
{
    return [self.lineOfFile count];
}

- (NSArray *)lineAtNumber:(NSInteger)number forDelimiter:(NSString *)delimiter {
    if (delimiter == nil) {
        delimiter = @",";
    }
    return [[self.lineOfFile objectAtIndex:number] componentsSeparatedByString:delimiter];
}

@end