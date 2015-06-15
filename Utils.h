//
//  main.m
//  InstrumentsParser
//
//  Created by pantengfei on 14-7-29.
//  Copyright (c) 2014年 ___bidu___. All rights reserved.
//

#import <Foundation/Foundation.h>
#define ZIP_FAILED @"Unzip Failed"

@interface Utils : NSObject
+ (NSString *)unzipFile:(NSString *)filePath;
+ (BOOL) grepFile: (NSString *)filePath searchKeyword:(NSString*)keyword;
@end
