//
//  DealAnalyticsViewController.m
//  Millie
//
//  Created by Emmanuel Masangcay on 7/17/15.
//  Copyright (c) 2015 CoderEXP. All rights reserved.
//

#import "DealAnalyticsViewController.h"
#import "MillieAPIClient.h"
#import "Utility.h"

@interface DealAnalyticsViewController ()
@property (strong, nonatomic) IBOutlet UILabel *labelTotalDeals;
@property (strong, nonatomic) IBOutlet UILabel *labelTotalClaimedDeals;
@property (strong, nonatomic) IBOutlet UILabel *labelTotalRedeemedDeals;
@property (strong, nonatomic) IBOutlet UILabel *labelTotalActivations;

@property NSMutableArray *arrayMyBusinessDeals;
@property NSMutableArray *arrayMyActivations;

@property UIView *loadingView;

@property int redeemCount;
@property int claimedCount;
@property int activationsCount;


@end

@implementation DealAnalyticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setHidden:YES];

    self.loadingView = [[[NSBundle mainBundle] loadNibNamed:@"LoadingView"
                                                      owner:self
                                                    options:nil] objectAtIndex:0];

    CGRect loadingFrame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    self.loadingView.frame = loadingFrame;
    [self.view addSubview:self.loadingView];
    self.loadingView.alpha = 1;

    self.arrayMyBusinessDeals = [NSMutableArray new];
    self.arrayMyActivations = [NSMutableArray new];
    self.claimedCount = 0;
    self.redeemCount = 0;
    self.activationsCount = 0;


    NSString *token = [Lockbox stringForKey:@"token"];
    [MillieAPIClient getMyBusinessDeals:token completion:^(NSDictionary *result)
     {
         NSLog(@"My Business Deals:%@",result);
         self.arrayMyBusinessDeals = [result objectForKey:@"deals"];

         for (NSDictionary *deal in self.arrayMyBusinessDeals) {
             NSString *businessID = [[deal objectForKey:@"Deal" ] objectForKey:@"business_id"];
             NSString *dealID = [[deal objectForKey:@"Deal" ] objectForKey:@"id"];
             [MillieAPIClient getActivationsForDeal:token businessID:businessID dealID:dealID completion:^(NSDictionary *result) {

                 NSDictionary *active = result;
                 NSArray *arrayActivations = [active objectForKey:@"activations"];

                 if ([deal isEqual:self.arrayMyBusinessDeals.lastObject])
                 {
                     for (NSDictionary *active in arrayActivations) {
                         if ([active objectForKey:@"redeemed"] !=(id)[NSNull null])
                         {
                             self.redeemCount = self.redeemCount + 1;
                         }
                         else if ([active objectForKey:@"sent"] !=(id)[NSNull null])
                         {
                             self.claimedCount = self.claimedCount +1;
                         }

                         self.activationsCount = self.activationsCount + 1;
                     }

                     self.labelTotalDeals.text = [NSString stringWithFormat:@"%li",self.arrayMyBusinessDeals.count];


                     self.labelTotalClaimedDeals.text = [NSString stringWithFormat:@"%i",self.claimedCount];
                     self.labelTotalActivations.text =  [NSString stringWithFormat:@"%i",self.activationsCount];
                     self.labelTotalRedeemedDeals.text =  [NSString stringWithFormat:@"%i",self.redeemCount];


                     [Utility animateViewFadeOut:self.loadingView completion:^(BOOL result) {
                         NSLog(@"FAde");
                         [self.loadingView removeFromSuperview];
                     }];
                 }
                 
             }];
         }
         
     }];

}


@end
