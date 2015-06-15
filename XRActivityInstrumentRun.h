//
//  XRActivityInstrumentRun.h
//  InstrumentsParser
//
//  Created by pantengfei on 14-7-29.
//  Copyright (c) 2014年 ___bidu___. All rights reserved.
//

#import "XRRun.h"

//for activity monitor
@interface XRActivityInstrumentRun : XRRun
{
    NSMutableArray *sampleData;
}

- (NSString *) toJsonString;

@end

