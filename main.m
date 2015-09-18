//
//  main.m
//  InstrumentsParser
//
//  Created by pantengfei on 14-7-29.
//  Copyright (c) 2014年 ___bidu___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Utils.h"
#import "XRRun.h"
#import "XRActivityInstrumentRun.h"
#import "UIARun.h"
#import "InstrumentsParserApp.h"
#import "XRStreamedPowerRun.h"
#import "XRObjectAllocRun.h"
#import "XRVideoCardRun.h"

void parseNetworkActivity(NSString *fileBasename, NSString *inputTraceFile, double testStartTime, NSString *outputdir) {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;

    //printf("\n%lf\n", [run getStartTime]);
    NSString *networkResultJsonString = nil;
    NSString *networkResultFile = [NSString stringWithFormat:@"%@/Trace%@.run/network_activity.dat.archive",inputTraceFile,fileBasename];
    if(![fileManager fileExistsAtPath:networkResultFile]) {
        //NSLog(@"no network result exists!!!");
    } else {
        //NSLog(@"network result file exists!!!");
        NSDictionary *dict = [fileManager attributesOfItemAtPath:networkResultFile error:&error];
        //NSLog(@"size=%lld",[dict fileSize]);
        NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:networkResultFile];
        int size = 208;
        int lineCount = (int)[dict fileSize]/size;
        NSMutableArray *outArray = [[NSMutableArray alloc] init];
        NSArray *nameArray= [NSArray arrayWithObjects:@"startTime",@"duration",@"wifiPacketsIn",@"wifiPacketsOut",@"wifiBytesIn",@"wifiBytesOut",nil];
        for(int i =1 ;i<lineCount;i++) {
            //printf("line:%d\n",i);
            int dataCount = 26;
            NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] init];
            for(int j=0;j<dataCount;j++) {
                [fileHandle seekToFileOffset:i*size+j*8];
                NSData *data = [fileHandle readDataOfLength:8];
                //NSLog(@"%@",data);
                Byte *byteData = (Byte *)[data bytes];
                
                Byte temp = byteData[0];
                byteData[0] = byteData[7];
                byteData[7] = temp;
                temp = byteData[1];
                byteData[1] = byteData[6];
                byteData[6] = temp;
                temp = byteData[2];
                byteData[2] = byteData[5];
                byteData[5] = temp;
                temp = byteData[3];
                byteData[3] = byteData[4];
                byteData[4] = temp;
                
                double* array_of_doubles = (double*)byteData;
                if(j<[nameArray count]) {
                    NSString *str = [NSString stringWithFormat:@"%lf",array_of_doubles[0]];
                    double number = [str doubleValue];
                    [tempDict setObject:[NSNumber numberWithDouble:number] forKey:nameArray[j]];
                }
            }
            NSString *duration = [tempDict objectForKey:@"duration"];
            NSString *startTime = [tempDict objectForKey:@"startTime"];
            double endtime = [duration doubleValue] + [startTime doubleValue] + testStartTime;
            //NSLog(@"%lf",endtime);
            //NSString *endStr = [NSString stringWithFormat:@"%.0lf",endtime];
            [tempDict setObject:[NSNumber numberWithDouble:endtime] forKey:@"Timestamp"];
            [outArray addObject:tempDict];
            //NSLog(@"%@",tempDict);
        }
        //NSLog(@"%@",outArray);
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:outArray options:NSJSONWritingPrettyPrinted error:&error];
        if([jsonData length] >0 && error == nil){
            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            networkResultJsonString = jsonString;
            //NSString *jsonfile = [NSString stringWithFormat:@"%@/networkresult",outputdir];
            //[jsonString writeToFile:jsonfile atomically:YES encoding:NSUTF8StringEncoding error:&error];
            //NSLog(@"%@",jsonString);
        }
    }
    if(networkResultJsonString!=nil) {
        NSString *jsonfile = [NSString stringWithFormat:@"%@/NetworkActivity-%@",outputdir,fileBasename];
        [networkResultJsonString writeToFile:jsonfile atomically:YES encoding:NSUTF8StringEncoding error:&error];
    }
}

