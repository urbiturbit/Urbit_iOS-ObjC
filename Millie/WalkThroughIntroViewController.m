//
//  WalkThroughIntroViewController.m
//  MillieApp
//
//  Created by Emmanuel Masangcay on 5/28/15.
//  Copyright (c) 2015 CoderEXP. All rights reserved.
//

#import "WalkThroughIntroViewController.h"
#import "WalkThroughCollectionViewCell.h"
#import "MillieLabel.h"

@interface WalkThroughIntroViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (strong, nonatomic) IBOutlet UIPageControl *mainPageControl;
@property (strong, nonatomic) IBOutlet MillieLabel *labelDescription1;
@property (strong, nonatomic) IBOutlet MillieLabel *labelDescription2;

@property CGFloat cellWidth;
@property CGFloat cellHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *heightOfCollectionView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *weightOfCollectionView;

@end

@implementation WalkThroughIntroViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 3;
}


-(WalkThroughCollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WalkThroughCollectionViewCell *cell;

    //Resetting the width and height constraints of the CollectionView
    self.heightOfCollectionView.constant = self.cellHeight;
    self.weightOfCollectionView.constant = self.cellWidth;

    if (indexPath.row == 0) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"one" forIndexPath:indexPath];
        [self.mainPageControl setCurrentPage:0];

        self.labelDescription1.text = @"HYPERLOCAL DEALS";
        self.labelDescription2.text = @"DIRECT FROM MERCHANTS";

        self.labelDescription1.alpha = 0;
        self.labelDescription2.alpha = 0;

        [UIView animateWithDuration:0.5f delay:0.3f options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.labelDescription1.alpha = 1;
            self.labelDescription2.alpha = 1;
        } completion:^(BOOL finished) {

        }];

        return cell;


    }
    if (indexPath.row == 1) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"two" forIndexPath:indexPath];
        [self.mainPageControl setCurrentPage:1];

        self.labelDescription1.text = @"GAIN LOAYALTY REWARDS";
        self.labelDescription2.text = @"FOR SHOPPING LOCAL";

        self.labelDescription1.alpha = 0;
        self.labelDescription2.alpha = 0;

        [UIView animateWithDuration:0.5f delay:0.3f options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.labelDescription1.alpha = 1;
            self.labelDescription2.alpha = 1;
        } completion:^(BOOL finished) {
            
        }];

        return cell;
    }
    if (indexPath.row == 2) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"three" forIndexPath:indexPath];
        [self.mainPageControl setCurrentPage:2];

        self.labelDescription1.text = @"FOR THE COMMUNITY,";
        self.labelDescription2.text = @"BY THE COMMUNITY";

        self.labelDescription1.alpha = 0;
        self.labelDescription2.alpha = 0;

        [UIView animateWithDuration:0.5f delay:0.3f options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.labelDescription1.alpha = 1;
            self.labelDescription2.alpha = 1;
        } completion:^(BOOL finished) {

        }];

        return cell;
    }
    return nil;
}

// Resizing the UICollectionViewCell by iPhone Device Screen Size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{

    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;

    if (screenWidth == 375) //iphone6
    {
        self.cellWidth = 375;
        self.cellHeight = 667;

    }
    if (screenWidth == 320) //iphone5
    {
        self.cellWidth = 320;
        self.cellHeight = 568;
    }
    if (screenWidth == 414) //iphone6+
    {
        self.cellWidth = 414;
        self.cellHeight = 736;
    }

   
    return CGSizeMake(self.cellWidth, self.cellHeight);
}



#pragma mark - Button Press Methods

- (IBAction)buttonPressLogin:(id)sender {
}

- (IBAction)buttonPressSignUp:(id)sender {
}



@end
