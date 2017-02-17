//
//  HomeDealsViewController.m
//  Millie
//
//  Created by Emmanuel Masangcay on 6/17/15.
//  Copyright (c) 2015 CoderEXP. All rights reserved.
//

#import "HomeDealsViewController.h"
#import "MerchantLabelHeaders.h"
#import "FeatureDealsCollectionViewCell.h"
#import "DealsCategoryTableViewCell.h"
#import "DealsViewController.h"
#import "DealsDetailViewController.h"
#import "MillieAPIClient.h"
#import "Utility.h"
#import "User.h"
#import "Image.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface HomeDealsViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UITableViewDataSource, UITableViewDelegate>

@property NSMutableArray *arrayOfDeals;
@property NSMutableArray *arrayOfDealImages;
@property NSMutableArray *arrayOfCategoryDeals;
@property NSMutableArray *arrayOfCategoryDealImages;
@property NSMutableArray *arrayOfBusinessImages;

@property NSMutableArray *arrayOfCategories;

@property (strong, nonatomic) IBOutlet UICollectionView *collectionViewFeatureDeals;
@property (strong, nonatomic) IBOutlet MerchantLabelHeaders *labelDealHomeHeader;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *heightOfCollectionView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *widthOfCollectionView;
@property (strong, nonatomic) IBOutlet UITableView *tableViewCategories;
@property CGFloat cellWidth;
@property CGFloat cellHeight;
@property CGFloat animationDifference;
@property CGRect selectedCategoryRect;

@property float collectionHeight;

@property DealsViewController *dvc;

@property (nonatomic) CGRect chosenCellFrame;
@property UIButton *buttonCancelDetailDealView;

@property UIImageView *selectedCategory;
@property UIView *loadingView;

@property (strong, nonatomic) IBOutlet UIPageControl *pageControlFeature;

@property User *currentUser;
@property NSDictionary *businessDealSelected;
@property NSDictionary *dealInfo;

@property DealsDetailViewController *dDVC;

@property  NSString *token;
@property int count;

@property UIImage *selectedImage;

@end

@implementation HomeDealsViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentUser = [User sharedSingleton];
    [self.navigationController.navigationBar setHidden:YES];
    self.count = 0;

    self.arrayOfCategories= [NSMutableArray new];
    UIImage *imageOfSpaAndWellness = [UIImage imageNamed:@"SpaWellness"];
    UIImage *imageOfFoodAndDrink = [UIImage imageNamed:@"FoodDrink"];
    UIImage *imageOfHealthFitness = [UIImage imageNamed:@"HealthFitness"];
    UIImage *imageOfShopping = [UIImage imageNamed:@"Shopping"];
    [self.arrayOfCategories addObject:imageOfFoodAndDrink];
    [self.arrayOfCategories addObject:imageOfSpaAndWellness];
    [self.arrayOfCategories addObject:imageOfShopping];
    [self.arrayOfCategories addObject:imageOfHealthFitness];

    self.loadingView = [[[NSBundle mainBundle] loadNibNamed:@"LoadingView"
                                                      owner:self
                                                    options:nil] objectAtIndex:0];

    CGRect loadingFrame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    self.loadingView.frame = loadingFrame;
    [self.view addSubview:self.loadingView];
    self.loadingView.alpha = 1;

    // Get Feature Deals
    self.token = [Lockbox stringForKey:@"token"];

    [MillieAPIClient getMarketPlaceDeals:self.token completion:^(NSDictionary *result)
     {
         NSLog(@"Result: %@",result);
         self.currentUser.featureDeals = [result objectForKey:@"deals"];

         self.arrayOfDeals = [NSMutableArray new];
         self.arrayOfDealImages = [NSMutableArray new];

         for (NSDictionary *deal in self.currentUser.featureDeals)
         {

             NSDictionary *dealio = [deal objectForKey:@"Deal"];
             NSString *imageURL = [[[deal objectForKey:@"images"]objectAtIndex:0]objectForKey:@"image_url"];


             [self.arrayOfDeals addObject:dealio];
             [self.arrayOfDealImages addObject:imageURL];

             if (deal == [self.currentUser.featureDeals lastObject]) {
                 [self.collectionViewFeatureDeals reloadData];

                 [Utility animateViewFadeOut:self.loadingView completion:^(BOOL result) {
                     NSLog(@"FAde");
                     [self.loadingView removeFromSuperview];
                 }];
             }
             
         }
     }];


}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];

}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];

       [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissAllViewControllers:) name:@"YourDismissAllViewControllersIdentifier" object:nil];

    }


