//
//  ADZLLPDDeviceInfo.m
//  ArisDozer
//
//  Created by Jeroen Arnoldus on 08-09-13.
//  Copyright (c) 2013 Jeroen Arnoldus. All rights reserved.
//

#import "ADZLLPDDeviceInfo.h"

@implementation ADZLLPDDeviceInfo
-(NSString *) toString{
    return [NSString stringWithFormat:@"Device brand: %@ type: %@ ip: %@ mac: %@", self.brand, self.deviceType, self.ip, self.mac];
}
@end
