//
//  InterestsCollectionViewController.m
//  Millie
//
//  Created by Emmanuel Masangcay on 6/5/15.
//  Copyright (c) 2015 CoderEXP. All rights reserved.
//

#import "InterestsCollectionViewController.h"
#import "InterestsCollectionViewCell.h"
#import "UIColor+HEX.h"

@interface InterestsCollectionViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property NSArray *arrayOfInterests;


@end

@implementation InterestsCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.arrayOfInterests = [NSArray arrayWithObjects:@"SPA",@"PETS",@"FOOD",@"SPORTS",@"HEALTH",@"FITNESS",@"HOME",@"AUTO",@"FASHION",@"ARTS", nil];
}

#pragma mark - UICollection Delegate Methods

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.arrayOfInterests.count;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    InterestsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"interestCell" forIndexPath:indexPath];
    NSString *interest = [self.arrayOfInterests objectAtIndex:indexPath.row];

    cell.labelInterest.text =interest;



    //cell.viewCellFrame = [self roundcornersonview:cell.viewCellFrame radius:50];

    CALayer *layer = cell.viewCellFrame.layer;
    layer.backgroundColor = [[UIColor clearColor] CGColor];
    layer.borderColor = [[UIColor whiteColor] CGColor];
    layer.borderWidth = 1.0f;

    

    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    InterestsCollectionViewCell *cell = (InterestsCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];

    [cell cellTapped];

    NSString  *interest = [self.arrayOfInterests objectAtIndex:indexPath.row];

    if ([self.delegate checkInterest:interest])
    {
        [self.delegate removeInterest:interest];
    }
    else
    {
        [self.delegate tapInterest:interest];
    }

}



-(UIView *)roundcornersonview:(UIView *)view radius:(float)radius {
    UIRectCorner corner;
    corner = UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomRight | UIRectCornerBottomLeft;
    UIView *roundedview = view;
    UIBezierPath *maskpath = [UIBezierPath bezierPathWithRoundedRect:roundedview.bounds byRoundingCorners:corner cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *masklayer = [CAShapeLayer layer];
    masklayer.frame = roundedview.bounds;
    masklayer.path = maskpath.CGPath;
    roundedview.layer.mask = masklayer;
    return roundedview;
    //#5A589A
}

@end
