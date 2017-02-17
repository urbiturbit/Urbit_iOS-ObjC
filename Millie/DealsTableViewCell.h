//
//  DealsTableViewCell.h
//  Millie
//
//  Created by Emmanuel Masangcay on 6/17/15.
//  Copyright (c) 2015 CoderEXP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DealsTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imageViewDeal;

@property (strong, nonatomic) IBOutlet UILabel *labelDealDescription;

@property (strong, nonatomic) IBOutlet UILabel *labelDealMerchant;
@property (strong, nonatomic) IBOutlet UIView *viewDealDescription;

@end
