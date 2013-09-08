//
//  ADZAristaFetcher.h
//  ArisDozer
//
//  Created by Jeroen Arnoldus on 08-09-13.
//  Copyright (c) 2013 Jeroen Arnoldus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ADZLLPDDeviceInfo.h"

@interface ADZAristaFetcher : NSObject

- (NSString*)executeAristaCommand:(NSString*)command host:(NSArray*)host password:(NSString*)pw;
- (NSMutableArray*)fetchLLPDNeighbors:(NSArray*)host password:(NSString*)pw;
- (ADZLLPDDeviceInfo*)fetchDeviceInfo:(NSString*)port host:(NSArray*)host password:(NSString*)pw;
- (NSMutableDictionary*)fetchNetwork:(NSArray*)host password:(NSString*)pw;



@end
