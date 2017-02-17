//
//  DealsViewController.m
//  Millie
//
//  Created by Emmanuel Masangcay on 6/16/15.
//  Copyright (c) 2015 CoderEXP. All rights reserved.
//

#import "DealsViewController.h"
#import "MerchantLabelHeaders.h"
#import "DealsTableViewCell.h"
#import "DealsDetailViewController.h"
#import "MillieAPIClient.h"
#import "Utility.h"
#import "MillieButton.h"
#import <SDWebImage/UIImageView+WebCache.h>


@interface DealsViewController ()<UITableViewDataSource,UITableViewDelegate>


@property  NSDictionary *businessDealSelected;
@property  NSDictionary *dealInfo;
@property DealsDetailViewController *dDVC;
@property NSMutableArray *arrayOfDealImages;
@property MillieButton *buttonCancelDetailView;

@property UIImage *selectedImage;


@end

@implementation DealsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.arrayOfDealImages = [NSMutableArray new];

    NSString *token = [Lockbox stringForKey:@"token"];
    for (NSDictionary *deals in self.arrayOfDeals) {
        NSString *dealID = [deals objectForKey:@"id"];
        NSString *businessID = [deals objectForKey:@"business_id"];

        [MillieAPIClient getDealImage:token businessID:businessID dealID:dealID completion:^(NSDictionary *result) {


            NSString *imageURL = [result objectForKey:@"image_url"];

            if (imageURL == nil) {
                imageURL = @"";
            }

            [self.arrayOfDealImages addObject:imageURL];


        }];
    }

    float heightOfLabelDeals = self.labelDeals.frame.size.height;
    float heightOfTabBar = self.tabBarController.tabBar.frame.size.height;
    float sumHeightOfElements = heightOfLabelDeals + heightOfTabBar;
    float heightOfTableview = self.view.frame.size.height - sumHeightOfElements ;

    CGRect frameTableview = CGRectMake(0, self.labelDeals.frame.size.height, self.view.frame.size.width, heightOfTableview);

    self.tableViewDeals.frame = frameTableview;

}


- (IBAction)onButtonPressCancelSearchDetail:(id)sender
{
    self.stringSearch = @"";

}


#pragma mark - UITableView Delegate Methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayOfDeals.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    DealsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellDeals"];

    NSString *dealDescription = [[self.arrayOfDeals objectAtIndex:indexPath.row]objectForKey:@"description"];
    NSString *dealMerchant = [[self.arrayOfDeals objectAtIndex:indexPath.row]objectForKey:@"title"];

    NSString *stringImage = [self.arrayOfDealImages objectAtIndex:indexPath.row];
    NSURL *urlImage = [NSURL URLWithString:stringImage];
    NSData *dataImage = [NSData dataWithContentsOfURL:urlImage];

    UIImage *imageFeatureDeal = [UIImage imageWithData:dataImage];

    cell.labelDealDescription.text = dealDescription;
    cell.labelDealMerchant.text = dealMerchant;

    if ([stringImage isEqual: @""]) {
        cell.imageViewDeal.image = [UIImage imageNamed:@"business"];
    }
    else
    {
         cell.imageViewDeal.image = imageFeatureDeal;
    }

    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *token = [Lockbox stringForKey:@"token"];
    
    self.dealInfo = [NSDictionary new];
    self.dealInfo = [self.arrayOfDeals objectAtIndex:indexPath.row];
    
    NSString *businessID = [[self.arrayOfDeals objectAtIndex:indexPath.row]objectForKey:@"business_id"];
    
    [MillieAPIClient getBusinessByID:token businessID:businessID completion:^(NSDictionary *result) {
//    
//        self.businessDealSelected = [NSDictionary new];
//        self.businessDealSelected = result;

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
                                            [self performSegueWithIdentifier:@"showDealDetail2" sender:self];
                                        }
                                    }];
            }
            else
            {
                self.selectedImage = [UIImage imageNamed:@"EditShop"];
                [self performSegueWithIdentifier:@"showDealDetail2" sender:self];
            }
            
        }
    

    }];
}



#pragma mark - Segue Methods

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqual:@"showDealDetail2"]) {

        self.dDVC = [segue destinationViewController];

        self.dDVC.dealBusiness = self.businessDealSelected;
        self.dDVC.dealInfo = self.dealInfo;
        self.dDVC.businessImage = self.selectedImage;
    }
}


@end
