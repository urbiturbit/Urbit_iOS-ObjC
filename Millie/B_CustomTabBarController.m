//
//  B_CustomTabBarController.m
//  Millie
//
//  Created by Emmanuel Masangcay on 6/16/15.
//  Copyright (c) 2015 CoderEXP. All rights reserved.
//

#import "B_CustomTabBarController.h"
#import "B_CustomTabBar.h"

@interface B_CustomTabBarController ()<B_CustomTabBarDelegate>

@property (strong, nonatomic) IBOutlet UITabBar *tabBarNavigation;
@end

@implementation B_CustomTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];

    //add the custom tabbarcontroller
    customTabBar = [[B_CustomTabBar alloc] initWithFrame:CGRectMake(0,self.view.bounds.size.height - 49, self.view.bounds.size.width, 49)];

    customTabBar.delegate = self;


    [self.view addSubview:customTabBar];

    self.tabBarNavigation.hidden = YES;
}

#pragma mark - B_CustomTabBar Delegate Methods

-(void)onClickCreateNewDeal
{
    NSLog(@"CreateNewDeal");
    self.selectedIndex = 0;
}

-(void)onClickSearch
{
    NSLog(@"Search");
    self.selectedIndex = 1;
}

-(void)onClickNews
{
    NSLog(@"News");

}

-(void)onClickActivity
{
    NSLog(@"Activity");
    self.selectedIndex = 2;
}

-(void)onClickProfile
{
    NSLog(@"Profile");
    self.selectedIndex = 3;
}

@end
