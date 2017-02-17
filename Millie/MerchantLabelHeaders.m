//
//  MerchantLabelHeaders.m
//  Millie
//
//  Created by Emmanuel Masangcay on 6/15/15.
//  Copyright (c) 2015 CoderEXP. All rights reserved.
//

#import "MerchantLabelHeaders.h"

@implementation MerchantLabelHeaders



-(id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
         [self setFont:[UIFont fontWithName:@"ProximaNova-Semibold" size:18.0f]];

        NSAttributedString *str = [[NSAttributedString alloc] initWithString:self.text attributes:@{
                                                                                                    NSKernAttributeName : @(1.5f)}];
        [self setAttributedText:str];
    }
    return self;
}
@end
