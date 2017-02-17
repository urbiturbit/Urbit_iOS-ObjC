//
//  SearchDealResultsViewController.m
//  Millie
//
//  Created by Emmanuel Masangcay on 7/20/15.
//  Copyright (c) 2015 CoderEXP. All rights reserved.
//

#import "SearchDealResultsViewController.h"
#import "DealsTableViewCell.h"
#import "DealsDetailViewController.h"
#import "MillieAPIClient.h"
#import "Utility.h"
#import "User.h"
#import "Deal.h"
#import "UIColor+HEX.h"
#import <SDWebImage/UIImageView+WebCache.h>


@interface SearchDealResultsViewController ()

@property NSMutableArray *arrayMyActivations;
@property NSMutableArray *arrayMyDeals;
@property NSMutableArray *arrayMyDealImages;
@property NSMutableArray *arrayBusinessImages;

@property NSMutableArray *arrayOfDeals;

@property Deal *dealSelected;
@property NSDictionary *businessDealSelected;
@property NSDictionary *activationSelected;

@property (strong, nonatomic) IBOutlet UIView *viewHeaderMyDeals;
@property User *currentUser;
@property UIRefreshControl *mannyFresh;
@property (strong, nonatomic) IBOutlet UITableView *tableViewUserDeals;

@property UIView *loadingView;

@property DealsDetailViewController *dDVC;

@property UIImage *dealBusinessImageSelected;

@property BOOL refresh;

@end

@implementation SearchDealResultsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.currentUser = [User sharedSingleton];

    [self.navigationController.navigationBar setHidden:YES];


    float heightOfLabelDeals = self.view.frame.origin.y + self.viewHeaderMyDeals.frame.size.height;
    float heightOfTabBar = self.tabBarController.tabBar.frame.size.height;
    float sumHeightOfElements = heightOfLabelDeals + heightOfTabBar;
    float heightOfTableview = self.view.frame.size.height - sumHeightOfElements ;

    CGRect frameTableview = CGRectMake(0, heightOfLabelDeals-6, self.view.frame.size.width, heightOfTableview+6);

    self.tableViewUserDeals.frame = frameTableview;

}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
}

#pragma mark - UITableView Delegate Methods


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayOfSearchDeals.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    DealsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellDeals"];

    Deal *deal = [self.arrayOfSearchDeals objectAtIndex:indexPath.row];

    NSString *dealDescription = deal.dealDescription;
    NSString *dealTitle = deal.dealTitle;
    UIImage *imageDeal = deal.dealImage;

    cell.labelDealDescription.text = dealDescription;
    cell.labelDealMerchant.text = dealTitle;
    cell.imageViewDeal.image = imageDeal;

    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *token = [Lockbox stringForKey:@"token"];

    Deal *dealSelected = [self.arrayOfSearchDeals objectAtIndex:indexPath.row];

    self.dealSelected = dealSelected;

    NSString *dealBusinessID = dealSelected.businessID;

    [MillieAPIClient getBusinessByID:token businessID:dealBusinessID completion:^(NSDictionary *result)
     {
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

                                             self.dealBusinessImageSelected = image;
                                             [self performSegueWithIdentifier:@"showDealDetail3" sender:self];
                                         }
                                     }];
             }

             else
             {
                 self.dealBusinessImageSelected = [UIImage imageNamed:@"EditShop"];
                  [self performSegueWithIdentifier:@"showDealDetail3" sender:self];
             }
             
         }

     }];
}
- (IBAction)buttonPressCancelSearchResults:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark - Segue Methods

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqual:@"showDealDetail3"]) {

        self.dDVC = [segue destinationViewController];

        self.dDVC.dealBusiness = self.businessDealSelected;
        self.dDVC.dealSelected = self.dealSelected;
        self.dDVC.businessImage = self.dealBusinessImageSelected;

    }

}


@end
