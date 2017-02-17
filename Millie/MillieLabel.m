//
//  MillieLabel.m
//  Millie
//
//  Created by Emmanuel Masangcay on 7/15/15.
//  Copyright (c) 2015 CoderEXP. All rights reserved.
//

#import "MillieLabel.h"

@implementation MillieLabel

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        NSAttributedString *str = [[NSAttributedString alloc] initWithString:self.text attributes:@{
                                                                                                    NSKernAttributeName : @(1.5f)}];
        [self setAttributedText:str];

    }
    return self;
}

@end
