//
//  M_CustomTabBar.h
//  Millie
//
//  Created by Emmanuel Masangcay on 6/16/15.
//  Copyright (c) 2015 CoderEXP. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol M_CustomTabBarDelegate <NSObject>

-(void)onClickCreateNewDeal;
-(void)onClickMerchantData;
-(void)onClickDeals;
-(void)onClickMerchant;

@end

@interface M_CustomTabBar : UIView

{
    UIButton *btnCreateNewDeal;
    UIButton *btnMerchantData;
    UIButton *btnDeals;
    UIButton *btnMerchant;
}


@property id <M_CustomTabBarDelegate> delegate;

-(void)clickCreateNewDeal;
-(void)clickMerchantData;
-(void)clickDeals;
-(void)clickMerchant;


@end
