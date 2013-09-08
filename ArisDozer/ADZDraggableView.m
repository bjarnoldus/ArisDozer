//
//  ADZDraggableView.m
//  ArisDozer
//
//  Created by Jeroen Arnoldus on 07-09-13.
//  Copyright (c) 2013 Jeroen Arnoldus. All rights reserved.
//

#import "ADZDraggableView.h"

@implementation ADZDraggableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = NO;
    }
    return self;
}

- (id) initWithImage: (UIImage *) anImage
{
    if (self = [super initWithImage:anImage])
        self.userInteractionEnabled = NO;
    return self;
}

- (void) touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{

}


@end
