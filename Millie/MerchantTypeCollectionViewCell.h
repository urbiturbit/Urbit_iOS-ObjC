//
//  MerchantTypeCollectionViewCell.h
//  Millie
//
//  Created by Emmanuel Masangcay on 6/8/15.
//  Copyright (c) 2015 CoderEXP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MerchantTypeCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UILabel *labelInterest;
@property (strong, nonatomic) IBOutlet UIView *viewCellFrame;


-(void)cellTapped;

@end
