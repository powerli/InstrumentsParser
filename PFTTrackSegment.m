//
//  main.m
//  InstrumentsParser
//
//  Created by pantengfei on 14-7-29.
//  Copyright (c) 2014年 ___bidu___. All rights reserved.
//

#import "PFTTrackSegment.h"

@implementation PFTTrackSegment

- (id)initWithCoder:(NSCoder *)decoder
{
	if((self = [super init]))
	{
		[decoder decodeObject];
		[decoder decodeObject];
        [decoder decodeObject];
		
		// In seconds
		durationTime = [[decoder decodeObject] doubleValue];
		
		[decoder decodeObject];
	}
	
	return self;
}

@end

@implementation XRTrackSegment

- (id)initWithCoder:(NSCoder *)decoder
{
	if((self = [super initWithCoder:decoder]))
	{
	}
	
	return self;
}

@end

