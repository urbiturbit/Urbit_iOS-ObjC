//
//  FeatureDealsCollectionViewCell.h
//  Millie
//
//  Created by Emmanuel Masangcay on 6/17/15.
//  Copyright (c) 2015 CoderEXP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeatureDealsCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UILabel *labelFeatureDealDescription;
@property (strong, nonatomic) IBOutlet UILabel *labelFeatureMerchant;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewFeatureDeal;

@end