#pragma mark - UICollectionView Methods

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
   return self.arrayOfDeals.count;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FeatureDealsCollectionViewCell *cellFeature = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellFeature" forIndexPath:indexPath];

    //Resetting the width and height constraints of the CollectionView
    self.heightOfCollectionView.constant = self.cellHeight;
    self.widthOfCollectionView.constant = self.cellWidth;

    //Setting the page control
    [self.pageControlFeature setCurrentPage:indexPath.row];


    NSString *dealDescription = [[self.arrayOfDeals objectAtIndex:indexPath.row]objectForKey:@"description"];
    NSString *dealMerchant = [[self.arrayOfDeals objectAtIndex:indexPath.row]objectForKey:@"title"];
//
//    NSString *stringImage = [self.arrayOfDealImages objectAtIndex:indexPath.row];
    NSString *urlImage = [NSString stringWithFormat:@"%@.png",[self.arrayOfDealImages objectAtIndex:indexPath.row]];

    [cellFeature.imageViewFeatureDeal sd_setImageWithURL:[NSURL URLWithString:urlImage]
                      placeholderImage:[UIImage imageNamed:@"featuredeals.png"]];

    cellFeature.labelFeatureDealDescription.text = dealDescription;
    cellFeature.labelFeatureMerchant.text = dealMerchant;

    return cellFeature;
}

// Resizing the UICollectionViewCell by iPhone Device Screen Size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{

    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;

    if (screenWidth == 375) //iphone6
    {
        self.cellWidth = 375;
        self.cellHeight = 267;

    }
    if (screenWidth == 320) //iphone5
    {
        self.cellWidth = 320;
        self.cellHeight = 267;
    }
    if (screenWidth == 414) //iphone6+
    {
        self.cellWidth = 414;
        self.cellHeight = 267;
    }

    float heightOfCollectionView = self.collectionViewFeatureDeals.frame.size.height;
    float heightOfTabBar = self.tabBarController.tabBar.frame.size.height;
    float heightOfLabelHeader = self.labelDealHomeHeader.frame.size.height;
    float sumHeightOfElements = heightOfCollectionView + heightOfTabBar + heightOfLabelHeader;

    float sumHeightOfHeaderAndCollectionView = heightOfLabelHeader + self.cellHeight;
    float heightOfTableview = self.view.frame.size.height - sumHeightOfElements;

    CGRect frameTableview = CGRectMake(0, sumHeightOfHeaderAndCollectionView, self.cellWidth, heightOfTableview);

    self.tableViewCategories.frame = frameTableview;
    return CGSizeMake(self.cellWidth, self.cellHeight);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.arrayOfBusinessImages = [NSMutableArray new];

    NSLog(@"Tapped:%@",indexPath);

    NSString *token = [Lockbox stringForKey:@"token"];

    NSString *businessID = [[self.arrayOfDeals objectAtIndex:indexPath.row]objectForKey:@"business_id"];

    self.dealInfo = [NSDictionary new];
    self.dealInfo = [self.arrayOfDeals objectAtIndex:indexPath.row];

    [MillieAPIClient getBusinessByID:token businessID:businessID completion:^(NSDictionary *result) {

        self.businessDealSelected = [NSDictionary new];
        self.businessDealSelected = [result objectForKey:@"Business"];

        NSArray *arrayOfBusinessImage = [result objectForKey:@"images"];

        for (int i = 0; i < arrayOfBusinessImage.count; i++)
        {

            NSNumber * isSuccessNumber = (NSNumber *)[[[arrayOfBusinessImage objectAtIndex:i]objectForKey:@"image"]objectForKey:@"main_image"];
            if([isSuccessNumber boolValue] == YES)
            {
                NSURL *imageURL = [[arrayOfBusinessImage objectAtIndex:i]objectForKey:@"image_url"];

                SDWebImageManager *manager = [SDWebImageManager sharedManager];
                [manager downloadImageWithURL:imageURL
                                      options:0
                                     progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                         // progression tracking code
                                     }
                                    completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                        if (image) {

                                            self.selectedImage = image;
                                            [self performSegueWithIdentifier:@"showDealDetail" sender:self];
                                        }
                                    }];
            }
            else
            {
                self.selectedImage = [UIImage imageNamed:@"EditShop"];
                [self performSegueWithIdentifier:@"showDealDetail" sender:self];
            }

        }
    }];


}

