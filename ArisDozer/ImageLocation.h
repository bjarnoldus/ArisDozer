//
//  ImageLocation.h
//  ArisDozer
//
//  Created by Jeroen Arnoldus on 07-09-13.
//  Copyright (c) 2013 Jeroen Arnoldus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Device, Image;

@interface ImageLocation : NSManagedObject

@property (nonatomic, retain) NSNumber * locationx;
@property (nonatomic, retain) NSNumber * locationy;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) Image *image;
@property (nonatomic, retain) Device *device;

@end
