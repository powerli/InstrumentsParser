//
//  XRVideoCardRun.h
//  InstrumentsParser
//
//  Created by baidu on 14/12/8.
//  Copyright (c) 2014年 ___bidu___. All rights reserved.
//

#import "XRRun.h"

@interface XRVideoCardRun : XRRun
{
    NSMutableArray *sampleData;
}

- (NSString *) toJsonString;

- (double) getStartTime;

@end

