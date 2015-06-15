//
//  main.m
//  InstrumentsParser
//
//  Created by pantengfei on 14-7-29.
//  Copyright (c) 2014年 ___bidu___. All rights reserved.
//

#import "Utils.h"

@implementation NSString (TrimmingAdditions)

- (NSString *)stringByTrimmingLeadingCharactersInSet:(NSCharacterSet *)characterSet {
    NSUInteger location = 0;
    NSUInteger length = [self length];
    unichar charBuffer[length];
    [self getCharacters:charBuffer];
    
    for (location; location < length; location++) {
        if (![characterSet characterIsMember:charBuffer[location]]) {
            break;
        }
    }
    
    return [self substringWithRange:NSMakeRange(location, length - location)];
}

- (NSString *)stringByTrimmingTrailingCharactersInSet:(NSCharacterSet *)characterSet {
    NSUInteger location = 0;
    NSUInteger length = [self length];
    unichar charBuffer[length];
    [self getCharacters:charBuffer];
    
    for (length; length > 0; length--) {
        if (![characterSet characterIsMember:charBuffer[length - 1]]) {
            break;
        }
    }
    
    return [self substringWithRange:NSMakeRange(location, length - location)];
}

@end

@implementation Utils

+ (NSString *)unzipFile:(NSString *)filePath {
    // Unzip file
    NSTask *task;
    task = [[NSTask alloc] init];
    [task setLaunchPath: @"/usr/bin/unzip"];
    
    NSArray *arguments;
    arguments = @[@"-o", filePath];
    [task setArguments: arguments];
    
    NSPipe *pipe;
    pipe = [NSPipe pipe];
    [task setStandardOutput: pipe];
    
    NSFileHandle *file;
    file = [pipe fileHandleForReading];
    
    [task launch];
    
    NSData *data;
    data = [file readDataToEndOfFile];
    
    NSString *string;
    string = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
    
    NSRange startRange = [string rangeOfString:@"inflating: "];
    if (startRange.location == NSNotFound) {
        return ZIP_FAILED;
    }
    NSString *unzipedFile = [[string substringFromIndex:(startRange.location + startRange.length)] stringByTrimmingTrailingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    //printf ("\nunzip trace file:\n%s\n", [string UTF8String]);
    return unzipedFile;
}

+ (BOOL) grepFile:(NSString *)filePath searchKeyword:(NSString *)keyword{
    NSTask *task = [[NSTask alloc] init];
    [task setLaunchPath:@"/usr/bin/grep"];
    
    NSArray *arguments = [NSArray arrayWithObjects: keyword, filePath,nil];
    [task setArguments:arguments];
    
    NSPipe *pipe = [NSPipe pipe];
    [task setStandardOutput:pipe];
    
    NSFileHandle *file = [pipe fileHandleForReading];
    
    [task launch];
    
    NSData *data = [file readDataToEndOfFile];
    
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSRange startRange = [string rangeOfString:@"matches"];
    if(startRange.location == NSNotFound){
        return NO;
    }else{
        return YES;
    }
}

@end
