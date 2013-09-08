//
//  ADZCanvas.m
//  ArisDozer
//
//  Created by Jeroen Arnoldus on 07-09-13.
//  Copyright (c) 2013 Jeroen Arnoldus. All rights reserved.
//

#import "ADZCanvas.h"
#import "Image.h"
#import "ImageLocation.h"

@implementation ADZCanvas

@synthesize lastTouch;
@synthesize location;
@synthesize collisionPoints;
@synthesize managedObjectContext;
@synthesize imageLocations;

- (void) loadCollionPoints {
    collisionPoints = [[NSMutableDictionary alloc] init];
    id delegate = [[UIApplication sharedApplication] delegate];
    self.managedObjectContext = [delegate managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"ImageLocation" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError *error;
    self.imageLocations = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    for (ImageLocation *imageLocation in self.imageLocations) {
        Image *image = [imageLocation valueForKey:@"image"];
        NSValue *rect = [NSValue valueWithCGRect:CGRectMake([imageLocation.locationx floatValue], [imageLocation.locationy floatValue], [image.sizex floatValue], [image.sizey floatValue])];
        [collisionPoints setObject:rect forKey: imageLocation.name];
    }
}


- (void) checkCollission:(CGPoint) point {
    if(self.collisionPoints == nil){
        [self loadCollionPoints];
    }
    NSArray *keys=[collisionPoints allKeys];
    for( NSString* key in keys){
        CGRect rect = [[collisionPoints objectForKey:key] CGRectValue];
        if ( CGRectContainsPoint(rect , point) ) {
            if(![key isEqualToString:lastTouch]) {
                NSLog(@"%@",key);
            }
            lastTouch=key;
        }
    }

    
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    self.location = [touch locationInView:self];
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint currentLocation = [touch locationInView:self];
    
    
    [self checkCollission:currentLocation];
    
    UIGraphicsBeginImageContext(self.frame.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [self.image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    CGContextSetLineCap(ctx, kCGLineCapRound);
    CGContextSetLineWidth(ctx, 5.0);
    CGContextSetRGBStrokeColor(ctx, 1.0, 0.5, 0.5, 1.0);
    CGContextBeginPath(ctx);
    CGContextMoveToPoint(ctx, location.x, location.y);
    CGContextAddLineToPoint(ctx, currentLocation.x, currentLocation.y);
    CGContextStrokePath(ctx);
    self.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    location = currentLocation;
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    self.image = nil;

}



@end
