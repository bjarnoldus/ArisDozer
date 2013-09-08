//
//  Image.h
//  ArisDozer
//
//  Created by Jeroen Arnoldus on 08-09-13.
//  Copyright (c) 2013 Jeroen Arnoldus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Image : NSManagedObject

@property (nonatomic, retain) NSString * filename;
@property (nonatomic, retain) NSNumber * sizex;
@property (nonatomic, retain) NSNumber * sizey;
@property (nonatomic, retain) NSString * name;

@end
