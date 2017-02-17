//
//  PersonalInterestHeader.h
//  Millie
//
//  Created by Emmanuel Masangcay on 6/5/15.
//  Copyright (c) 2015 CoderEXP. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PersonalHeaderDelegate <NSObject>

// define protocol functions that can be used in any class using this delegate
-(void)onClickBack;


@end

@interface PersonalInterestHeader : UIView

// define delegate property
@property id <PersonalHeaderDelegate> delegate;


@end
