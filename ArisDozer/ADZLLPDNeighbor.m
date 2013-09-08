//
//  ADZLLPDNeighbor.m
//  ArisDozer
//
//  Created by Jeroen Arnoldus on 08-09-13.
//  Copyright (c) 2013 Jeroen Arnoldus. All rights reserved.
//

#import "ADZLLPDNeighbor.h"

@implementation ADZLLPDNeighbor

-(NSString *) toString{
    return [NSString stringWithFormat:@"Neighbor deviceid: %@ portid: %@ port: %@", self.deviceid, self.portid, self.port];
}

@end
