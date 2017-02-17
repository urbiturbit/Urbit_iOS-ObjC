//
//  RedeemDealViewController.m
//  Millie
//
//  Created by Emmanuel Masangcay on 7/9/15.
//  Copyright (c) 2015 CoderEXP. All rights reserved.
//

#import "RedeemDealViewController.h"
#import "MillieAPIClient.h"

@interface RedeemDealViewController ()
@property (strong, nonatomic) IBOutlet UITextField *textFieldVerificationCode;

@end

@implementation RedeemDealViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (IBAction)onButtonPressRedeem:(id)sender {

    NSString *token = [Lockbox stringForKey:@"token"];
    NSString *businessID = [self.deal objectForKey:@"business_id"];
    NSString *dealID = [self.deal objectForKey:@"id"];

    [MillieAPIClient checkActivationsForDeal:token businessID:businessID dealID:dealID activationCode:self.textFieldVerificationCode.text completion:^(NSDictionary *result) {
        NSLog(@"Result:%@",result);
    }];
}

- (IBAction)onButtonPressCancelRedeem:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{}];
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

@end