void parseEnergyLevel(NSString *fileBasename, NSString *inputTraceFile, double testStartTime, NSString *outputdir) {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    
    //printf("\n%lf\n", [run getStartTime]);
    NSString *levelResultJsonString = nil;
    NSString *levelResultFile = [NSString stringWithFormat:@"%@/Trace%@.run/level.dat.archive",inputTraceFile,fileBasename];
    if(![fileManager fileExistsAtPath:levelResultFile]) {
        //NSLog(@"no network result exists!!!");
    } else {
        //NSLog(@"network result file exists!!!");
        NSDictionary *dict = [fileManager attributesOfItemAtPath:levelResultFile error:&error];
        //NSLog(@"size=%lld",[dict fileSize]);
        NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:levelResultFile];
        int size = 24;
        int lineCount = (int)[dict fileSize]/size;
        NSMutableArray *outArray = [[NSMutableArray alloc] init];
        NSArray *nameArray= [NSArray arrayWithObjects:@"startTime", @"level", @"level",nil];
        for(int i = 0; i < lineCount; i++) {
            //printf("line:%d\n",i);
            int dataCount = 3;
            NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] init];
            for(int j = 0; j < dataCount; j++) {
                [fileHandle seekToFileOffset:i*size+j*8];
                NSData *data = [fileHandle readDataOfLength:8];
                //NSLog(@"%@",data);
                Byte *byteData = (Byte *)[data bytes];
                
                Byte temp = byteData[0];
                byteData[0] = byteData[7];
                byteData[7] = temp;
                temp = byteData[1];
                byteData[1] = byteData[6];
                byteData[6] = temp;
                temp = byteData[2];
                byteData[2] = byteData[5];
                byteData[5] = temp;
                temp = byteData[3];
                byteData[3] = byteData[4];
                byteData[4] = temp;
                
                double* array_of_doubles = (double*)byteData;
                if(j < [nameArray count] && ![nameArray[j] isEqualToString:@""] ) {
                    NSString *str = [NSString stringWithFormat:@"%lf",array_of_doubles[0]];
                    double number = [str doubleValue];
                    [tempDict setObject:[NSNumber numberWithDouble:number] forKey:nameArray[j]];
                }
            }
            NSString *duration = [tempDict objectForKey:@"duration"];
            NSString *startTime = [tempDict objectForKey:@"startTime"];
            double endtime = [duration doubleValue] + [startTime doubleValue] + testStartTime;
            //NSLog(@"%lf",endtime);
            //NSString *endStr = [NSString stringWithFormat:@"%.0lf",endtime];
            [tempDict setObject:[NSNumber numberWithDouble:endtime] forKey:@"Timestamp"];
            [outArray addObject:tempDict];
            //NSLog(@"%@",tempDict);
        }
        //NSLog(@"%@",outArray);
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:outArray options:NSJSONWritingPrettyPrinted error:&error];
        if([jsonData length] >0 && error == nil){
            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            levelResultJsonString = jsonString;
            //NSString *jsonfile = [NSString stringWithFormat:@"%@/networkresult",outputdir];
            //[jsonString writeToFile:jsonfile atomically:YES encoding:NSUTF8StringEncoding error:&error];
            //NSLog(@"%@",jsonString);
        }
    }
    if(levelResultJsonString!=nil) {
        NSString *jsonfile = [NSString stringWithFormat:@"%@/EnergyLevel-%@",outputdir,fileBasename];
        [levelResultJsonString writeToFile:jsonfile atomically:YES encoding:NSUTF8StringEncoding error:&error];
    }
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
        NSString *appname = [standardDefaults stringForKey:@"p"];
        NSString *inputdir = [standardDefaults stringForKey:@"i"];
        NSString *outputdir = [standardDefaults stringForKey:@"o"];
        
        //NSLog(@"appname[%@] inputfile[%@] outputfile[%@]",appname,inputfile,outputfile);
        
        //appname = @"IphoneCom";
        //inputdir = @"/Users/scottwu/Downloads/newenergy.trace";
        
        if (appname == nil || inputdir == nil ) {
            printf("InstrumentsParser -p process_name -i result.trace -o /a/b/c \nor InstrumentsParser -p process_name -i result.trace\n");
            exit(1);
        }
        
        InstrumentsParserApp *shareAppData = [InstrumentsParserApp getInstance];
        [shareAppData setAppname:appname];  //share for XRActivityInsturmentRun.m
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *workingDir = [fileManager currentDirectoryPath];
        
        
        
        if (outputdir == nil) {
            outputdir = workingDir;
        }else{
            if (![fileManager fileExistsAtPath:outputdir]) {
                NSLog(@"output dir: %@ is not exits",outputdir);
                exit(-2);
            }else{
                outputdir = [outputdir stringByExpandingTildeInPath];
            }
        }
        
        NSString *inputTraceFile = [inputdir stringByExpandingTildeInPath];
        NSString *resultTemplateIdDirs = [NSString stringWithFormat:@"%@/instrument_data",inputTraceFile];
        
        if (![fileManager fileExistsAtPath:inputTraceFile]
            || ![fileManager fileExistsAtPath:resultTemplateIdDirs]) {
            NSLog(@"input data: %@ or %@ is not exits",inputTraceFile,resultTemplateIdDirs);
            exit(-1);
        }
        
        NSError *error = nil;
        
        
        NSArray *templateDirs = [fileManager contentsOfDirectoryAtPath:resultTemplateIdDirs error:&error];
        if (nil == templateDirs) {
            NSLog(@"ls %@ error or null!\n",resultTemplateIdDirs);
        }
        
        NSString *topUnZipDir = nil;
        
        //  result.trace/instrument_data/0AD40D0C-10B3-4E36-B6BA-8ED8DF101118/run_data/1.run.zip
        for (NSString *templateName in templateDirs) {
            NSString *templateDir = [NSString stringWithFormat:@"%@/%@",resultTemplateIdDirs,templateName];
            NSString *runZipDir = [NSString stringWithFormat:@"%@/run_data",templateDir];
            
            NSArray *dirContents = [fileManager contentsOfDirectoryAtPath:runZipDir error:&error];
            if(nil == dirContents){
                NSLog(@"ls %@ to find result zip file error or nil",runZipDir);
            }else{
                for(NSString *zipFile in dirContents){
                    NSString *unzipedFile = [Utils unzipFile:[NSString stringWithFormat:@"%@/%@",runZipDir,zipFile]];
                    topUnZipDir = [[unzipedFile componentsSeparatedByString:@"/"] objectAtIndex:0];
                    
                    if (![unzipedFile isEqualToString:ZIP_FAILED]) {
                        NSString *resultUnzippedFile = [NSString stringWithFormat:@"%@/%@",workingDir, unzipedFile];
                        
                        // Read the trace file into memory
                        NSURL *traceFile = [NSURL fileURLWithPath:[resultUnzippedFile stringByExpandingTildeInPath]];
                        // NSLog(@"%@",traceFile);
                        
                        NSData *traceData = [NSData dataWithContentsOfURL:traceFile];
                        
                        NSString *jsonString;
                        NSString *fileBasename = [[zipFile componentsSeparatedByString:@"."] objectAtIndex:0];
                        
                        //detect which instrument type
                        if ([Utils grepFile:resultUnzippedFile searchKeyword:@"UIARun"]) {
                            //NSLog(@"%@",traceFile);
                            UIARun *run = [NSUnarchiver unarchiveObjectWithData:traceData];
                            //printf("\n%s\n", [[run description] UTF8String]);
                            jsonString = [run toJsonString];
                            NSString *jsonfile = [NSString stringWithFormat:@"%@/UIAutomation-%@",outputdir,fileBasename];
                            [jsonString writeToFile:jsonfile atomically:YES encoding:NSUTF8StringEncoding error:&error];
                        }else if([Utils grepFile:resultUnzippedFile searchKeyword:@"XRObjectAllocRun"]){
                            //printf("\n%s\n","XRObjectAllocRun");
                            //XRObjectAllocRun *run = [NSUnarchiver unarchiveObjectWithData:traceData];
                            //printf("\n%s\n", [[run description] UTF8String]);
                        }else if([Utils grepFile:resultUnzippedFile searchKeyword:@"XRActivityInstrumentRun"]){
                            XRActivityInstrumentRun *run = [NSUnarchiver unarchiveObjectWithData:traceData];
                            //printf("\n%s\n", [[run description] UTF8String]);
                            jsonString = [run toJsonString];
                            NSString *jsonfile = [NSString stringWithFormat:@"%@/ActivityMonitor-%@",outputdir,fileBasename];
                            [jsonString writeToFile:jsonfile atomically:YES encoding:NSUTF8StringEncoding error:&error];
                        }else if ([Utils grepFile:resultUnzippedFile searchKeyword:@"XRVideoCardRun"]){
                            XRVideoCardRun *run = [NSUnarchiver unarchiveObjectWithData:traceData];
                            //NSLog(@"%@",run);
                            //printf("\n%s\n", [[run description] UTF8String]);
                            jsonString = [run toJsonString];
                            NSString *jsonfile = [NSString stringWithFormat:@"%@/CoreAnimation-%@",outputdir,fileBasename];
                            [jsonString writeToFile:jsonfile atomically:YES encoding:NSUTF8StringEncoding error:&error];
                            //NSLog(@"%@",jsonString);
                            //printf("\n%s\n",jsonString);
                        }else if([Utils grepFile:resultUnzippedFile searchKeyword:@"XRStreamedPowerRun"]){
                            XRStreamedPowerRun *run = [NSUnarchiver unarchiveObjectWithData:traceData];
                            double testStartTime = [run getStartTime];
                            parseNetworkActivity(fileBasename, inputTraceFile, testStartTime, outputdir);
                            parseEnergyLevel(fileBasename, inputTraceFile, testStartTime, outputdir);
                        }
                    }
                }
            }
        }
        
        if( nil != topUnZipDir){
            NSURL *tmpDir = [NSURL fileURLWithPath:[[NSString stringWithFormat:@"%@/%@",workingDir,topUnZipDir] stringByExpandingTildeInPath]];
            [fileManager removeItemAtURL:tmpDir error:&error];
        }
        
    }
    return 0;
}
