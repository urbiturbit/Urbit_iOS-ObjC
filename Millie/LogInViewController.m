
//  LogInViewController.m
//  Millie
//
//  Created by Emmanuel Masangcay on 6/2/15.
//  Copyright (c) 2015 CoderEXP. All rights reserved.
//

#import "LogInViewController.h"
#import "SignUpViewController.h"
#import "MillieAPIClient.h"
#import "User.h"
#import "MillieLabel.h"
#import "UIColor+HEX.h"
#import "MillieButton.h"
#import <AFNetworking/AFNetworking.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

#define VALIDURL (@"http://www.google.com")

@interface LogInViewController ()<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *textFieldUsername;
@property (strong, nonatomic) IBOutlet UITextField *textFieldPassword;
@property (strong, nonatomic) IBOutlet UIView *viewMainContainer;
@property (strong, nonatomic) IBOutlet UIButton *buttonForgotPassword;

@property  UIView *viewAlertMessage;
@property NSArray *permissions;

@property User *currentUser;

@property MillieButton *buttonLogin;

@end

@implementation LogInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //Hide Nav Bar
    [self.navigationController.navigationBar setHidden:YES];
    //FB AccessToken - User already logged in
    if ([FBSDKAccessToken currentAccessToken]) {
        [self performSegueWithIdentifier:@"pushToMain" sender:self];
    }

    NSAttributedString *strUsername = [[NSAttributedString alloc] initWithString:@"USER NAME" attributes:@{ NSForegroundColorAttributeName : [UIColor colorwithHexString:@"334d5c" alpha:1],
        NSKernAttributeName : @(1.5f)}];
    self.textFieldUsername.attributedPlaceholder = strUsername;

    NSAttributedString *strPassword = [[NSAttributedString alloc] initWithString:@"PASSWORD" attributes:@{ NSForegroundColorAttributeName : [UIColor colorwithHexString:@"334d5c" alpha:1],
        NSKernAttributeName : @(1.5f) }];
    self.textFieldPassword.attributedPlaceholder = strPassword;

    self.currentUser = [User sharedSingleton];

    // ******** SignUp Button ******** //
    self.buttonLogin = [MillieButton buttonWithType:UIButtonTypeRoundedRect];
    [self.buttonLogin setTitle:@"LOG IN" forState:UIControlStateNormal];
    [self.buttonLogin.titleLabel setFont:[UIFont fontWithName:@"ProximaNova-Regular" size:22]];
    [self.buttonLogin setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.buttonLogin setBackgroundColor:[UIColor colorwithHexString:@"45b29d" alpha:1]];
    //set the frame
    CGRect btnSignupFrame = CGRectMake(0, 0, 50, 50);

    self.buttonLogin.frame = btnSignupFrame;

    [self.buttonLogin addTarget:self
                       action:@selector(clickLogin)
             forControlEvents:UIControlEventTouchUpInside];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissAllViewControllers:) name:@"YourDismissAllViewControllersLogin" object:nil];
    [self.textFieldUsername becomeFirstResponder];

}

#pragma mark - Button Press Methods

// Facebook Login
- (IBAction)LoginWithFacebook:(id)sender
{
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc]init];
    [login logInWithReadPermissions:@[@"email"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error)
    {
        if (error)
        {
            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"Facebook Login Error" message:@"Failed to Login through Facebook" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
        }
        else if (result.isCancelled)
        {
            NSLog(@"User Cancelled Login");
        }
        else
        {
            NSLog(@"FB Login Successful");
            [self performSegueWithIdentifier:@"pushToMain" sender:self];
        }
    }];
}

-(void)login
{
    NSURL *url = [NSURL URLWithString:VALIDURL];

    if (![self isValidURL:url]) {
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"Connection Error" message:@"Your network connection is weak, wait until you have a better internet connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];

        self.textFieldUsername.text = @"";
        self.textFieldPassword.text = @"";
    }
    else if ([self.textFieldUsername.text isEqualToString:@""] || self.textFieldUsername.text == nil || [self.textFieldPassword.text isEqualToString:@""] || self.textFieldPassword.text == nil)
    {

    }
    else
    {
        NSString *email = self.textFieldUsername.text;
        NSString *password = self.textFieldPassword.text;

        [MillieAPIClient logInUser:email password:password completion:^(NSDictionary* result)
        {
            if (result)
            {
             self.currentUser.email = email;
             self.currentUser.userID = [result objectForKey:@"id"];
             NSString *token = [Lockbox stringForKey:@"token"];

                [MillieAPIClient getUserInfo:token completion:^(NSDictionary *result) {
                    self.currentUser.email = [[result objectForKey:@"User"]objectForKey:@"email"];
                    self.currentUser.userID = [[result objectForKey:@"User"]objectForKey:@"id"];
                    self.currentUser.userName = [[result objectForKey:@"User"]objectForKey:@"username"];

                [MillieAPIClient getProfileImage:token completion:^(NSDictionary *result) {
                    NSLog(@"Profile Pic: %@",result);
                    NSString *stringURL = [result objectForKey:@"image_url"];
                    NSURL *urlImage = [NSURL URLWithString:stringURL];
                    NSData *dataImage = [NSData dataWithContentsOfURL:urlImage];
                    UIImage *image = [UIImage imageWithData:dataImage];
                    self.currentUser.userProfilePic = image;

                         [MillieAPIClient getBusinessImage:token completion:^(NSDictionary *result) {

                             NSLog(@"Result%@",result);

                             NSString *stringImageMain = [[[result objectForKey:@"images"]objectAtIndex:0]objectForKey:@"image_url"];
                             NSURL *urlImageMain = [NSURL URLWithString:stringImageMain];
                             NSData *dataImageMain = [NSData dataWithContentsOfURL:urlImageMain];
                             UIImage *imageDataMain = [UIImage imageWithData:dataImageMain];
                             self.currentUser.businessProfilePic = imageDataMain;

                              [self performSegueWithIdentifier:@"pushToMain" sender:self];
                         }];

                }];
                     }];
            }
            else
            {
                [self presentAlertMessage:@"YOUR USER NAME AND PASSWORD DID NOT MATCH. PLEASE TRY AGAIN"];
            }
        }];
    }
}
- (IBAction)onButtonPressCancel:(id)sender {

    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

-(void)clickLogin
{
    if (![self.textFieldUsername.text  isEqual: @""] && ![self.textFieldPassword.text  isEqual: @""]) {
        [self login];
        }
    else
    {
        [self presentAlertMessage:@"PLEASE MAKE SURE ALL FIELDS ARE ENTERED"];
    }
    

}

#pragma mark - Helper Methods

- (BOOL)isValidURL:(NSURL *)url
{
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    NSHTTPURLResponse *res = nil;
    NSError *err = nil;
    [NSURLConnection sendSynchronousRequest:req returningResponse:&res error:&err];
    if (err || res.statusCode == 404) {
        return false;
    }
    else
    {
        return true;
    }
}

// Clicking off any controls will close the keypad
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    [self closeAlertMessage];
}

