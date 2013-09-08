//
//  ADZMainViewController.h
//  ArisDozer
//
//  Created by Jeroen Arnoldus on 07-09-13.
//  Copyright (c) 2013 Jeroen Arnoldus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADZMainViewController : UIViewController

@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;
@property (nonatomic, strong) NSArray *imageLocations;


@end
