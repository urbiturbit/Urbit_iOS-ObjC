//
//  B_CustomTabBar.h
//  Millie
//
//  Created by Emmanuel Masangcay on 6/16/15.
//  Copyright (c) 2015 CoderEXP. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol B_CustomTabBarDelegate <NSObject>

-(void)onClickCreateNewDeal;
-(void)onClickSearch;
-(void)onClickNews;
-(void)onClickActivity;
-(void)onClickProfile;

@end

@interface B_CustomTabBar : UIView

{
    UIButton *btnCreateNewDeal;
    UIButton *btnSearch;
    UIButton *btnNews;
    UIButton *btnActivity;
    UIButton *btnProfile;
}

@property id <B_CustomTabBarDelegate> delegate;

-(void)clickCreateNewDeal;
-(void)clickSearch;
-(void)clickNews;
-(void)clickActivity;
-(void)clickProfile;

@end
