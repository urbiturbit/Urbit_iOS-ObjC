//
//  MerchantSetupBusinessHeader.h
//  Millie
//
//  Created by Emmanuel Masangcay on 6/8/15.
//  Copyright (c) 2015 CoderEXP. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BusinessSetupDelegate <NSObject>

// define protocol functions that can be used in any class using this delegate
-(void)onClickBack;


@end

@interface MerchantSetupBusinessHeader : UIView

// define delegate property
@property id <BusinessSetupDelegate> delegate;


@end