#pragma mark - UITableView Delegate Methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayOfCategories.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    DealsCategoryTableViewCell *cellCategory = [tableView dequeueReusableCellWithIdentifier:@"cellCategory"];

    cellCategory.imageViewCategory.image = [self.arrayOfCategories objectAtIndex:indexPath.row];

    return cellCategory;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Tapped:%@",indexPath);
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.dvc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"Deals"];

    // Add Deals to Deal Category Array

    self.arrayOfCategoryDeals = [NSMutableArray new];

    for (NSDictionary *deal in self.arrayOfDeals) {
        if ([[deal objectForKey:@"category"] isEqual:@"BEAUTY AND SPA"] && indexPath.row == 1) {

            [self.arrayOfCategoryDeals addObject:deal];
        }
        else if ([[deal objectForKey:@"category"] isEqual:@"FOOD and DRINK"] && indexPath.row == 0)
        {
            [self.arrayOfCategoryDeals addObject:deal];
        }
        else if ([[deal objectForKey:@"category"] isEqual:@"HEALTH AND FITNESS"] && indexPath.row == 3)
        {
            [self.arrayOfCategoryDeals addObject:deal];
        }
        else if ([[deal objectForKey:@"category"] isEqual:@"SHOPPING"] && indexPath.row == 2)
        {
            [self.arrayOfCategoryDeals addObject:deal];
        }
    }

//    for (int i = 0; i < self.arrayOfCategoryDeals.count; i++)
//    {
//        Deal *deal = [Deal new];
//        deal.dealDescription = [[self.arrayOfCategoryDeals objectAtIndex:i]objectForKey:@"description"];
//        deal.dealTitle = [[self.arrayOfCategoryDeals objectAtIndex:i]objectForKey:@"title"];
//
////        NSURL *imageURL = [[arrayOfBusinessImage objectAtIndex:i]objectForKey:@"image_url"];
////
////        SDWebImageManager *manager = [SDWebImageManager sharedManager];
////        [manager downloadImageWithURL:imageURL
////                              options:0
////                             progress:^(NSInteger receivedSize, NSInteger expectedSize) {
////                                 // progression tracking code
////                             }
////                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
////                                if (image) {
////
////                                    self.selectedImage = image;
////                                    [self performSegueWithIdentifier:@"showDealDetail" sender:self];
////                                }
////                            }];
//
//    }
//

    self.dvc.arrayOfDeals = self.arrayOfCategoryDeals;

    self.dvc.view.frame = CGRectMake(self.view.frame.origin.x, -500, self.dvc.view.frame.size.width, self.dvc.view.frame.size.height - 95 );

    self.selectedCategoryRect = [self.tableViewCategories rectForRowAtIndexPath:indexPath];

    self.selectedCategory = [[UIImageView alloc]initWithFrame:CGRectMake(0,self.tableViewCategories.frame.origin.y + self.selectedCategoryRect.origin.y, self.view.frame.size.width, self.labelDealHomeHeader.frame.size.height +50)];
    self.selectedCategory.image = [self.arrayOfCategories objectAtIndex:indexPath.row];
    [self.view addSubview:self.selectedCategory];
    self.selectedCategory.alpha = 0;

    float sumHeightOfElements = self.labelDealHomeHeader.frame.size.height + self.collectionViewFeatureDeals.frame.size.height + self.selectedCategoryRect.origin.y;
    self.animationDifference = self.view.frame.origin.y - sumHeightOfElements;

    [UIView animateWithDuration:0.5 animations:^{
        self.tableViewCategories.alpha = 0;
        self.collectionViewFeatureDeals.alpha = 0;
        self.pageControlFeature.alpha = 0;
        self.selectedCategory.alpha = 1;
    } completion:^(BOOL finished) {
    [UIView animateWithDuration:0.2f delay:0.f options:UIViewAnimationOptionCurveEaseIn animations:^{
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
        } completion:^(BOOL finished)
        {
            self.selectedCategory.transform = CGAffineTransformMakeTranslation(0, 0);

            [UIView animateKeyframesWithDuration:0.8/4 delay:0 options:0 animations:^{

                self.selectedCategory.transform = CGAffineTransformMakeTranslation(0,-50);

            } completion:^(BOOL finished) {
                [UIView animateKeyframesWithDuration:0.8/4 delay:0 options:0 animations:^{

                    self.selectedCategory.transform = CGAffineTransformMakeTranslation(0,-250);

                } completion:^(BOOL finished) {
                    [UIView animateKeyframesWithDuration:0.8/4 delay:0 options:0 animations:^{

                        self.selectedCategory.transform = CGAffineTransformMakeTranslation(0,self.animationDifference);
                    } completion:^(BOOL finished) {
                        [UIView animateKeyframesWithDuration:0.8/4 delay:0 options:0 animations:^{

                        } completion:^(BOOL finished) {

                            [self.view addSubview:self.dvc.view];
                            [self.view bringSubviewToFront:self.selectedCategory];
                            self.dvc.tableViewDeals.alpha = 0;

                            // ******** SignUp Button ******** //
                            self.buttonCancelDetailDealView = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                            [self.buttonCancelDetailDealView setTitle:@"<" forState:UIControlStateNormal];
                            [self.buttonCancelDetailDealView.titleLabel setFont:[UIFont fontWithName:@"Raleway-Regular" size:35]];

                            [self.buttonCancelDetailDealView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                            [self.buttonCancelDetailDealView setBackgroundColor:[UIColor clearColor]];

                            [self.buttonCancelDetailDealView addTarget:self
                                                                action:@selector(clickBack)
                                                      forControlEvents:UIControlEventTouchUpInside];
                            [self.view addSubview:self.buttonCancelDetailDealView];

                            self.buttonCancelDetailDealView.alpha = 0;

                            [UIView animateWithDuration:0.9 animations:^{
                                
                                self.dvc.tableViewDeals.alpha = 1;
                                self.dvc.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + self.selectedCategory.frame.size.height, self.dvc.view.frame.size.width, self.dvc.view.frame.size.height );
                                //set the frame
                                CGRect btnNextFrame = CGRectMake(20, self.selectedCategory.frame.size.height+5 , 30, 30);
                                 self.buttonCancelDetailDealView.frame = btnNextFrame;


                                self.buttonCancelDetailDealView.alpha = 1;
                                [self.view bringSubviewToFront:self.buttonCancelDetailDealView];


                            } completion:^(BOOL finished) {
                                NSLog(@"Finished");
                            }];}];}];}];}];}];}];}];
}

