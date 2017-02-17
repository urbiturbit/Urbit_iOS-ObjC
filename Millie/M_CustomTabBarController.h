//
//  M_CustomTabBarController.h
//  Millie
//
//  Created by Emmanuel Masangcay on 6/16/15.
//  Copyright (c) 2015 CoderEXP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "M_CustomTabBar.h"

@interface M_CustomTabBarController : UITabBarController
{
    M_CustomTabBar *customTabBar;
}

@property NSDictionary*business;

@end
