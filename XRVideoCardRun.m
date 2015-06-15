//
//  XRVideoCardRun.m
//  InstrumentsParser
//
//  Created by baidu on 14/12/8.
//  Copyright (c) 2014年 ___bidu___. All rights reserved.
//

#import "XRVideoCardRun.h"

@implementation XRVideoCardRun

- (id)initWithCoder:(NSCoder *)decoder
{
    if((self = [super initWithCoder:decoder]))
    {
        sampleData = [decoder decodeObject];
        
        [decoder decodeObject];//id
        [decoder decodeObject];//id
        [decoder decodeObject];//id
    }
    return self;
}

- (NSString *)description
{
    NSString * baseResult = [super description];
    NSMutableString *result = [NSMutableString stringWithFormat:@"XRRun:%@\n", baseResult];
    [result appendFormat:@"XRVideoCardRunSampleData:%@\n", sampleData];
    return result;
}

- (NSString *) toJsonString
{
    NSMutableArray *newArray = [[NSMutableArray alloc] init];
    for(NSUInteger i=0; i<[sampleData count]; i++){
        NSDictionary *data = sampleData[i];
        double relativeTimestamp = [data[@"XRVideoCardRunTimeStamp"] doubleValue];
        double seconds = relativeTimestamp / 1000.0 / 1000.0;
        NSTimeInterval timestamp = startTime + seconds;
        int fps = [data[@"FramesPerSecond"] intValue];
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:[NSNumber numberWithDouble:timestamp] forKey:@"XRVideoCardRunTimeStamp"];
        [dict setObject:[NSNumber numberWithInt:fps] forKey:@"FramesPerSecond"];
        newArray[i] = dict;
        //NSLog(@"%@", newArray[i]);
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

- (double) getStartTime
{
    return startTime;
}

@end