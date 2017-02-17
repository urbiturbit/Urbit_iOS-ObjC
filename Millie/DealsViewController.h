//
//  DealsViewController.h
//  Millie
//
//  Created by Emmanuel Masangcay on 6/16/15.
//  Copyright (c) 2015 CoderEXP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MerchantLabelHeaders.h"

@interface DealsViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITableView *tableViewDeals;
@property (strong, nonatomic) IBOutlet MerchantLabelHeaders *labelDeals;
@property NSArray *arrayOfDeals;
@property NSString *stringSearch;


@end
