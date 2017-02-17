//
//  DealsDetailViewController.h
//  Millie
//
//  Created by Emmanuel Masangcay on 7/6/15.
//  Copyright (c) 2015 CoderEXP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Deal.h"

@interface DealsDetailViewController : UIViewController

@property NSDictionary *dealBusiness;
@property NSDictionary *dealInfo;
@property NSMutableArray *arrayOfBusinessImages;
@property Deal *dealSelected;
@property UIImage *businessImage;

@end
