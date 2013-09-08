//
//  ADZAppDelegate.h
//  ArisDozer
//
//  Created by Jeroen Arnoldus on 07-09-13.
//  Copyright (c) 2013 Jeroen Arnoldus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADZMainViewController.h"


@interface ADZAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ADZMainViewController *mainViewController;


@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
