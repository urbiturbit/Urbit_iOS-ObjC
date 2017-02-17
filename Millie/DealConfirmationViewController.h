//
//  DealConfirmationViewController.h
//  Millie
//
//  Created by Emmanuel Masangcay on 6/30/15.
//  Copyright (c) 2015 CoderEXP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DealConfirmationViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *labelConfirmationCode;
@property (strong, nonatomic) IBOutlet UIButton *buttonFacebookShare;
@property (strong, nonatomic) IBOutlet UIButton *buttonTwitterShare;

@property NSString *dealBusinessName;
@property NSString *dealDescription;
@property NSString *dealValidDate;
@property NSString *dealValidTime;

@end
