//
//  XRStreamedPowerRun.m
//  InstrumentsParser
//
//  Created by baidu on 14/11/5.
//  Copyright (c) 2014年 ___bidu___. All rights reserved.
//

#import "XRStreamedPowerRun.h"

@implementation XRStreamedPowerRun

- (NSString *)description
{
    NSString *start = [NSDateFormatter localizedStringFromDate:[NSDate dateWithTimeIntervalSince1970:startTime] dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterMediumStyle];
    NSString *end = [NSDateFormatter localizedStringFromDate:[NSDate dateWithTimeIntervalSince1970:endTime] dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterMediumStyle];
    
    NSMutableString *result = [NSMutableString stringWithFormat:@"Run %u, starting at %@, running until %@. trackSegments %@, pid %@.\n", (unsigned int)runNumber, start, end, trackSegments, pid];
    [result appendFormat:@"_StartTime_:%lf,_EndTime_:%lf.\n", startTime, endTime];
    return result;
}

- (double) getStartTime
{
    return startTime;
}

@end