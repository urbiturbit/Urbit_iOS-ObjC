//
//  MerchantSetupPhotos.h
//  Millie
//
//  Created by Emmanuel Masangcay on 6/9/15.
//  Copyright (c) 2015 CoderEXP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MerchantSetupViewController.h"

@protocol MerchantSetupPhotosDelegate <NSObject>

// define protocol functions that can be used in any class using this delegate
-(void)tapOnCamera:(NSString*)photoReference;
-(void)tapOnLibrary:(NSString*)photoReference;

@end

@interface MerchantSetupPhotos : UIView <UIActionSheetDelegate>

// define delegate property
@property id <MerchantSetupPhotosDelegate> delegate;

@property (strong, nonatomic) IBOutlet UILabel *labelBusinessName;

@property (strong, nonatomic) IBOutlet UIImageView *imageViewFirstMerchantPhoto;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewSecondMerchantPhoto;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewThirdMerchantPhoto;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewFourthMerchantPhoto;

@property NSString *photoReference;
@property MerchantSetupViewController *mSVC;
@property NSString *activePhoto;


-(void)setBusinessName:(NSString*)businessName;
-(void)setBusinessPhoto:(UIImage*)photo photoReference:(NSString*)reference;

@end
