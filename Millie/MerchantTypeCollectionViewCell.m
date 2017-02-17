//
//  MerchantTypeCollectionViewCell.m
//  Millie
//
//  Created by Emmanuel Masangcay on 6/8/15.
//  Copyright (c) 2015 CoderEXP. All rights reserved.
//

#import "MerchantTypeCollectionViewCell.h"
#import "UIColor+HEX.h"

@implementation MerchantTypeCollectionViewCell

-(void)cellTapped
{
    UIColor *colorSelect = [UIColor colorwithHexString:@"D4ECDC" alpha:1];

    if ([self.backgroundColor isEqual:colorSelect]) {
        self.backgroundColor = [UIColor colorwithHexString:@"334d5c" alpha:1];
        self.labelInterest.textColor = [UIColor colorwithHexString:@"D4ECDC" alpha:1];
    }
    else
    {
        self.backgroundColor = [UIColor colorwithHexString:@"D4ECDC" alpha:1];
        self.labelInterest.textColor = [UIColor colorwithHexString:@"334d5c" alpha:1];

    }

}


@end
