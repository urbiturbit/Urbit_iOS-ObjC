//
//  InterestsCollectionViewCell.m
//  Millie
//
//  Created by Emmanuel Masangcay on 6/5/15.
//  Copyright (c) 2015 CoderEXP. All rights reserved.
//

#import "InterestsCollectionViewCell.h"
#import "UIColor+HEX.h"

@implementation InterestsCollectionViewCell

-(void)cellTapped
{

    UIColor *colorSelect = [UIColor colorwithHexString:@"334d5c" alpha:1];

         if ([self.backgroundColor isEqual:colorSelect]) {
             self.backgroundColor = [UIColor colorwithHexString:@"D4ECDC" alpha:1];
             self.labelInterest.textColor = [UIColor colorwithHexString:@"334d5c" alpha:1];
         }
         else
         {
             self.backgroundColor = [UIColor colorwithHexString:@"334d5c" alpha:1];
             self.labelInterest.textColor = [UIColor colorwithHexString:@"D4ECDC" alpha:1];

         }



}

@end
