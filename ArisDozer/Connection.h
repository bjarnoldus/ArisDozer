//
//  Connection.h
//  ArisDozer
//
//  Created by Jeroen Arnoldus on 07-09-13.
//  Copyright (c) 2013 Jeroen Arnoldus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Device;

@interface Connection : NSManagedObject

@property (nonatomic, retain) NSString * porta;
@property (nonatomic, retain) NSString * portb;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) Device *devicea;
@property (nonatomic, retain) Device *deviceb;

@end
