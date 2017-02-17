//
//  BusinessDealsViewController.m
//  Millie
//
//  Created by Emmanuel Masangcay on 7/8/15.
//  Copyright (c) 2015 CoderEXP. All rights reserved.
//

#import "BusinessDealsViewController.h"
#import "BusinessDealsTableViewCell.h"
#import "RedeemDealViewController.h"
#import "MillieAPIClient.h"
#import "Utility.h"
#import "User.h"
#import "UIColor+HEX.h"
#import <SDWebImage/UIImageView+WebCache.h>


@interface BusinessDealsViewController ()<UITableViewDataSource, UITableViewDelegate>

@property User *currentUser;
@property UIRefreshControl *mannyFresh;
@property NSArray *arrayMyBusinessDeals;
@property NSMutableArray *arrayMyActivations;
@property NSMutableArray *arrayDealImages;

@property NSDictionary *dealSelected;

@property (strong, nonatomic) IBOutlet UITableView *tableViewBusinessDeals;

@property RedeemDealViewController *rDVC;

@property UIView *loadingView;

@property BOOL refresh;
@property int count;

@end

@implementation BusinessDealsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentUser = [User sharedSingleton];
    self.arrayMyActivations = [NSMutableArray new];
    self.arrayDealImages = [NSMutableArray new];

    //Refresh Control Setup
    self.mannyFresh = [[UIRefreshControl alloc] init];
    self.mannyFresh.tintColor = [UIColor colorwithHexString:@"#72c74a" alpha:.9];
    [self.mannyFresh addTarget:self action:@selector(refershControlAction) forControlEvents:UIControlEventValueChanged];
    [self.tableViewBusinessDeals addSubview:self.mannyFresh];

    [self.navigationController.navigationBar setHidden:YES];

    self.refresh = NO;

    self.loadingView = [[[NSBundle mainBundle] loadNibNamed:@"LoadingView"
                                                      owner:self
                                                    options:nil] objectAtIndex:0];

    CGRect loadingFrame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    self.loadingView.frame = loadingFrame;
    [self.view addSubview:self.loadingView];
    self.loadingView.alpha = 1;

    [self loadArrayBusinessDealsAndActivation];


}

#pragma mark - UITableView Delegate Methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return self.arrayMyBusinessDeals.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    BusinessDealsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellDealsBusiness"];

    cell.labelDealTitle.text = [[[self.arrayMyBusinessDeals objectAtIndex:indexPath.row]objectForKey:@"Deal" ] objectForKey:@"title"];
    cell.labelDealDescription.text = [[[self.arrayMyBusinessDeals objectAtIndex:indexPath.row]objectForKey:@"Deal" ] objectForKey:@"description"];

    // ACTIVATION COUNT / NUMBER OF DEALS COUNT

    NSString *dealID = [[[self.arrayMyBusinessDeals objectAtIndex:indexPath.row]objectForKey:@"Deal" ] objectForKey:@"id"];

    int activationCount = 0;
    int claimedCount = 0;

    for (NSDictionary *activation in self.arrayMyActivations)
    {

        NSArray *activations = [activation objectForKey:@"activations"];
        for (NSDictionary *act in activations) {



            if ([[act objectForKey:@"deal_id"] isEqual:dealID] && [act objectForKey:@"redeemed"] !=(id)[NSNull null])
            {
                activationCount++;
            }
            if ([[act objectForKey:@"deal_id"] isEqual:dealID] && [act objectForKey:@"sent"] !=(id)[NSNull null])
            {
                claimedCount++;
            }
        }
    }

    NSString *dealQuantity = [[[[self.arrayMyBusinessDeals objectAtIndex:indexPath.row] objectForKey:@"Deal" ] objectForKey:@"quantity"]stringValue];

    NSString *activatedDealCount = [NSString stringWithFormat:@"%i CLAIMED & %i REDEEMED OUT OF %@",claimedCount,activationCount,dealQuantity];

    cell.labelDealCount.text = activatedDealCount;

    cell.imageViewDealBusiness.image = [self.arrayDealImages objectAtIndex:indexPath.row];

    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.dealSelected = [self.arrayMyBusinessDeals objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"showRedeemDeal" sender:self];
}


#pragma mark - Helper Methods

-(void)refershControlAction
{
    self.refresh = YES;
    [self loadArrayBusinessDealsAndActivation];
}


-(void)loadArrayBusinessDealsAndActivation
{
    NSString *token = [Lockbox stringForKey:@"token"];
    [MillieAPIClient getMyBusinessDeals:token completion:^(NSDictionary *result)
    {
        NSLog(@"My Business Deals:%@",result);
        self.arrayMyBusinessDeals = [result objectForKey:@"deals"];

        self.count = 0;

        for (NSDictionary *deal in self.arrayMyBusinessDeals)
        {
            NSString *businessID = [[deal  objectForKey:@"Deal" ] objectForKey:@"business_id"];
            NSString *dealID = [[deal objectForKey:@"Deal" ] objectForKey:@"id"];


            NSString *imageURL = [[[deal objectForKey:@"images"]objectAtIndex:0] objectForKey:@"image_url"];


                NSURL *urlImage = [NSURL URLWithString:imageURL];

                SDWebImageManager *manager = [SDWebImageManager sharedManager];
                [manager downloadImageWithURL:urlImage
                                      options:0
                                     progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                         // progression tracking code
                                     }
                                    completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                        if (image) {

                                              [self.arrayDealImages addObject:image];


                                        [MillieAPIClient getActivationsForDeal:token businessID:businessID dealID:dealID completion:^(NSDictionary *result) {
                    
                                            [self.arrayMyActivations addObject:result];
                                            self.count = self.count +1;

                                            if (self.count  == self.arrayMyBusinessDeals.count)
                                            {
                                                [self.tableViewBusinessDeals reloadData];

                                                if (self.refresh == NO) {
                                                    [Utility animateViewFadeOut:self.loadingView completion:^(BOOL result) {
                                                        NSLog(@"FAde");
                                                    }];
                                                }
                                                
                                                else
                                                {
                                                    
                                                    [self.mannyFresh endRefreshing];
                                                }
                                                
                                            }

                                            
                                        }];





                                }
                                    }];


                }

            }];
}


#pragma mark - Segue Methods

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqual:@"showRedeemDeal"]) {

        self.rDVC = [segue destinationViewController];

        self.rDVC.deal = self.dealSelected;

    }
}

@end
