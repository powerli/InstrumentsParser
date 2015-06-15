//
//  main.m
//  InstrumentsParser
//
//  Created by pantengfei on 14-7-29.
//  Copyright (c) 2014年 ___bidu___. All rights reserved.
//

#import <Foundation/Foundation.h>

//instruments run data base class
@interface XRRun : NSObject
{
    NSDateFormatter *dateFormatter;
	NSUInteger runNumber;
	NSTimeInterval startTime;
	NSTimeInterval endTime;
	
	NSMutableArray *trackSegments;
	NSMutableDictionary *runData;
	
    NSNumber *pid;
    BOOL launchControlProperties;
    BOOL args;
	BOOL envVals;
	BOOL execname;
	BOOL terminateTaskAtStop;
}

- (id)initWithCoder:(NSCoder *)decoder;

@end

