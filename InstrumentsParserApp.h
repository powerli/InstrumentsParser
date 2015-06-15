//
//  InstrumentsParserApp.h
//  InstrumentsParser
//
//  Created by pantengfei on 14-7-30.
//  Copyright (c) 2014年 ___bidu___. All rights reserved.
//

//singleton ,store app global info

#import <Foundation/Foundation.h>

@interface InstrumentsParserApp : NSObject{
    
}

@property (nonatomic,retain) NSString* appname;

+ (InstrumentsParserApp *) getInstance;

@end
