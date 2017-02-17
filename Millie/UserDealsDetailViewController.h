//
//  UserDealsDetailViewController.h
//  Millie
//
//  Created by Emmanuel Masangcay on 7/8/15.
//  Copyright (c) 2015 CoderEXP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Deal.h"

@interface UserDealsDetailViewController : UIViewController

@property Deal *dealSelected;
@property NSDictionary *dealBusiness;
@property NSMutableArray *arrayBusinessImages;

@end
