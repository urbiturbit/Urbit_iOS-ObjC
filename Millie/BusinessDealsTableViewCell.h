//
//  BusinessDealsTableViewCell.h
//  Millie
//
//  Created by Emmanuel Masangcay on 7/8/15.
//  Copyright (c) 2015 CoderEXP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BusinessDealsTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *labelDealTitle;
@property (strong, nonatomic) IBOutlet UILabel *labelDealDescription;
@property (strong, nonatomic) IBOutlet UILabel *labelDealCount;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewDealBusiness;

@end
