//
//  PersonalInterestHeader.m
//  Millie
//
//  Created by Emmanuel Masangcay on 6/5/15.
//  Copyright (c) 2015 CoderEXP. All rights reserved.
//

#import "PersonalInterestHeader.h"


@implementation PersonalInterestHeader

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
                
    }

    return self;
}


- (IBAction)backButton:(UIButton *)sender {
    [self.delegate onClickBack];
}



@end
