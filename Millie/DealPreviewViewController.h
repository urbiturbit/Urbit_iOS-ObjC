//
//  DealPreviewViewController.h
//  Millie
//
//  Created by Emmanuel Masangcay on 6/29/15.
//  Copyright (c) 2015 CoderEXP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DealPreviewViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *imageViewDealPhoto;
@property (strong, nonatomic) IBOutlet UILabel *labelDealDescription;
@property (strong, nonatomic) IBOutlet UILabel *labelDealBusinessName;
@property (strong, nonatomic) IBOutlet UILabel *labelDealValidDate;
@property (strong, nonatomic) IBOutlet UILabel *labelDealValidExpDate;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewDealBusiness;

@end
