//
//  main.m
//  InstrumentsParser
//
//  Created by pantengfei on 14-7-29.
//  Copyright (c) 2014年 ___bidu___. All rights reserved.
//

#import "XRRun.h"

#define targetProcess @"Recipes"

@implementation XRRun

- (id)initWithCoder:(NSCoder *)decoder
{
    if((self = [super init]))
    {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss:SSS"];
        startTime = [[decoder decodeObject] doubleValue];
        endTime   = [[decoder decodeObject] doubleValue];
        runNumber = [[decoder decodeObject] unsignedIntegerValue];

        trackSegments = [decoder decodeObject];
        
        // Totally not sure about these
        envVals = [[decoder decodeObject] boolValue];
        execname = [[decoder decodeObject] boolValue];
        terminateTaskAtStop = [[decoder decodeObject] boolValue];
        pid = [decoder decodeObject][@"_pid"];
        launchControlProperties = [[decoder decodeObject] boolValue];
        args = [[decoder decodeObject] boolValue];
        [decoder decodeObject];
        [decoder decodeObject];
        [decoder decodeObject]; //patch for XCode 7
    }
    return self;
}

- (void)dealloc
{
}


@end