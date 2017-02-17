//
//  BusinessDetailViewController.m
//  Millie
//
//  Created by Emmanuel Masangcay on 7/19/15.
//  Copyright (c) 2015 CoderEXP. All rights reserved.
//

#import "BusinessDetailViewController.h"
#import "BusinessDetailCollectionViewCell.h"
#import "MillieLabel.h"
#import <SDWebImage/UIImageView+WebCache.h>


@interface BusinessDetailViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (strong, nonatomic) IBOutlet MillieLabel *labelBusinessName;
@property (strong, nonatomic) IBOutlet MillieLabel *labelBusinessDescription;
@property (strong, nonatomic) IBOutlet MillieLabel *labelPhone;
@property (strong, nonatomic) IBOutlet MillieLabel *labelHours;
@property (strong, nonatomic) IBOutlet MillieLabel *labelAddress;

@end

@implementation BusinessDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.labelBusinessName.text = [self.business objectForKey:@"name"];
    self.labelPhone.text = [self.business objectForKey:@"phone"];
    self.labelHours.text = [self.business objectForKey:@"hours_of_operation"];
    self.labelAddress.text = [self.business objectForKey:@"address"];

}

#pragma mark - UICollectionView Methods

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{

    if (self.arrayOfImages.count < 1) {
        return 1;
    }
    else
    {
    return self.arrayOfImages.count;
    }
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
   BusinessDetailCollectionViewCell *cellBusiness = [collectionView dequeueReusableCellWithReuseIdentifier:@"businessDetail" forIndexPath:indexPath];

    if (self.arrayOfImages.count < 1) {
        [cellBusiness.imageViewBusinessPhotos sd_setImageWithURL:[NSURL URLWithString:nil]
                                                placeholderImage:[UIImage imageNamed:@"business"]];

        return cellBusiness;
    }
    else
    {
        NSString *urlImage = [NSString stringWithFormat:@"%@.png",[self.arrayOfImages objectAtIndex:indexPath.row]];

        [cellBusiness.imageViewBusinessPhotos sd_setImageWithURL:[NSURL URLWithString:urlImage]
                                                placeholderImage:[UIImage imageNamed:@"featuredeals.png"]];

        
        return cellBusiness;
    }




    
    
}

- (IBAction)onButtonCancelBusinessDetail:(id)sender
{
[self dismissViewControllerAnimated:YES completion:^{
    
}];

}


@end
