//
//  InterestsCollectionViewCell.h
//  Millie
//
//  Created by Emmanuel Masangcay on 6/5/15.
//  Copyright (c) 2015 CoderEXP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InterestsCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UILabel *labelInterest;

@property (strong, nonatomic) IBOutlet UIView *viewCellFrame;

-(void)cellTapped;

@end
