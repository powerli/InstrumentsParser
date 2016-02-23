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
		NSNumber *number = [decoder decodeObject];
		// Fix for Xcode 7.3
		if (strcmp([number objCType], @encode(double)) == 0) {
			durationTime = [number doubleValue];
		} else {
			[decoder decodeObject];
			durationTime = [[decoder decodeObject] doubleValue];
		}
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

