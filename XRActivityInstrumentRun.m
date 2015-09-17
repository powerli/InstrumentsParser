//
//  XRActivityInstrumentRun.m
//  InstrumentsParser
//
//  Created by pantengfei on 14-7-29.
//  Copyright (c) 2014年 ___bidu___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XRActivityInstrumentRun.h"
#import "InstrumentsParserApp.h"


//@implementation XRActivityInstrumentRun
@implementation XRActivityInstrumentRun


- (NSString *)formattedSample:(NSUInteger)index processName:targetProcess
{
    NSDictionary *data = sampleData[index];
    NSMutableString *result = [NSMutableString string];
    double relativeTimestamp = [data[@"XRActivityClientTraceRelativeTimestamp"] doubleValue];
    double seconds = relativeTimestamp / 1000.0 / 1000.0 / 1000.0;
    NSTimeInterval timestamp = startTime + seconds;
    [result appendFormat:@"Process: %@ ", targetProcess];
    
    NSArray *processData = data[@"Processes"];
    for (NSDictionary *process in processData) {
        if ([process[@"Command"] isEqualToString:targetProcess]) {
            double cpuUsage = [process[@"CPUUsage"] doubleValue];
            double residentSize = [process[@"ResidentSize"] doubleValue] / 1024;
            double virtualSize = [process[@"VirtualSize"] doubleValue] / 1024;
            [result appendFormat:@"CPU Usage: %.2f%% ", cpuUsage];
            [result appendFormat:@"Res Size: %.2f KiB ", residentSize];
            [result appendFormat:@"Virt Size: %.2f KiB ", virtualSize];
            break;
        }
    }
    [result appendFormat:@"Timestamp: %@ ", [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:timestamp]]];
    return result;
}

- (NSString *)description
{
    InstrumentsParserApp *shareAppData = [InstrumentsParserApp getInstance];
    NSString *appname = [shareAppData appname];
    if (!appname) {
        NSLog(@"get appname nil,cannot dump XRActivityInstrumentRun data");
        return nil;
    }
    
    NSString *start = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:startTime]];
    NSString *end = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:endTime]];
    NSMutableString *result = [NSMutableString stringWithFormat:@"Run %u, starting at %@, running until %@\n", (unsigned int)runNumber, start, end];
    //NSLog(@"sampledata length is %lu",(unsigned long)[sampleData count]);
    for(NSUInteger i=0; i<[sampleData count]; i++)
    {
        [result appendFormat:@"Sample %u: %@\n", (unsigned int)i, [self formattedSample:i processName:appname]];
    }
    return result;
}

- (NSString *) toJsonString
{
    InstrumentsParserApp *shareAppData = [InstrumentsParserApp getInstance];
    NSString *appname = [shareAppData appname];
    if (!appname) {
        NSLog(@"get appname nil,cannot dump XRActivityInstrumentRun data");
        return nil;
    }
    
    //instrument get process name max length = 16
    if ([appname length] >= 16) {
        NSString *tmpname = [appname substringToIndex:16];
        appname = tmpname;
    }

    NSMutableArray *newArray = [[NSMutableArray alloc] init];
    
    for (NSUInteger i=0; i<[sampleData count]; i++) {
        NSDictionary *data = sampleData[i];
        
        double relativeTimestamp = [data[@"XRActivityClientTraceRelativeTimestamp"] doubleValue];
        double seconds = relativeTimestamp / 1000.0 / 1000.0 / 1000.0;
        NSTimeInterval timestamp = startTime + seconds;
        
        NSArray *processData = data[@"Processes"];
        for (NSDictionary *process in processData) {
            if ([process[@"Command"] isEqualToString:appname]) {
                NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                [dict addEntriesFromDictionary:process];
                [dict setObject:[NSNumber numberWithDouble:timestamp] forKey:@"Timestamp"];
                [dict setObject:[dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:timestamp]] forKey:@"Date"];
                newArray[i] = dict;
                
                break;
            }
        }
    }
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:newArray options:NSJSONWritingPrettyPrinted error:&error];
    if([jsonData length] >0 && error == nil){
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        return jsonString;
    }else{
        return nil;
    }
    
}


- (id)initWithCoder:(NSCoder *)decoder
{
    if((self = [super initWithCoder:decoder]))
    {
        sampleData = [decoder decodeObject];
        [decoder decodeObject];
    }
    return self;
}

- (void)dealloc
{
}

@end