#pragma  mark - Action Methods

-(void)clickBack
{
    NSLog(@"Click Back");

    [UIView animateWithDuration:0.9 animations:^{

        self.dvc.view.frame = CGRectMake(self.view.frame.origin.x, -500, self.dvc.view.frame.size.width, self.dvc.view.frame.size.height );
        self.dvc.view.alpha = 0;

    } completion:^(BOOL finished) {
        NSLog(@"Finished");
        self.buttonCancelDetailDealView.alpha = 0;
        [self.dvc.view removeFromSuperview];
        [self.buttonCancelDetailDealView removeFromSuperview];

        [UIView animateWithDuration:0.8f delay:5 options:UIViewAnimationOptionCurveEaseIn animations:^{
        } completion:^(BOOL finished) {

            self.selectedCategory.transform = CGAffineTransformMakeTranslation(0, -416);

            [UIView animateWithDuration:0.9 animations:^{
            } completion:^(BOOL finished)
             {
                 self.selectedCategory.transform = CGAffineTransformMakeTranslation(0, -350);

                 [UIView animateKeyframesWithDuration:0.8/4 delay:0 options:0 animations:^{

                     self.selectedCategory.transform = CGAffineTransformMakeTranslation(0, -150);

                 } completion:^(BOOL finished) {
                     [UIView animateKeyframesWithDuration:0.8/4 delay:0 options:0 animations:^{

                         self.selectedCategory.transform = CGAffineTransformMakeTranslation(0, 0);

                     } completion:^(BOOL finished)
                      {
                          [UIView animateWithDuration:0.8 animations:^{
                              self.tableViewCategories.alpha = 1;
                              self.collectionViewFeatureDeals.alpha = 1;
                              self.pageControlFeature.alpha = 1;
                              self.selectedCategory.alpha = 0;
                          } completion:^(BOOL finished) {

                              [self.selectedCategory removeFromSuperview];

                          }];

                      }];
                 }];}];}];}];
}

#pragma mark - Segue Methods

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqual:@"showDealDetail"]) {

        self.dDVC = [segue destinationViewController];

        self.dDVC.dealBusiness = self.businessDealSelected;
        self.dDVC.dealInfo = self.dealInfo;
        self.dDVC.businessImage = self.selectedImage;
    }
}

#pragma mark - Notification Methods

// this method gets called whenever a notification is posted to dismiss all view controllers
- (void)dismissAllViewControllers:(NSNotification *)notification {
    // dismiss all view controllers in the navigation stack
    [self dismissViewControllerAnimated:YES completion:^{}];
}

@end
