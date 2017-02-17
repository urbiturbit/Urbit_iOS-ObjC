//
//  ConfirmDealViewController.m
//  Millie
//
//  Created by Emmanuel Masangcay on 7/7/15.
//  Copyright (c) 2015 CoderEXP. All rights reserved.
//

#import "ConfirmDealViewController.h"
#import "B_CustomTabBarController.h"
#import "User.h"
#import "MillieAPIClient.h"

@interface ConfirmDealViewController ()
@property (strong, nonatomic) IBOutlet UILabel *labelDealDescription;
@property (strong, nonatomic) IBOutlet UILabel *labelBusinessName;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewBusinessLogo;
@property (strong, nonatomic) IBOutlet UILabel *labelDealDateStart;
@property (strong, nonatomic) IBOutlet UILabel *labelDealDateFinish;
@property (strong, nonatomic) IBOutlet UILabel *labelConfirm;


@property User *currentUser;

@property UIImageView *imageViewBusinessLogo2;

@property CGFloat imageViewHeight;
@property CGFloat imageViewWidth;

@end

@implementation ConfirmDealViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentUser = [User sharedSingleton];

    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;

    if (screenWidth == 375) //iphone6
    {
        self.imageViewHeight = 140;
        self.imageViewWidth = 140;

    }
    if (screenWidth == 320) //iphone5
    {
        self.imageViewHeight = 120;
        self.imageViewWidth = 120;
    }
    if (screenWidth == 414) //iphone6+
    {
        self.imageViewHeight = 180;
        self.imageViewWidth = 180;
    }


    NSString *dealBusiness = [self.dealBusiness objectForKey:@"name"];
    UIImage *imageBusiness = self.imageBusiness;

    self.imageViewBusinessLogo2 = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width / 2 -  self.imageViewWidth / 2 , self.labelBusinessName.frame.origin.y + self.labelBusinessName.frame.size.height+ 20, self.imageViewWidth , self.imageViewHeight)];



    self.imageViewBusinessLogo2.image = imageBusiness;

    self.imageViewBusinessLogo2.layer.cornerRadius = self.imageViewBusinessLogo2.frame.size.height /2;
    self.imageViewBusinessLogo2.layer.masksToBounds = YES;

     [self.view addSubview:self.imageViewBusinessLogo2];

    if (!self.dealSelected) {
        NSString *dealDescription = [self.dealInfo objectForKey:@"description"];
        NSString *dealDateStart = [self.dealInfo objectForKey:@"start_time"];
        NSString *dealDateFinish = [self.dealInfo objectForKey:@"expiration_time"];

        NSDateFormatter *dateStart=[[NSDateFormatter alloc]init];
        [dateStart setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZZZZ"];

        NSDateFormatter *dateFinish=[[NSDateFormatter alloc]init];
        [dateFinish setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZZZZ"];

        NSDate *startDate = [dateStart dateFromString:dealDateStart];
        [dateStart setDateFormat:@"cccc, MMM d, hh:mm aa"];

        NSDate *finishDate = [dateFinish dateFromString:dealDateFinish];
        [dateFinish setDateFormat:@"cccc, MMM d, hh:mm aa"];


        NSString *startDateString =  [dateStart stringFromDate:startDate];
        NSString *finishDateString = [dateFinish stringFromDate:finishDate];

        self.labelDealDescription.text = dealDescription;
        self.labelBusinessName.text = dealBusiness;
        self.imageViewBusinessLogo.image = imageBusiness;
        self.labelDealDateStart.text = startDateString;
        self.labelDealDateFinish.text = finishDateString;
    }

    else
    {
        NSString *dealDescription = self.dealSelected.dealDescription;
        NSString *dealDateStart = self.dealSelected.startTime;
        NSString *dealDateFinish = self.dealSelected.expirationTime;
        self.labelDealDescription.text = dealDescription;
        self.labelBusinessName.text = dealBusiness;
        self.imageViewBusinessLogo.image = imageBusiness;
        self.labelDealDateStart.text = dealDateStart;
        self.labelDealDateFinish.text = dealDateFinish;
    }

    [self.labelConfirm setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tapConfirm = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapConfirm:)];

    [self.labelConfirm addGestureRecognizer:tapConfirm];

}

#pragma mark - Button Press Methods

- (IBAction)onButtonPressCancelConfirmDeal:(id)sender {

    [self dismissViewControllerAnimated:YES completion:^{}];
}


-(void)tapConfirm:(UITapGestureRecognizer*)gesture
{
    NSLog(@"Tap Confirm");

    NSString *token = [Lockbox stringForKey:@"token"];
    NSString *businessID = [self.dealBusiness objectForKey:@"id"];

    NSString *dealID;
    if (!self.dealSelected) {
        dealID = [self.dealInfo objectForKey:@"id"];
    }
    else
    {
        dealID = self.dealSelected.dealID;
    }

    [MillieAPIClient claimDeal:token businessID:businessID dealID:dealID completion:^(NSDictionary *result) {
        NSLog(@"Result:%@",result);
        if (result) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"YourDismissAllViewControllersIdentifier" object:self];
        }
    }];



}

@end
