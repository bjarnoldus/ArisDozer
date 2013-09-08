//
//  ADZMainViewController.m
//  ArisDozer
//
//  Created by Jeroen Arnoldus on 07-09-13.
//  Copyright (c) 2013 Jeroen Arnoldus. All rights reserved.
//

#import "ADZMainViewController.h"
#import "ADZDraggableView.h"
#import "Image.h"
#import "ImageLocation.h"
#import "ADZAristaFetcher.h"
#import "ADZLLPDNeighbor.h"
#import "ADZLLPDDeviceInfo.h"

@interface ADZMainViewController ()

@end

@implementation ADZMainViewController
@synthesize managedObjectContext;
@synthesize imageLocations;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{


    NSError *error;
    NSString* pw = [[alertView textFieldAtIndex:0] text];
    NSArray *switches =[[NSArray alloc] initWithObjects:@"admin@146.50.11.1",@"lab123",nil];
    ADZAristaFetcher *aristaFetcher = [ADZAristaFetcher alloc];
   NSMutableDictionary *devices = [aristaFetcher fetchNetwork:switches password:pw];
    NSArray *locationsx=
    [NSArray arrayWithObjects:
     [NSNumber numberWithInteger:40],[NSNumber numberWithInteger:250],[NSNumber numberWithInteger:540],
     [NSNumber numberWithInteger:40],[NSNumber numberWithInteger:250],[NSNumber numberWithInteger:540],
     [NSNumber numberWithInteger:40],[NSNumber numberWithInteger:250],[NSNumber numberWithInteger:540],
     [NSNumber numberWithInteger:40],[NSNumber numberWithInteger:250],[NSNumber numberWithInteger:540],nil];

    NSArray *locationsy=
    [NSArray arrayWithObjects:
     [NSNumber numberWithInteger:100],[NSNumber numberWithInteger:100],[NSNumber numberWithInteger:100],
     [NSNumber numberWithInteger:400],[NSNumber numberWithInteger:400],[NSNumber numberWithInteger:400],
     [NSNumber numberWithInteger:800],[NSNumber numberWithInteger:800],[NSNumber numberWithInteger:800],
     [NSNumber numberWithInteger:1000],[NSNumber numberWithInteger:1000],[NSNumber numberWithInteger:1000],nil];
    NSInteger index = 0;
    NSArray *keys=[devices allKeys];
    for( NSString* key in keys){
        ADZLLPDDeviceInfo *deviceInfo = [devices objectForKey:key];
        NSLog(@"DeviceInfo: %@:", [deviceInfo toString]); 
    
        
        NSString* pred = @"server";
        if([deviceInfo.brand isEqualToString:@"Arista"]){
            pred = @"7050";
            if(![deviceInfo.deviceType isEqualToString:@"Bridge"]){
                pred = @"appletv";
            }
        }
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription
                                       entityForName:@"Image" inManagedObjectContext:managedObjectContext];
        [fetchRequest setEntity:entity];
        NSArray* images = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
        Image *image;
        
        for (Image *_image in images) {

            if([_image.name isEqualToString:pred]){
                image = _image;
            }
         }


        self.imageLocations = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
        ImageLocation *imageLocation;
        imageLocation = [NSEntityDescription
                         insertNewObjectForEntityForName:@"ImageLocation"
                         inManagedObjectContext:managedObjectContext];
        [imageLocation setValue:[locationsx objectAtIndex:index] forKey:@"locationx"];
        [imageLocation setValue:[locationsy objectAtIndex:index] forKey:@"locationy"];
        [imageLocation setValue:image forKey:@"image"];
        [imageLocation setValue:deviceInfo.ip forKey:@"name"];
        if (![managedObjectContext save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
        index++;
    }
    


    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"ImageLocation" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    self.imageLocations = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    for (ImageLocation *imageLocation in self.imageLocations) {
        Image *image = [imageLocation valueForKey:@"image"];
        UIImage *img = [UIImage imageNamed:image.filename];
        ADZDraggableView *imageView = [ [ ADZDraggableView alloc ] initWithFrame:CGRectMake([imageLocation.locationx floatValue], [imageLocation.locationy floatValue], [image.sizex floatValue], [image.sizey floatValue])];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.image = img;
        [self.view addSubview:imageView];
        UILabel *label =  [[UILabel alloc] initWithFrame: CGRectMake([imageLocation.locationx floatValue], [imageLocation.locationy floatValue]+150.0,200.0,20.0)];
        label.text = imageLocation.name;
        [self.view addSubview:label];

    }

    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    id delegate = [[UIApplication sharedApplication] delegate];
    self.managedObjectContext = [delegate managedObjectContext];
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"WIPKIP" message:@"Ik wil jouw wachtwoord" delegate:self cancelButtonTitle:@"Login" otherButtonTitles:nil];
    alert.alertViewStyle = UIAlertViewStyleSecureTextInput;
    [alert show];




    
    
   }

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
