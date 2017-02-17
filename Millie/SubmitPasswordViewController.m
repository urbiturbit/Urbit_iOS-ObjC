//
//  SubmitPasswordViewController.m
//  Millie
//
//  Created by Emmanuel Masangcay on 7/20/15.
//  Copyright (c) 2015 CoderEXP. All rights reserved.
//

#import "SubmitPasswordViewController.h"
#import "MillieAPIClient.h"
#import "UIColor+HEX.h"

@interface SubmitPasswordViewController ()<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *textFieldPassword;
@property (strong, nonatomic) IBOutlet UITextField *textFieldPasswordConfirm;
@property (strong, nonatomic) IBOutlet UITextField *textFieldPasswordReset;
@property (strong, nonatomic) IBOutlet UIButton *buttonSubmit;

@end

@implementation SubmitPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.textFieldPassword.delegate = self;
    self.textFieldPasswordConfirm.delegate = self;
    self.textFieldPasswordReset.delegate = self;


    NSAttributedString *strPassword = [[NSAttributedString alloc] initWithString:@"PASSWORD" attributes:@{ NSForegroundColorAttributeName : [UIColor colorwithHexString:@"334d5c" alpha:1],NSKernAttributeName : @(1.5f)}];

    self.textFieldPassword.attributedPlaceholder = strPassword;

    NSAttributedString *strPasswordConfirm = [[NSAttributedString alloc] initWithString:@"PASSWORD CONFIRM" attributes:@{ NSForegroundColorAttributeName : [UIColor colorwithHexString:@"334d5c" alpha:1],NSKernAttributeName : @(1.5f)}];

    self.textFieldPasswordConfirm.attributedPlaceholder = strPasswordConfirm;

    NSAttributedString *strPasswordReset = [[NSAttributedString alloc] initWithString:@"RESET CODE" attributes:@{ NSForegroundColorAttributeName : [UIColor colorwithHexString:@"334d5c" alpha:1],NSKernAttributeName : @(1.5f)}];

    self.textFieldPasswordReset.attributedPlaceholder = strPasswordReset;


}


#pragma mark - UITextField delegate methods

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.text.length == 0) {
        [self.buttonSubmit setEnabled:NO];
    } else {
        [self.buttonSubmit setEnabled:YES];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.text.length == 0) {
        [self.buttonSubmit setEnabled:NO];
    } else {
        [self.buttonSubmit setEnabled:YES];
    }

    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];

    return YES;
}

// Clicking off any controls will close the keypad
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


#pragma mark Button Press Methods

- (IBAction)onButtonPressReset:(id)sender
{
   [MillieAPIClient submitPassword:self.textFieldPasswordReset.text password:self.textFieldPassword.text confirmPassword:self.textFieldPasswordConfirm.text completion:^(NSDictionary *result) {
       NSLog( @"Password Reset:%@",result);
       if (result !=nil) {
           [[NSNotificationCenter defaultCenter] postNotificationName:@"YourDismissAllViewControllersLogin" object:self];
       }
   }];
}


@end
