//
//  LoyaltyCreateDealViewController.m
//  Millie
//
//  Created by Emmanuel Masangcay on 6/24/15.
//  Copyright (c) 2015 CoderEXP. All rights reserved.
//

#import "LoyaltyCreateDealViewController.h"
#import "LoyaltyLevel.h"

@interface LoyaltyCreateDealViewController ()

@property (strong, nonatomic) IBOutlet LoyaltyLevel *buttonLoyaltyAll;
@property (strong, nonatomic) IBOutlet LoyaltyLevel *buttonLoyaltyLoca;
@property (strong, nonatomic) IBOutlet LoyaltyLevel *buttonLoyaltyBronze;
@property (strong, nonatomic) IBOutlet LoyaltyLevel *buttonLoyaltySilver;
@property (strong, nonatomic) IBOutlet LoyaltyLevel *buttonLoyaltyGold;
@end

@implementation LoyaltyCreateDealViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)buttonPressAll:(id)sender
{
    self.loyaltyLevel = @"All";
    [self buttonAnimation:self.buttonLoyaltyAll];
    [self buttonDeAnimate:self.buttonLoyaltyLoca];
    [self buttonDeAnimate:self.buttonLoyaltyBronze];
    [self buttonDeAnimate:self.buttonLoyaltySilver];
    [self buttonDeAnimate:self.buttonLoyaltyGold];

}

- (IBAction)buttonPressLocal:(id)sender
{
    self.loyaltyLevel = @"Local";
    [self buttonAnimation:self.buttonLoyaltyLoca];
    [self buttonDeAnimate:self.buttonLoyaltyAll];
    [self buttonDeAnimate:self.buttonLoyaltyBronze];
    [self buttonDeAnimate:self.buttonLoyaltySilver];
    [self buttonDeAnimate:self.buttonLoyaltyGold];
}

- (IBAction)buttonPressBronze:(id)sender
{
    self.loyaltyLevel = @"Bronze";
    [self buttonAnimation:self.buttonLoyaltyBronze];
    [self buttonDeAnimate:self.buttonLoyaltyLoca];
    [self buttonDeAnimate:self.buttonLoyaltyAll];
    [self buttonDeAnimate:self.buttonLoyaltySilver];
    [self buttonDeAnimate:self.buttonLoyaltyGold];
}

- (IBAction)buttonPressSilver:(id)sender
{
    self.loyaltyLevel = @"Silver";
    [self buttonAnimation:self.buttonLoyaltySilver];
    [self buttonDeAnimate:self.buttonLoyaltyLoca];
    [self buttonDeAnimate:self.buttonLoyaltyBronze];
    [self buttonDeAnimate:self.buttonLoyaltyAll];
    [self buttonDeAnimate:self.buttonLoyaltyGold];
}

- (IBAction)buttonPressGold:(id)sender
{
    self.loyaltyLevel = @"Gold";
    [self buttonAnimation:self.buttonLoyaltyGold];
    [self buttonDeAnimate:self.buttonLoyaltyLoca];
    [self buttonDeAnimate:self.buttonLoyaltyBronze];
    [self buttonDeAnimate:self.buttonLoyaltySilver];
    [self buttonDeAnimate:self.buttonLoyaltyAll];
}

#pragma mark - Animation Methods

-(void)buttonAnimation:(UIButton*)button
{
    [UIView animateWithDuration:0.13
                          delay:0 options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         CGAffineTransform transform =
                         CGAffineTransformScale(CGAffineTransformIdentity, 1.8, 1.8);
                         button.transform = transform;
                     }
                     completion:^(BOOL finished)
     {

         if (button.backgroundColor == [UIColor whiteColor]) {
             button.backgroundColor = nil;
             CGAffineTransform transform =
             CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
             button.transform = transform;
         }
         else
         {
             button.backgroundColor = [UIColor whiteColor];
             CGAffineTransform transform =
             CGAffineTransformScale(CGAffineTransformIdentity, 1.5, 1.5);
             button.transform = transform;
         }
         
     }];
}

-(void)buttonDeAnimate:(UIButton*)button
{
    [UIView animateWithDuration:0.13
                          delay:0 options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         
                     }
                     completion:^(BOOL finished)
     {

             button.backgroundColor = nil;
             CGAffineTransform transform =
             CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
             button.transform = transform;



     }];


}

@end
