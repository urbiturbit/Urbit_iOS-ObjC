//
//  M_CustomTabBarController.m
//  Millie
//
//  Created by Emmanuel Masangcay on 6/16/15.
//  Copyright (c) 2015 CoderEXP. All rights reserved.
//

#import "M_CustomTabBarController.h"
#import "M_CustomTabBar.h"
#import "CreateNewDealViewController.h"

@interface M_CustomTabBarController ()<M_CustomTabBarDelegate>
@property (strong, nonatomic) IBOutlet UITabBar *tabBarNavigation;

@end

@implementation M_CustomTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];

    //add the custom tabbarcontroller
    customTabBar = [[M_CustomTabBar alloc] initWithFrame:CGRectMake(0,self.view.bounds.size.height - 49, self.view.bounds.size.width, 49)];

    customTabBar.delegate = self;

    [self.view addSubview:customTabBar];
    self.tabBarNavigation.hidden = YES;

}

#pragma mark - M_CustomTabBar Delegate Methods

-(void)onClickCreateNewDeal
{
    NSLog(@"CreateNewDeal");
    self.selectedIndex = 0;
}

-(void)onClickMerchantData
{
    NSLog(@"MerchantData");
    self.selectedIndex = 1;
}

-(void)onClickDeals
{
    NSLog(@"Deals");
    self.selectedIndex = 2;
}

-(void)onClickMerchant
{
    NSLog(@"Merchant");
    self.selectedIndex = 3;
}

@end
