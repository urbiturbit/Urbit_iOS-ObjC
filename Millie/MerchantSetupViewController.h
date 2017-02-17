//
//  MerchantSetupViewController.h
//  Millie
//
//  Created by Emmanuel Masangcay on 6/7/15.
//  Copyright (c) 2015 CoderEXP. All rights reserved.
//

#import <UIKit/UIKit.h>


extern NSString *businessName;

@protocol MerchantSetupViewDelegate <NSObject>

-(void)insertMerchantPhoto:(UIImage*)imageMerchantPhoto photoReference:(NSString*)photoReference;

@end

@interface MerchantSetupViewController : UIViewController

@property id <MerchantSetupViewDelegate> delegate;

@property NSString *setUpFrom;

@end
