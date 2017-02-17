//
//  InterestsCollectionViewController.h
//  Millie
//
//  Created by Emmanuel Masangcay on 6/5/15.
//  Copyright (c) 2015 CoderEXP. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol InterestCollectionViewDelegate <NSObject>

// define protocol functions that can be used in any class using this delegate
-(void)tapInterest:(NSString*)interest;
-(void)removeInterest:(NSString*)interest;
-(BOOL)checkInterest:(NSString*)interest;

@end

@interface InterestsCollectionViewController : UIViewController

// define delegate property
@property id <InterestCollectionViewDelegate> delegate;

@end
