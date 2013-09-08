//
//  ADZLLPDDeviceInfo.h
//  ArisDozer
//
//  Created by Jeroen Arnoldus on 08-09-13.
//  Copyright (c) 2013 Jeroen Arnoldus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ADZLLPDDeviceInfo : NSObject
-(NSString *) toString;


@property (nonatomic, retain) NSString * mac;
@property (nonatomic, retain) NSString * brand;
@property (nonatomic, retain) NSString * deviceType;
@property (nonatomic, retain) NSString * ip;
@property (nonatomic, retain) NSArray * loginPath;

@end
