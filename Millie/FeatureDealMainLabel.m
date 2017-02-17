//
//  FeatureDealMainLabel.m
//  Millie
//
//  Created by Emmanuel Masangcay on 6/19/15.
//  Copyright (c) 2015 CoderEXP. All rights reserved.
//

#import "FeatureDealMainLabel.h"

@implementation FeatureDealMainLabel

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {

        CGRect screenRect = [[UIScreen mainScreen] bounds];
        CGFloat screenWidth = screenRect.size.width;

        if (screenWidth == 375) //iphone6
        {
            [self setFont:[UIFont fontWithName:@"ProximaNova-Semibold" size:25]];
        }
        if (screenWidth == 320) //iphone5
        {
            [self setFont:[UIFont fontWithName:@"ProximaNova-Semibold" size:25]];
        }
        if (screenWidth == 414) //iphone6+
        {
            [self setFont:[UIFont fontWithName:@"ProximaNova-Semibold" size:29]];
        }

        NSAttributedString *str = [[NSAttributedString alloc] initWithString:self.text attributes:@{
                                                                                                    NSKernAttributeName : @(1.5f)}];
        [self setAttributedText:str];

    }
    return self;
}

@end
