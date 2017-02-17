//
//  PersonalInterestButton.m
//  Millie
//
//  Created by Emmanuel Masangcay on 6/5/15.
//  Copyright (c) 2015 CoderEXP. All rights reserved.
//

#import "PersonalInterestButton.h"
#import <UIKit/UIKit.h>

@implementation PersonalInterestButton

-(instancetype)init
{
    self = [UIButton buttonWithType:UIButtonTypeRoundedRect];

    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    // Setup LoginButton Appearance
    CALayer *layer = self.layer;
    layer.backgroundColor = [[UIColor clearColor] CGColor];
    layer.borderColor = [[UIColor blackColor]CGColor];
    layer.borderWidth = 1.5f;


    [self addTarget:nil
                    action:@selector(clicked)
          forControlEvents:UIControlEventTouchUpInside];

    return self;
}


-(void)clicked
{
    NSLog(@"Clicked");
}
@end
