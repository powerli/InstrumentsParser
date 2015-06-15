//
//  InstrumentsParserApp.m
//  InstrumentsParser
//
//  Created by pantengfei on 14-7-30.
//  Copyright (c) 2014年 ___bidu___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InstrumentsParserApp.h"

static InstrumentsParserApp *sharedInstance = nil;

@implementation InstrumentsParserApp

@synthesize appname;

+(InstrumentsParserApp *)getInstance
{
    @synchronized(self) {
        if (sharedInstance == nil)
            sharedInstance = [[self alloc] init];
    }
    return sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self) {
        if (sharedInstance == nil) {
            sharedInstance = [super allocWithZone:zone];
            return sharedInstance;
        }
    }
    return nil;
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}


@end