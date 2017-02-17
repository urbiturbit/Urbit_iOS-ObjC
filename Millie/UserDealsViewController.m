//
//  UserDealsViewController.m
//  Millie
//
//  Created by Emmanuel Masangcay on 7/7/15.
//  Copyright (c) 2015 CoderEXP. All rights reserved.
//

#import "UserDealsViewController.h"
#import "DealsTableViewCell.h"
#import "UserDealsDetailViewController.h"
#import "MillieAPIClient.h"
#import "Utility.h"
#import "User.h"
#import "Deal.h"
#import "UIColor+HEX.h"
#import <SDWebImage/UIImageView+WebCache.h>



@interface UserDealsViewController ()<UITableViewDataSource, UITableViewDelegate>

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

@property UserDealsDetailViewController *udDVC;

@property UIImage *dealBusinessImageSelected;

@property BOOL refresh;

@end

@implementation UserDealsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.currentUser = [User sharedSingleton];
    self.refresh = NO;


    self.loadingView = [[[NSBundle mainBundle] loadNibNamed:@"LoadingView"
                                                      owner:self
                                                    options:nil] objectAtIndex:0];

    CGRect loadingFrame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    self.loadingView.frame = loadingFrame;
    [self.view addSubview:self.loadingView];
    self.loadingView.alpha = 1;

    //Refresh Control Setup
    self.mannyFresh = [[UIRefreshControl alloc] init];
    self.mannyFresh.tintColor = [UIColor colorwithHexString:@"#72c74a" alpha:.9];
    [self.mannyFresh addTarget:self action:@selector(refershControlAction) forControlEvents:UIControlEventValueChanged];
    [self.tableViewUserDeals addSubview:self.mannyFresh];

    [self.navigationController.navigationBar setHidden:YES];


    [self loadMyDealsAndActivations];


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
    return self.arrayOfDeals.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    DealsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellDeals"];

    Deal *deal = [self.arrayOfDeals objectAtIndex:indexPath.row];

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

    Deal *dealSelected = [self.arrayOfDeals objectAtIndex:indexPath.row];

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
                                            [self performSegueWithIdentifier:@"showUserDealDetail" sender:self];
                                        }
                                    }];
            }
            
        }

    }];
}

#pragma mark - Helper Methods

-(void)refershControlAction
{
    self.refresh = YES;

    [self loadMyDealsAndActivations];
}


-(void)loadMyDealsAndActivations
{
    NSString *token = [Lockbox stringForKey:@"token"];
    self.arrayMyActivations = [NSMutableArray new];
    self.arrayMyDeals = [NSMutableArray new];
    self.arrayMyDealImages = [NSMutableArray new];
    self.arrayOfDeals = [NSMutableArray new];


    [MillieAPIClient getActivationsForUser:token completion:^(NSDictionary *result) {
        NSLog(@"Activations: %@",result);

        NSArray *activations = [result objectForKey:@"activations"];

        if (activations.count < 1) {
            [self.tableViewUserDeals reloadData];
            [Utility animateViewFadeOut:self.loadingView completion:^(BOOL result) {
                NSLog(@"FAde");

                [self.loadingView removeFromSuperview];
            }];
        }

        for (int i = 0; i< activations.count; i++)
        {

            Deal *deal = [Deal new];

            deal.dealTitle = [[[activations objectAtIndex:i]objectForKey:@"deal"]objectForKey:@"title"];
            deal.dealDescription = [[[activations objectAtIndex:i]objectForKey:@"deal"]objectForKey:@"description"];
            NSString *startTime = [[[activations objectAtIndex:i]objectForKey:@"deal"]objectForKey:@"start_time"];
            NSString *expirationTime = [[[activations objectAtIndex:i]objectForKey:@"deal"]objectForKey:@"expiration_time"];

            NSDateFormatter *dateStart=[[NSDateFormatter alloc]init];
            [dateStart setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZZZZ"];

            NSDateFormatter *dateFinish=[[NSDateFormatter alloc]init];
            [dateFinish setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZZZZ"];

            NSDate *startDate = [dateStart dateFromString:startTime];
            [dateStart setDateFormat:@"cccc, MMM d, hh:mm aa"];

            NSDate *finishDate = [dateFinish dateFromString:expirationTime];
            [dateFinish setDateFormat:@"cccc, MMM d, hh:mm aa"];


            deal.startTime =  [dateStart stringFromDate:startDate];
            deal.expirationTime = [dateFinish stringFromDate:finishDate];

           deal.termsAndCondition = [[[activations objectAtIndex:i]objectForKey:@"deal"]objectForKey:@"terms_and_conditions"];
           deal.zipCode = [[[activations objectAtIndex:i]objectForKey:@"deal"]objectForKey:@"zipcode"];
           deal.activationCode = [[[activations objectAtIndex:i]objectForKey:@"activation"]objectForKey:@"random_code"];
           deal.businessID = [[[activations objectAtIndex:i]objectForKey:@"deal"]objectForKey:@"business_id"];
           deal.dealID = [[[activations objectAtIndex:i]objectForKey:@"deal"]objectForKey:@"id"];

           [MillieAPIClient getDealImage:token businessID:deal.businessID dealID:deal.dealID completion:^(NSDictionary *result) {

               NSString *imageURL = [result objectForKey:@"image_url"];
               NSURL *urlImage = [NSURL URLWithString:imageURL];


               SDWebImageManager *manager = [SDWebImageManager sharedManager];
               [manager downloadImageWithURL:urlImage
                                     options:0
                                    progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                        // progression tracking code
                                    }
                                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                       if (image) {


                                           deal.dealImage = image;

                                           [self.arrayOfDeals addObject:deal];

                                           if (self.arrayOfDeals.count == activations.count) {

                                               if (self.refresh == NO)
                                               {
                                                   [self.tableViewUserDeals reloadData];
                                                   [Utility animateViewFadeOut:self.loadingView completion:^(BOOL result) {
                                                       NSLog(@"FAde");
                                                       
                                                       [self.loadingView removeFromSuperview];
                                                   }];
                                               }
                                               
                                               [self.mannyFresh endRefreshing];
                                               
                                           }

                                       }
                                   }];

           }];

        }

    }];

}

#pragma mark - Segue Methods

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqual:@"showUserDealDetail"]) {

        self.udDVC = [segue destinationViewController];
        self.udDVC.dealSelected = self.dealSelected;
        self.udDVC.dealBusiness = self.businessDealSelected;
        
        self.udDVC.arrayBusinessImages = self.arrayBusinessImages;
    }
}
@end
