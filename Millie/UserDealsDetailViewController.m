//
//  UserDealsDetailViewController.m
//  Millie
//
//  Created by Emmanuel Masangcay on 7/8/15.
//  Copyright (c) 2015 CoderEXP. All rights reserved.
//

#import "UserDealsDetailViewController.h"
#import "DealsDetailCollectionViewCell.h"
#import "MerchantLabelHeaders.h"
#import "MillieAPIClient.h"
#import "MillieLabel.h"
#import "BusinessDetailViewController.h"
#import "UIColor+HEX.h"
#import <MapKit/MapKit.h>

#define METERS_PER_MILE 1609.344

@interface UserDealsDetailViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *collectionViewWidth;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *dealDetailTopSpace;

@property MillieLabel *labelBusinessName;
@property MillieLabel *labelDetails;
@property MillieLabel *labelMap;
@property MillieLabel *labelBusinessInfo;
@property MillieLabel *labelDealTitle;
@property UIImageView *imageViewBusiness;
@property MKMapView *mapViewDeal;
@property MKPointAnnotation *businessAnnotation;
@property UIView *viewLineSeperator;
@property UIView *viewLineIndicator;
@property UIView *viewIndicator;
@property (strong, nonatomic) IBOutlet MerchantLabelHeaders *labelDealDetailsHeader;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionViewDealsDetail;
@property (strong, nonatomic) IBOutlet UILabel *labelDealDescription;
@property (strong, nonatomic) IBOutlet UILabel *labelDealDetail1;
@property (strong, nonatomic) IBOutlet UILabel *labelDealDetail2;

@property (strong, nonatomic) IBOutlet UILabel *labelActivationCode;

@property BusinessDetailViewController *bDVC;

@property int count;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *dealInfoSpace;

@property CGFloat tabSpace;
@property CGFloat animateSpace;
@property CGFloat datespace;
@property CGFloat cellWidth;
@property CGFloat cellHeight;

@end

@implementation UserDealsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.count = 0;
    [self buildUI];

}

-(void)buildUI
{

    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;

    if (screenWidth == 375) //iphone6
    {
        self.tabSpace = 30;
        self.animateSpace = 20;

    }
    if (screenWidth == 320) //iphone5
    {
        self.tabSpace = 10;
        self.animateSpace = 0;
        self.datespace = 25;
        self.dealInfoSpace.constant = self.datespace;
    }
    if (screenWidth == 414) //iphone6+
    {
        self.cellWidth = 414;
        self.cellHeight = 267;
    }

    //Label
    CGFloat yPosLabelDetail = self.labelDealDetailsHeader.frame.size.height + self.collectionViewDealsDetail.frame.size.height - 80;

    self.labelDetails = [[MillieLabel alloc]initWithFrame:CGRectMake(self.view.frame.origin.x + self.tabSpace , yPosLabelDetail, 80, 100)];
    self.labelDetails.textAlignment = NSTextAlignmentCenter;
    [self.labelDetails setFont:[UIFont fontWithName:@"ProximaNova-Regular" size:20]];
    self.labelDetails.text = @"DETAILS";
    [self.labelDetails setUserInteractionEnabled:YES];

    UITapGestureRecognizer * tapDetails = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapOnLabelDetails:)];

    [self.labelDetails addGestureRecognizer:tapDetails];

    [self.view addSubview:self.labelDetails];


    self.labelMap = [[MillieLabel alloc]initWithFrame:CGRectMake(self.labelDetails.frame.origin.x + 120 , yPosLabelDetail, 70, 100)];
    self.labelMap.textAlignment = NSTextAlignmentCenter;
    [self.labelMap setFont:[UIFont fontWithName:@"ProximaNova-Regular" size:20]];
    self.labelMap.text = @"MAP";
    [self.labelMap setUserInteractionEnabled:YES];

    UITapGestureRecognizer * tapMap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapOnLabelMap:)];

    [self.labelMap addGestureRecognizer:tapMap];

    [self.view addSubview:self.labelMap];


    self.labelBusinessInfo = [[MillieLabel alloc]initWithFrame:CGRectMake(self.labelMap.frame.origin.x + 120 , yPosLabelDetail, 50, 100)];
    self.labelBusinessInfo.textAlignment = NSTextAlignmentCenter;
    [self.labelBusinessInfo setFont:[UIFont fontWithName:@"ProximaNova-Regular" size:20]];
    self.labelBusinessInfo.text = @"INFO";
    [self.labelBusinessInfo setUserInteractionEnabled:YES];

    UITapGestureRecognizer * tapBusinessInfo = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapOnLabelBusinessInfo:)];

    [self.labelBusinessInfo addGestureRecognizer:tapBusinessInfo];

    [self.view addSubview:self.labelBusinessInfo];


    //LineView Seperator
    self.viewLineSeperator = [[UIView alloc]initWithFrame:CGRectMake(0, self.labelDealDetailsHeader.frame.size.height + self.collectionViewDealsDetail.frame.size.height + 5, self.view.frame.size.width, 1)];
    self.viewLineSeperator.backgroundColor = [UIColor blackColor];

    [self.view addSubview:self.viewLineSeperator];

    self.viewIndicator = [[UIView alloc]initWithFrame:CGRectMake(self.labelDetails.frame.origin.x,self.labelDetails.frame.origin.y + 70, self.labelDetails.frame.size.width, 2)];
    self.viewIndicator.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.viewIndicator];


    self.labelDealDescription.text = self.dealSelected.dealDescription;

    self.labelDealDetail1.text = self.dealSelected.startTime;
    self.labelDealDetail2.text = self.dealSelected.expirationTime;

    self.labelActivationCode.text = self.dealSelected.activationCode;

}