#pragma mark - Animation Methods

-(void)presentAlertMessage:(NSString*)alertMessage
{
    self.viewAlertMessage = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    self.viewAlertMessage.backgroundColor = [UIColor redColor];
    MillieLabel *labelAlertMessage = [[MillieLabel alloc]initWithFrame:CGRectMake(0, 0, self.viewAlertMessage.frame.size.width, self.viewAlertMessage.frame.size.height)];
    labelAlertMessage.textAlignment= NSTextAlignmentCenter;
    labelAlertMessage.textColor = [UIColor whiteColor];
    [labelAlertMessage setFont:[UIFont fontWithName:@"ProximaNova-regular" size:13]];
    labelAlertMessage.lineBreakMode = NSLineBreakByWordWrapping;
    labelAlertMessage.numberOfLines = 0;
    labelAlertMessage.text = alertMessage;

    [self.viewAlertMessage addSubview:labelAlertMessage];

    [self.view addSubview:self.viewAlertMessage];

    self.viewAlertMessage.alpha = 0;

    // Present ActivityView with animation left to right
    [UIView animateWithDuration:0.3 animations:^{
    } completion:^(BOOL finished) {
        self.viewAlertMessage.alpha = 1;
        self.viewAlertMessage.transform = CGAffineTransformMakeTranslation(0, -600);
        [UIView animateKeyframesWithDuration:0.8/4 delay:0 options:0 animations:^{
            self.viewAlertMessage.transform = CGAffineTransformMakeTranslation(0, -340);

        } completion:^(BOOL finished) {
            [UIView animateKeyframesWithDuration:0.8/4 delay:0 options:0 animations:^{
                self.viewAlertMessage.transform = CGAffineTransformMakeTranslation(0, -200);

            } completion:^(BOOL finished) {
                [UIView animateKeyframesWithDuration:0.8/4 delay:0 options:0 animations:^{
                    self.viewAlertMessage.transform = CGAffineTransformMakeTranslation(0, -90);
                } completion:^(BOOL finished) {
                    [UIView animateKeyframesWithDuration:0.8/4 delay:0 options:0 animations:^{
                        self.viewAlertMessage.transform = CGAffineTransformMakeTranslation(0, 0);
                        self.viewMainContainer.transform = CGAffineTransformMakeTranslation(0, 50);
                    } completion:^(BOOL finished) {
                    }];
                }];
            }];
        }];

    }];
}

-(void)closeAlertMessage
{
    // Present ActivityView with animation left to right
    [UIView animateWithDuration:0.3 animations:^{
    } completion:^(BOOL finished) {
        self.viewAlertMessage.transform = CGAffineTransformMakeTranslation(0, 0);
        [UIView animateKeyframesWithDuration:0.8/4 delay:0 options:0 animations:^{
             self.viewMainContainer.transform = CGAffineTransformMakeTranslation(0, 0);
            self.viewAlertMessage.transform = CGAffineTransformMakeTranslation(0, -90);
        } completion:^(BOOL finished) {
            [UIView animateKeyframesWithDuration:0.8/4 delay:0 options:0 animations:^{
                self.viewAlertMessage.transform = CGAffineTransformMakeTranslation(0, -200);
            } completion:^(BOOL finished) {
                [UIView animateKeyframesWithDuration:0.8/4 delay:0 options:0 animations:^{
                    self.viewAlertMessage.transform = CGAffineTransformMakeTranslation(0, -340);
                } completion:^(BOOL finished) {
                    [UIView animateKeyframesWithDuration:0.8/4 delay:0 options:0 animations:^{
                        self.viewAlertMessage.transform = CGAffineTransformMakeTranslation(0, -600);
                    } completion:^(BOOL finished) {
                        self.viewAlertMessage.alpha = 0;

                    }];
                }];
            }];
        }];
        
    }];

}

#pragma mark - UITextField Delegate Methods

// The return button will close the keypad

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];

    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self closeAlertMessage];

//    if (self.viewAlertMessage.alpha == 1) {
//        self.textFieldUsername.text = @"";
//        self.textFieldPassword.text = @"";
//    }

}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    textField.inputAccessoryView = self.buttonLogin;

    return YES;
}

#pragma mark - Notification Methods

// this method gets called whenever a notification is posted to dismiss all view controllers
- (void)dismissAllViewControllers:(NSNotification *)notification {
    // dismiss all view controllers in the navigation stack
    [self dismissViewControllerAnimated:YES completion:^{}];
}


@end
