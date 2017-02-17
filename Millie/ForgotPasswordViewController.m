//
//  ForgotPasswordViewController.m
//  Millie
//
//  Created by Emmanuel Masangcay on 6/2/15.
//  Copyright (c) 2015 CoderEXP. All rights reserved.
//

#import "ForgotPasswordViewController.h"
#import "UIColor+HEX.h"
#import "MillieAPIClient.h"


@interface ForgotPasswordViewController () <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *textFieldEmail;
@property (strong, nonatomic) IBOutlet UIButton *buttonSendLink;

@property UIAlertView *alertViewSendPassword;

@end

@implementation ForgotPasswordViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.navigationController.navigationBar setHidden:YES];

    self.alertViewSendPassword.delegate = self;
    self.textFieldEmail.delegate = self;


    NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"EMAIL" attributes:@{ NSForegroundColorAttributeName : [UIColor colorwithHexString:@"334d5c" alpha:1],NSKernAttributeName : @(1.5f)}];

    self.textFieldEmail.attributedPlaceholder = str;

    [self.buttonSendLink setEnabled:NO];
}

#pragma mark - UITextField delegate methods

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.text.length == 0) {
        [self.buttonSendLink setEnabled:NO];
    } else {
        [self.buttonSendLink setEnabled:YES];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.text.length == 0) {
        [self.buttonSendLink setEnabled:NO];
    } else {
        [self.buttonSendLink setEnabled:YES];
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

#pragma mark - IBActions

- (IBAction)onForgotPasswordButtonPressed:(id)sender
{
    [MillieAPIClient forgetPassword:self.textFieldEmail.text completion:^(NSDictionary *result) {
        NSLog(@"Email Sent:%@",result);
        if (result != nil) {
            [self performSegueWithIdentifier:@"submitPassword" sender:self];
        }
        else
        {
            UIAlertController *alertController = [UIAlertController
                                                  alertControllerWithTitle:@"ERROR"
                                                  message:@"Could Not Find Your Email!"
                                                  preferredStyle:UIAlertControllerStyleAlert];


            UIAlertAction *okAction = [UIAlertAction
                                       actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction *action)
                                       {
                                           NSLog(@"OK action");
                                       }];

            [alertController addAction:okAction];

            [self presentViewController:alertController animated:YES completion:nil];
        }

    }];
}
- (IBAction)buttonCancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
    }];

}

#pragma mark - UIAlertView delegate methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView isEqual:self.alertViewSendPassword]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}





@end