#pragma mark - UICollectionView Methods

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 2;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DealsDetailCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"dealsdetailcell" forIndexPath:indexPath];

    //    //Resetting the width and height constraints of the CollectionView
    self.collectionViewHeight.constant = self.cellHeight;
    self.collectionViewWidth.constant = self.cellWidth;

    if (indexPath.row == 0) {

//        [self animateIndicatorDetails];

        [self.labelBusinessName removeFromSuperview];
        [self.labelDealTitle removeFromSuperview];


        //Label Business Name
        self.labelBusinessName = [[MillieLabel alloc]initWithFrame:CGRectMake(0, cell.frame.origin.y , cell.frame.size.width, 50)];
        [self.labelBusinessName setFont:[UIFont fontWithName:@"ProximaNova-Semibold" size:25]];
        self.labelBusinessName.textAlignment = NSTextAlignmentCenter;
        self.labelBusinessName.adjustsFontSizeToFitWidth = YES;

        NSString *businessName = self.dealSelected.dealTitle;
        self.labelBusinessName.text = businessName;

        //ImageView Business Photo/Logo
        self.imageViewBusiness = [[UIImageView alloc]initWithFrame:CGRectMake(cell.center.x - 75, self.labelBusinessName.frame.origin.y +self.labelBusinessName.frame.size.height + 10, 150, 150)];

        self.imageViewBusiness.image = self.dealSelected.dealImage;

        self.imageViewBusiness.layer.cornerRadius = self.imageViewBusiness.frame.size.height /2;
        self.imageViewBusiness.layer.masksToBounds = YES;

        self.labelDealTitle = [[MillieLabel alloc]initWithFrame:CGRectMake(0, self.imageViewBusiness.frame.origin.y +self.imageViewBusiness.frame.size.height + 5, cell.frame.size.width, 50)];
        [self.labelDealTitle setFont:[UIFont fontWithName:@"ProximaNova-Semibold" size:20]];
        self.labelDealTitle.textColor = [UIColor colorwithHexString:@"45B29d" alpha:1];
        self.labelDealTitle.textAlignment = NSTextAlignmentCenter;
        [self.labelDealTitle setNumberOfLines:2];
        self.labelDealTitle.adjustsFontSizeToFitWidth = YES;

        if (!self.dealSelected) {
            //             NSString *dealTitle = [self.dealInfo objectForKey:@"title"];
            self.labelDealTitle.text = self.dealSelected.dealDescription;
        }
        else
        {
            self.labelDealTitle.text = self.dealSelected.dealDescription;
        }

        [cell addSubview:self.labelBusinessName];
        [cell addSubview:self.imageViewBusiness];
        [cell addSubview:self.labelDealTitle];

        return cell;
    }
    else if (indexPath.row == 1)
    {
 //       [self animateIndicatorMap];

        //MapView
        self.mapViewDeal = [[MKMapView alloc]initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height - 50)];
        [self.mapViewDeal setScrollEnabled:NO];
        [cell addSubview:self.mapViewDeal];

        //MapAnnotation
        self.businessAnnotation = [[MKPointAnnotation alloc]init];

        CLLocationCoordinate2D coordinate;
        coordinate.latitude = [[self.dealBusiness objectForKey:@"latitude"]floatValue];
        coordinate.longitude = [[self.dealBusiness objectForKey:@"longitude"]floatValue];

        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(coordinate, 0.4*METERS_PER_MILE, 0.4*METERS_PER_MILE);
        MKCoordinateRegion adjustedRegion = [self.mapViewDeal regionThatFits:viewRegion];
        [self.mapViewDeal setRegion:adjustedRegion animated:YES];

        self.businessAnnotation.coordinate = coordinate;
        self.businessAnnotation.title = [self.dealBusiness objectForKey:@"name"];
        [self.mapViewDeal addAnnotation:self.businessAnnotation];
        
        return cell;
    }
    else
    {
        return nil;
    }
    
}



