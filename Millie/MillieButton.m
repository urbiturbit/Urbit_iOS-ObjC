//
//  MillieButton.m
//  Millie
//
//  Created by Emmanuel Masangcay on 7/15/15.
//  Copyright (c) 2015 CoderEXP. All rights reserved.
//

#import "MillieButton.h"
#import "UIColor+HEX.h"

@implementation MillieButton

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        NSAttributedString *str = [[NSAttributedString alloc] initWithString:self.titleLabel.text attributes:@{
                                                                        NSKernAttributeName : @(1.5f)}];
        [self.titleLabel setAttributedText:str];

    }
    return self;
}




@end
