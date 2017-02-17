//
//  SearchDealsViewController.m
//  Millie
//
//  Created by Emmanuel Masangcay on 7/20/15.
//  Copyright (c) 2015 CoderEXP. All rights reserved.
//

#import "SearchDealsViewController.h"
#import "UIColor+HEX.h"
#import "MillieAPIClient.h"
#import "MillieButton.h"
#import "DealsViewController.h"
#import "Deal.h"
#import "SearchDealResultsViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface SearchDealsViewController ()<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *textFieldSearch;

@property UIButton *btnSearch;
@property NSArray *arrayOfSearchDeals;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *mannyFresh;

@property SearchDealResultsViewController *sDRVC;
@property UIButton *buttonCancelDetailDealView;
@property NSMutableArray *arrayOfDeals;



@end

@implementation SearchDealsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textFieldSearch.delegate = self;

    [self buildUI];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    self.textFieldSearch.text = @"";
}

-(void)buildUI
{
    [self.navigationController.navigationBar setHidden:YES];

    NSAttributedString *strSearch= [[NSAttributedString alloc] initWithString:@"SEARCH" attributes:@{ NSForegroundColorAttributeName : [UIColor colorwithHexString:@"D4ECDC" alpha:1],NSKernAttributeName : @(1.5f) }];
    self.textFieldSearch.attributedPlaceholder = strSearch;

    // ******** SignUp Button ******** //
    self.btnSearch = [MillieButton buttonWithType:UIButtonTypeRoundedRect];
    [self.btnSearch setTitle:@"NEXT" forState:UIControlStateNormal];
    [self.btnSearch.titleLabel setFont:[UIFont fontWithName:@"ProximaNova-Regular" size:21]];

    [self.btnSearch setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnSearch setBackgroundColor:[UIColor colorwithHexString:@"45b29d" alpha:1]];
    //set the frame
    CGRect btnNextFrame = CGRectMake(0, 0, 50, 60);

    self.btnSearch.frame = btnNextFrame;

    [self.btnSearch addTarget:self
                             action:@selector(clickSearch)
                   forControlEvents:UIControlEventTouchUpInside];

   



}

#pragma mark - UITextField Delegate Methods

// The return button will close the keypad
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];

    return YES;
}

// Clicking off any controls will close the keypad
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {

    textField.inputAccessoryView = self.btnSearch;

    return YES;
}



#pragma mark Gesture Methods

-(void)clickSearch
{
    NSLog(@"SEARCH");
    [self.mannyFresh startAnimating];
    //Searches Description and Title
    NSString *token = [Lockbox stringForKey:@"token"];
    [MillieAPIClient searchDeals:token search:self.textFieldSearch.text completion:^(NSDictionary *result)
    {
        NSLog(@"Search Result:%@",result);

        if ([[result objectForKey:@"deals"]count]== 0)
        {

            //ADD ERROR


            [self.mannyFresh stopAnimating];

        }
        else
        {
            [self.textFieldSearch resignFirstResponder];
            self.arrayOfDeals = [NSMutableArray new];
            NSArray *deals = [result objectForKey:@"deals"];

            for (int i = 0; i< deals.count; i++)
            {

                Deal *deal = [Deal new];

                deal.dealTitle = [[[deals objectAtIndex:i] objectForKey:@"Deal"] objectForKey:@"title"];
                deal.dealDescription = [[[deals objectAtIndex:i] objectForKey:@"Deal"]objectForKey:@"description"];
                NSString *startTime = [[[deals objectAtIndex:i] objectForKey:@"Deal"]objectForKey:@"start_time"];
                NSString *expirationTime = [[[deals objectAtIndex:i] objectForKey:@"Deal"]objectForKey:@"expiration_time"];

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

                deal.termsAndCondition = [[[deals objectAtIndex:i] objectForKey:@"Deal"]objectForKey:@"terms_and_conditions"];
                deal.zipCode = [[[deals objectAtIndex:i] objectForKey:@"Deal"]objectForKey:@"zipcode"];
                deal.businessID = [[[deals objectAtIndex:i] objectForKey:@"Deal"]objectForKey:@"business_id"];
                deal.dealID = [[[deals objectAtIndex:i] objectForKey:@"Deal"]objectForKey:@"id"];

                NSString *imageURL = [[[[deals objectAtIndex:0]objectForKey:@"images"]objectAtIndex:0]objectForKey:@"image_url"];
                 NSURL *urlImage = [NSURL URLWithString:imageURL];

                SDWebImageManager *manager = [SDWebImageManager sharedManager];
                [manager downloadImageWithURL:urlImage
                                      options:0
                                     progress:^(NSInteger receivedSize, NSInteger expectedSize)
                {}
                                    completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL)
                {
                                        if (image) {

                                            deal.dealImage = image;
                                            [self.arrayOfDeals addObject:deal];

                                            if (self.arrayOfDeals.count == deals.count) {

                                                [self.mannyFresh stopAnimating];
                                                [self performSegueWithIdentifier:@"searchDealsResult" sender:self];
                                                
                                            }

                                        }
                                    }];
            }
        }
    }];

}

#pragma mark - Segue Methods

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqual:@"searchDealsResult"]) {

        self.sDRVC = [segue destinationViewController];
        self.sDRVC.arrayOfSearchDeals = self.arrayOfDeals;

    }
}
@end
