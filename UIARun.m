//
//  UIARun.m
//  InstrumentsParser
//
//  Created by pantengfei on 14-7-29.
//  Copyright (c) 2014年 ___bidu___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIARun.h"


@implementation UIARun


- (NSString *)formattedSample:(NSUInteger)index
{
    NSDictionary *data = sampleData[index];
    
    NSString *LogType = data[@"LogType"];
    long Type = [data[@"Type"] longValue];
    NSString *Message = data[@"Message"];
    NSString *Timestamp = data[@"Timestamp"];
    
    NSString *result = [NSString stringWithFormat:@"LogType: %@ Type %lu Message: %@ Timestamp: %@",LogType,Type,Message,Timestamp];
    
    return result;
}

- (NSString *)description
{
    NSString *start = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:startTime]];
    NSString *end = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:endTime]];
    NSMutableString *result = [NSMutableString stringWithFormat:@"Run %u, starting at %@, running until %@\n", (unsigned int)runNumber, start, end];
    for(NSUInteger i=0; i<[sampleData count]; i++)
    {
        [result appendFormat:@"Sample %u: %@\n", (unsigned int)i, [self formattedSample:i]];
    }
    return result;
}

- (void) filterData:(NSMutableDictionary *)dict
{
    NSMutableDictionary *newdict = dict;
    
    if ([newdict objectForKey:@"Timestamp"]) {
        NSDate *date = newdict[@"Timestamp"];
        newdict[@"Timestamp"] = [NSNumber numberWithDouble: [date timeIntervalSince1970]];
        newdict[@"Date"] = [dateFormatter stringFromDate:date];
    }
    
    if ([newdict objectForKey:@"ExceptionData"]) {
        [newdict removeObjectForKey:@"ExceptionData"];
    }
        
    if ([newdict objectForKey:@"children"]) {
        NSMutableArray *childarray = [newdict objectForKey:@"children"];
        for (NSInteger i=0; i < [childarray count]; i++) {
            [self filterData:childarray[i]];
        }
    }
}

- (NSString *) toJsonString
{
    NSMutableArray *newArray = [[NSMutableArray alloc] init];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    for(NSUInteger i=0; i<[sampleData count]; i++){
    //for(NSUInteger i=0; i<1; i++){
        dict = sampleData[i];
        [self filterData:dict];
        newArray[i] = dict;
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
        [decoder decodeObject]; //patch for XCode 7
        sampleData = [decoder decodeObject];
        [decoder decodeObject];
        [decoder decodeObject];
        [decoder decodeObject];
    }
    return self;
}

- (void)dealloc
{
}

/*
 dict element like this
 [0]	__NSDictionaryM *	4 key/value pairs	0x0000000100300b50
 {
    [0]     (null)	@"LogType" : @"Debug"
    [1]     (null)	@"Type" : (long)0
    [2]     (null)	@"Message" : @"target.tapWithOptions({x:\"92\", y:\"266\"}, {touchCount:\"1\", duration:\"0\", tapCount:\"1\"})"
    [3]     (null)	@"Timestamp" : 2014-07-29 15:50:14 CST
 }
 */

@end