// Resizing the UICollectionViewCell by iPhone Device Screen Size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{

    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;

    if (screenWidth == 375) //iphone6
    {
        self.cellWidth = 375;
        self.cellHeight = 323;

    }
    if (screenWidth == 320) //iphone5
    {
        self.cellWidth = 320;
        self.cellHeight = 323;
    }
    if (screenWidth == 414) //iphone6+
    {
        self.cellWidth = 414;
        self.cellHeight = 267;
    }

    return CGSizeMake(self.cellWidth, self.cellHeight);
}



#pragma mark - Button Press Methods and Gesture Tap Methods

- (IBAction)onButtonPressCancelDetailDeal:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

-(void)tapOnLabelDetails:(UITapGestureRecognizer*)gesture
{
    NSLog(@"Tapped on Label Detail");
    [self animateIndicatorDetails];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.collectionViewDealsDetail scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
}

-(void)tapOnLabelMap:(UITapGestureRecognizer*)gesture
{
    NSLog(@"Tapped on Label Map");
    [self animateIndicatorMap];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    [self.collectionViewDealsDetail scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionRight animated:YES];

}

-(void)tapOnLabelBusinessInfo:(UITapGestureRecognizer*)gesture
{
    NSLog(@"Tapped on Label Business Info");

    [self performSegueWithIdentifier:@"businessDetail" sender:self];

}

#pragma mark Map View Methods

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    CLLocationCoordinate2D centerCoordinate = view.annotation.coordinate;
    MKCoordinateSpan coordinateSpan;
    coordinateSpan.latitudeDelta = 0.01;
    coordinateSpan.longitudeDelta =0.01;
    MKCoordinateRegion region;
    region.center = centerCoordinate;
    region.span = coordinateSpan;

    [self.mapViewDeal setRegion:region animated:YES];
}
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKPinAnnotationView *pin = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:nil];
    pin.canShowCallout = YES;
    pin.rightCalloutAccessoryView = [ UIButton buttonWithType:UIButtonTypeDetailDisclosure];

    if (annotation == self.businessAnnotation)
    {
        pin.image = [UIImage imageNamed:@"business"];
    }

    return pin;
}


#pragma mark Animation Methods

-(void)animateIndicatorMap
{
    CGFloat xPosIndicator = self.labelMap.frame.origin.x;

    [UIView animateWithDuration:0.1 animations:^{
    } completion:^(BOOL finished) {

        CGRect newFrame = self.viewIndicator.frame;

        newFrame.size.width = 50;
        newFrame.size.height = 2;
        [self.viewIndicator setFrame:newFrame];

        self.viewIndicator.transform = CGAffineTransformMakeTranslation(0, 0);

        [UIView animateKeyframesWithDuration:0.8/4 delay:0 options:0 animations:^{
            self.viewIndicator.transform = CGAffineTransformMakeTranslation(xPosIndicator-self.animateSpace,0);
        } completion:^(BOOL finished) {

        }];
    }];
}

-(void)animateIndicatorDetails
{
    //    CGFloat xPosIndicator = self.labelMap.frame.origin.x;
    CGFloat xPosIndicator = self.labelDetails.frame.origin.x;

    [UIView animateWithDuration:0.1 animations:^{
    } completion:^(BOOL finished) {

        CGRect newFrame = self.viewIndicator.frame;

        newFrame.size.width = self.labelDetails.frame.size.width;
        newFrame.size.height = 2;
        [self.viewIndicator setFrame:newFrame];

        self.viewIndicator.transform = CGAffineTransformMakeTranslation(xPosIndicator,0);

        [UIView animateKeyframesWithDuration:0.8/4 delay:0 options:0 animations:^{
            self.viewIndicator.transform = CGAffineTransformMakeTranslation(0,0);
        } completion:^(BOOL finished) {
            
        }];
    }];}


#pragma mark - Segue Methods

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqual:@"businessDetail"]) {

        self.bDVC = [segue destinationViewController];

        self.bDVC.business = self.dealBusiness;

        NSMutableArray *arrayOfImages = [NSMutableArray new];


        for (NSDictionary *image in self.arrayBusinessImages) {

            self.count = self.count + 1;

            NSString *imageURL = [image objectForKey:@"image_url"];

            NSURL *urlImage = [NSURL URLWithString:imageURL];
            NSData *dataImage = [NSData dataWithContentsOfURL:urlImage];
            UIImage *businessImage = [UIImage imageWithData:dataImage];

            [arrayOfImages addObject:businessImage];

            if ( self.count == self.arrayBusinessImages.count) {
                self.bDVC.arrayOfImages = arrayOfImages;
            }
        }
        
    }
}

@end
