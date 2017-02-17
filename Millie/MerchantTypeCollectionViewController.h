//
//  MerchantTypeCollectionViewController.h
//  Millie
//
//  Created by Emmanuel Masangcay on 6/8/15.
//  Copyright (c) 2015 CoderEXP. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MerchantTypeCollectionViewDelegate <NSObject>

// define protocol functions that can be used in any class using this delegate
-(void)tapBusinessType:(NSString*)businessType;
-(void)removeBusinessType:(NSString*)businessType;
-(BOOL)checkBusinessType:(NSString*)businessType;

@end

@interface MerchantTypeCollectionViewController : UIViewController

// define delegate property
@property id <MerchantTypeCollectionViewDelegate> delegate;

@property (strong, nonatomic) IBOutlet UITextView *textViewBusinessDescription;


@end
