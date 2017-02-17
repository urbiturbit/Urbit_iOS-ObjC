//
//  SignUpViewController.m
//  Millie
//
//  Created by Emmanuel Masangcay on 6/2/15.
//  Copyright (c) 2015 CoderEXP. All rights reserved.
//

#import "SignUpViewController.h"
#import "PersonalInterestHeader.h"
#import "InterestsCollectionViewController.h"
#import "User.h"
#import "MillieButton.h"
#import "MillieLabel.h"
#import "UIColor+HEX.h"
#import <AFNetworking/AFNetworking.h>

static NSString * const BaseURLString = @"https://millie-dealios.herokuapp.com/api/v1/users";

@interface SignUpViewController () <UITextFieldDelegate,PersonalHeaderDelegate,InterestCollectionViewDelegate>

@property (strong, nonatomic) IBOutlet UITextField *textFieldUsername;
@property (strong, nonatomic) IBOutlet UITextField *textFieldEmail;
@property (strong, nonatomic) IBOutlet UITextField *textFieldPassword;
@property (strong, nonatomic) IBOutlet UITextField *textFieldConfirmPassword;
@property (strong, nonatomic) IBOutlet UIView *viewContainerMain;

@property UIView *viewMerchantQuestion;
@property UIView *viewAlertMessage;
@property PersonalInterestHeader *PersonalInterestHeaderView;
@property UIView * viewInterestAction;
@property InterestsCollectionViewController *iCVC;
@property MillieButton *btnSignup;
@property MillieButton *buttonNext;
@property MillieButton *buttonSkip;
@property NSMutableArray *arrayOfInterests;

@property User *currentUser;

@property UIView *loadingview ;
@property UIActivityIndicatorView *mannyFresh;
@property MillieLabel *posting;


@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.currentUser = [User sharedSingleton];
    [self buildUI];
}

-(void)buildUI
{

    NSAttributedString *strUsername = [[NSAttributedString alloc] initWithString:@"USER NAME" attributes:@{ NSForegroundColorAttributeName : [UIColor colorwithHexString:@"334d5c" alpha:1],NSKernAttributeName : @(1.5f) }];
    self.textFieldUsername.attributedPlaceholder = strUsername;

    NSAttributedString *strEmail = [[NSAttributedString alloc] initWithString:@"EMAIL" attributes:@{ NSForegroundColorAttributeName : [UIColor colorwithHexString:@"334d5c" alpha:1],NSKernAttributeName : @(1.5f) }];
    self.textFieldEmail.attributedPlaceholder = strEmail;

    NSAttributedString *strPassword = [[NSAttributedString alloc] initWithString:@"PASSWORD" attributes:@{ NSForegroundColorAttributeName : [UIColor colorwithHexString:@"334d5c" alpha:1],NSKernAttributeName : @(1.5f) }];
    self.textFieldPassword.attributedPlaceholder = strPassword;

    NSAttributedString *strConfirmPassword = [[NSAttributedString alloc] initWithString:@"CONFIRM PASSWORD" attributes:@{ NSForegroundColorAttributeName : [UIColor colorwithHexString:@"334d5c" alpha:1],NSKernAttributeName : @(1.5f) }];
    self.textFieldConfirmPassword.attributedPlaceholder = strConfirmPassword;

// ******** SignUp Button ******** //
    self.btnSignup = [MillieButton buttonWithType:UIButtonTypeRoundedRect];
    [self.btnSignup setTitle:@"SIGN UP" forState:UIControlStateNormal];
    [self.btnSignup.titleLabel setFont:[UIFont fontWithName:@"ProximaNova-Regular" size:22]];
    [self.btnSignup setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnSignup setBackgroundColor:[UIColor colorwithHexString:@"45b29d" alpha:1]];
    //set the frame
    CGRect btnSignupFrame = CGRectMake(0, 0, 50, 50);

    self.btnSignup.frame = btnSignupFrame;

    [self.btnSignup addTarget:self
                       action:@selector(clickSignup)
             forControlEvents:UIControlEventTouchUpInside];

// ******** Interest HeaderView ******** //
    self.PersonalInterestHeaderView= [[[NSBundle mainBundle] loadNibNamed:@"PersonalInterestHeader"
                                                                    owner:self
                                                                  options:nil] objectAtIndex:0];
    self.PersonalInterestHeaderView.delegate = self;
    CGRect headerFrame = CGRectMake(0, 0, self.PersonalInterestHeaderView.frame.size.width, self.PersonalInterestHeaderView.frame.size.height);
    self.PersonalInterestHeaderView.frame = headerFrame;
    [self.view addSubview:self.PersonalInterestHeaderView];
    self.PersonalInterestHeaderView.alpha = 0;

// ******** Interest CollectionView ******** //
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.iCVC = [mainStoryBoard instantiateViewControllerWithIdentifier:@"interestCollectionView"];
    self.iCVC.delegate = self;
    CGRect collectionFrame = CGRectMake(self.view.frame.origin.x, self.PersonalInterestHeaderView.frame.origin.y + 130, self.iCVC.view.frame.size.width, self.iCVC.view.frame.size.height);
    self.iCVC.view.frame = collectionFrame;

    [self.view addSubview:self.iCVC.view];
    self.iCVC.view.alpha = 0;

// ******** ActionButtons On Bottom of View ******** //

    //ACTION VIEW
    float y = [UIScreen mainScreen].bounds.size.height - 100;

    self.viewInterestAction = [[UIView alloc]initWithFrame:CGRectMake(0, y, self.view.frame.size.width, 100)];
    self.viewInterestAction.backgroundColor = [UIColor whiteColor];

//BUTTON NEXT
    self.buttonNext = [MillieButton new];
    [self.buttonNext setTitle:@"NEXT" forState:UIControlStateNormal];
    [self.buttonNext setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.buttonNext.titleLabel setFont:[UIFont fontWithName:@"ProximaNova-Regular" size:22]];
    [self.buttonNext setBackgroundColor:[UIColor colorwithHexString:@"45b29d" alpha:1]];

    [self.buttonNext.titleLabel setTextAlignment:NSTextAlignmentCenter];

    // Setup Button Appearance
    CALayer *layerNext = self.buttonNext.layer;
    layerNext.borderColor = [[UIColor blackColor]CGColor];
    layerNext.borderWidth = 0.5f;

    //Set the frame
    CGRect btnNextFrame = CGRectMake(-1, 0, self.viewInterestAction.frame.size.width+2, self.viewInterestAction.frame.size.height /2);
    self.buttonNext.frame = btnNextFrame;

    [self.buttonNext addTarget:self
                        action:@selector(clickNext)
              forControlEvents:UIControlEventTouchUpInside];

    //BUTTON SKIP
    self.buttonSkip = [MillieButton new];
    [self.buttonSkip setTitle:@"SKIP" forState:UIControlStateNormal];
    [self.buttonSkip setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.buttonSkip.titleLabel setFont:[UIFont fontWithName:@"ProximaNova-Regular" size:22]];
    [self.buttonSkip setBackgroundColor:[UIColor colorwithHexString:@"df5a49" alpha:1]];
    [self.buttonSkip.titleLabel setTextAlignment:NSTextAlignmentCenter];


    //Set the frame
    CGRect btnSkipFrame = CGRectMake(-1, self.viewInterestAction.frame.size.height /2, self.viewInterestAction.frame.size.width+2, 50);
    self.buttonSkip.frame = btnSkipFrame;

    [self.buttonSkip addTarget:self
                        action:@selector(clickNext)
              forControlEvents:UIControlEventTouchUpInside];

//ADD SUBVIEWS
    [self.viewInterestAction addSubview:self.buttonNext];
    [self.viewInterestAction addSubview:self.buttonSkip];
    [self.view addSubview:self.viewInterestAction];
    
    self.viewInterestAction.alpha = 0;

// ******** MerchantView Question ******** //

    self.viewMerchantQuestion = [[UIView alloc]initWithFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height - self.viewInterestAction.frame.size.height)];
    self.viewMerchantQuestion.backgroundColor = [UIColor colorwithHexString:@"D4ECDC"alpha:1];

    MillieLabel *labelMerchantQuestion = [[MillieLabel alloc]initWithFrame:CGRectMake(20, 0, self.viewMerchantQuestion.frame.size.width - 40, self.viewMerchantQuestion.frame.size.height)];

    labelMerchantQuestion.text = @"DO YOU WANT\nTO POST DEALS AS\n A MERCHANT?";
    labelMerchantQuestion.numberOfLines = 0;
    labelMerchantQuestion.textColor = [UIColor colorwithHexString:@"334d5c" alpha:1];
    [labelMerchantQuestion setFont:[UIFont fontWithName:@"ProximaNova-Regular" size:30]];
    labelMerchantQuestion.textAlignment = NSTextAlignmentCenter;
    labelMerchantQuestion.backgroundColor = [UIColor clearColor];

    [self.viewMerchantQuestion addSubview:labelMerchantQuestion];

    self.viewMerchantQuestion.alpha = 0;

    self.mannyFresh = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x + 10 , self.view.frame.origin.y + 10, 20, 20)];
    self.mannyFresh.tintColor = [UIColor whiteColor];
    self.mannyFresh.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [self.mannyFresh startAnimating];

    self.posting = [[MillieLabel alloc]initWithFrame:CGRectMake(self.mannyFresh.frame.origin.x + 40, self.mannyFresh.frame.origin.y, 100, 30)];
    self.posting.textColor = [UIColor whiteColor];
    [self.posting setFont:[UIFont fontWithName:@"ProximaNova-Semibold" size:20]];
    self.posting.backgroundColor = [UIColor clearColor];
    self.posting.text = @"Signing UP...";

    [self.loadingview addSubview:self.mannyFresh];
    [self.loadingview addSubview:self.posting];

    self.loadingview.alpha = 0;

    [self.view addSubview:self.loadingview];
}

#pragma mark - Button Press Methods
- (IBAction)CancelSignup:(id)sender
{
        [self dismissViewControllerAnimated:YES completion:^{}];
}

-(void)signUpUser
{
    if ([self.textFieldUsername.text isEqualToString:@""] ||
        [self.textFieldEmail.text isEqualToString:@""] ||
        [self.textFieldPassword.text isEqualToString:@""] ||
        [self.textFieldConfirmPassword.text isEqualToString:@""])
    {

        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"ERROR"
                                              message:@"All fields must be completed"
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
    else
    {

        self.loadingview.alpha = .75;
//      NSString *userName = self.textFieldUsername.text;
        NSString *email = self.textFieldEmail.text;
        NSString *password = self.textFieldPassword.text;
        NSString *confirmation = self.textFieldConfirmPassword.text;

        [MillieAPIClient signUpUser:email password:password passwordConfirmation:confirmation completion:^(NSString *result) {
            if ([result isEqualToString:@"YES"])
            {

                [MillieAPIClient logInUser:email password:password completion:^(NSDictionary* result)
                 {
                     if (result)
                     {   self.currentUser.email = email;
                         self.currentUser.userID = [result objectForKey:@"id"];
                         self.loadingview.alpha = 0;
                        [self showPersonalInterest];
                     }
                 }];

            }
            else
            {
                 [self presentAlertMessage:result];
            }
        }];

    }
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

}

// Clicking off any controls will close the keypad
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    textField.inputAccessoryView = self.btnSignup;

    return YES;
}

#pragma mark - Animation Methods

-(void)presentAlertMessage:(NSString*)alertMessage
{
    self.viewAlertMessage = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    self.viewAlertMessage.backgroundColor = [UIColor colorwithHexString:@"df5a49" alpha:1];
    MillieLabel *labelAlertMessage = [[MillieLabel alloc]initWithFrame:CGRectMake(0, 0, self.viewAlertMessage.frame.size.width, self.viewAlertMessage.frame.size.height)];
    labelAlertMessage.textAlignment= NSTextAlignmentCenter;
    labelAlertMessage.textColor = [UIColor whiteColor];
    [labelAlertMessage setFont:[UIFont fontWithName:@"ProximaNova" size:13]];
    labelAlertMessage.lineBreakMode = NSLineBreakByWordWrapping;
    labelAlertMessage.numberOfLines = 0;
    labelAlertMessage.text = alertMessage;

    [self.viewAlertMessage addSubview:labelAlertMessage];
    [self.view addSubview:self.viewAlertMessage];

    self.viewAlertMessage.alpha = 0;

    // Present ActivityView with animation dropdown
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
                        self.viewContainerMain.transform = CGAffineTransformMakeTranslation(0, 50);
                    } completion:^(BOOL finished) {
                        [self.textFieldConfirmPassword resignFirstResponder];
                        [self.textFieldPassword resignFirstResponder];
                        [self.textFieldEmail resignFirstResponder];
                        [self.textFieldUsername resignFirstResponder];
                    }];
                }];
            }];
        }];
    }];
}

-(void)closeAlertMessage
{
    [UIView animateWithDuration:0.3 animations:^{
    } completion:^(BOOL finished) {
        self.viewAlertMessage.transform = CGAffineTransformMakeTranslation(0, 0);
        [UIView animateKeyframesWithDuration:0.8/4 delay:0 options:0 animations:^{
            self.viewContainerMain.transform = CGAffineTransformMakeTranslation(0, 0);
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

-(void)showPersonalInterest
{

// ******** ANIMATION******** //
    [UIView animateWithDuration:0.3 animations:^{
    } completion:^(BOOL finished) {
        self.PersonalInterestHeaderView.alpha = 1;
        self.PersonalInterestHeaderView.transform = CGAffineTransformMakeTranslation(600, 0);
        [UIView animateKeyframesWithDuration:0.8/4 delay:0 options:0 animations:^{
            self.PersonalInterestHeaderView.transform = CGAffineTransformMakeTranslation(340, 0);
            self.viewContainerMain.transform = CGAffineTransformMakeTranslation(0, 0);
        } completion:^(BOOL finished) {
            [UIView animateKeyframesWithDuration:0.8/4 delay:0 options:0 animations:^{
                self.PersonalInterestHeaderView.transform = CGAffineTransformMakeTranslation(100, 0);
                self.viewContainerMain.transform = CGAffineTransformMakeTranslation(0, 200);
            } completion:^(BOOL finished) {
                [UIView animateKeyframesWithDuration:0.8/4 delay:0 options:0 animations:^{
                    self.PersonalInterestHeaderView.transform = CGAffineTransformMakeTranslation(10, 0);
                    self.viewContainerMain.transform = CGAffineTransformMakeTranslation(0, 500);
                    self.viewInterestAction.alpha = 1;
                    self.viewInterestAction.transform = CGAffineTransformMakeTranslation(0, 200);
                } completion:^(BOOL finished) {
                    [UIView animateKeyframesWithDuration:0.8/4 delay:0 options:0 animations:^{
                        self.PersonalInterestHeaderView.transform = CGAffineTransformMakeTranslation(0, 0);
                        self.viewContainerMain.transform = CGAffineTransformMakeTranslation(0, 1000);
                        self.viewInterestAction.transform = CGAffineTransformMakeTranslation(0, 0);
                    } completion:^(BOOL finished) {
                        [UIView animateWithDuration:0.2f delay:0.f options:UIViewAnimationOptionCurveEaseIn animations:^{
                            [self.iCVC.view setAlpha:1.f];
                        } completion:^(BOOL finished) {
                        }];
                    }];
                }];
            }];
        }];
    }];
}

-(void)closePersonalInterest
{
    [UIView animateWithDuration:0.2f delay:0.f options:UIViewAnimationOptionCurveEaseIn animations:^{
        [self.iCVC.view setAlpha:0.f];
    } completion:^(BOOL finished) {
    [UIView animateWithDuration:0.3 animations:^{
    } completion:^(BOOL finished) {
        self.PersonalInterestHeaderView.transform = CGAffineTransformMakeTranslation(0, 0);
        self.viewInterestAction.transform = CGAffineTransformMakeTranslation(0, 0);
        [UIView animateKeyframesWithDuration:0.8/4 delay:0 options:0 animations:^{
            self.PersonalInterestHeaderView.transform= CGAffineTransformMakeTranslation(10, 0);
            self.viewContainerMain.transform = CGAffineTransformMakeTranslation(0, 1000);
            self.viewInterestAction.transform = CGAffineTransformMakeTranslation(0, 100);
        } completion:^(BOOL finished) {
            [UIView animateKeyframesWithDuration:0.8/4 delay:0 options:0 animations:^{
               self.PersonalInterestHeaderView.transform = CGAffineTransformMakeTranslation(100, 0);
                self.viewContainerMain.transform = CGAffineTransformMakeTranslation(0, 500);
                self.viewInterestAction.transform = CGAffineTransformMakeTranslation(0, 200);
            } completion:^(BOOL finished) {
                [UIView animateKeyframesWithDuration:0.8/4 delay:0 options:0 animations:^{
                    self.PersonalInterestHeaderView.transform = CGAffineTransformMakeTranslation(340, 0);
                    self.viewContainerMain.transform = CGAffineTransformMakeTranslation(0, 200);
                } completion:^(BOOL finished) {
                    [UIView animateKeyframesWithDuration:0.8/4 delay:0 options:0 animations:^{
                        self.PersonalInterestHeaderView.transform = CGAffineTransformMakeTranslation(600, 0);
                        self.viewContainerMain.transform = CGAffineTransformMakeTranslation(0, 0);
                    } completion:^(BOOL finished) {
                         self.PersonalInterestHeaderView.alpha = 0;
                        self.viewInterestAction.alpha = 0;
                    }];
                }];
            }];
        }];
    }];
}];
}

-(void)showMerchantQuestion
{
    [UIView animateWithDuration:0.2f delay:0.f options:UIViewAnimationOptionCurveEaseIn animations:^{
        [self.iCVC.view setAlpha:0.f];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
        } completion:^(BOOL finished) {
            self.PersonalInterestHeaderView.transform = CGAffineTransformMakeTranslation(0, 0);
            self.viewInterestAction.transform = CGAffineTransformMakeTranslation(0, 0);
            [UIView animateKeyframesWithDuration:0.8/4 delay:0 options:0 animations:^{
                self.PersonalInterestHeaderView.transform= CGAffineTransformMakeTranslation(-10, 0);
                self.viewInterestAction.transform = CGAffineTransformMakeTranslation(0, 100);
            } completion:^(BOOL finished) {
                [UIView animateKeyframesWithDuration:0.8/4 delay:0 options:0 animations:^{
                    self.PersonalInterestHeaderView.transform = CGAffineTransformMakeTranslation(-100, 0);
                    self.viewInterestAction.transform = CGAffineTransformMakeTranslation(0, 200);
                } completion:^(BOOL finished) {
                    [UIView animateKeyframesWithDuration:0.8/4 delay:0 options:0 animations:^{
                        self.PersonalInterestHeaderView.transform = CGAffineTransformMakeTranslation(-340, 0);
                    } completion:^(BOOL finished) {
                        [UIView animateKeyframesWithDuration:0.8/4 delay:0 options:0 animations:^{
                            self.PersonalInterestHeaderView.transform = CGAffineTransformMakeTranslation(-600, 0);
                        } completion:^(BOOL finished) {
                            self.PersonalInterestHeaderView.alpha = 0;
                            self.viewInterestAction.alpha = 0;
                            [UIView animateWithDuration:0.3 animations:^{
                            } completion:^(BOOL finished){
                                [UIView animateKeyframesWithDuration:0.8/4 delay:0 options:0 animations:^{
                                } completion:^(BOOL finished) {
                                    [UIView animateKeyframesWithDuration:0.8/4 delay:0 options:0 animations:^{
                                        self.viewInterestAction.alpha = 1;
                                        self.viewInterestAction.transform = CGAffineTransformMakeTranslation(0, 200);
                                    } completion:^(BOOL finished) {
                                        [self.buttonNext removeTarget:self action:@selector(clickNext) forControlEvents:UIControlEventTouchUpInside];
                                        [self.buttonNext setTitle:@"YES" forState:UIControlStateNormal];
                                        [self.buttonNext addTarget:self action:@selector(clickYes) forControlEvents:UIControlEventTouchUpInside];

                                        [self.buttonSkip removeTarget:self action:@selector(clickNext) forControlEvents:UIControlEventTouchUpInside];
                                        [self.buttonSkip setTitle:@"NOT RIGHT NOW" forState:UIControlStateNormal];
                                        [self.buttonSkip addTarget:self action:@selector(clickNotRightNow) forControlEvents:UIControlEventTouchUpInside];
                                        [UIView animateKeyframesWithDuration:0.8/4 delay:0 options:0 animations:^{
                                            self.viewInterestAction.transform = CGAffineTransformMakeTranslation(0, 0);
                                        } completion:^(BOOL finished) {

                                            [self.view addSubview:self.viewMerchantQuestion];
                                            [UIView animateWithDuration:0.2f delay:0.f options:UIViewAnimationOptionCurveEaseIn animations:^{
                                                [self.viewMerchantQuestion setAlpha:1.f];
                                            } completion:^(BOOL finished) {
                                            }];
                                        }];
                                    }];
                                }];
                            }];
                        }];
                    }];
                }];
            }];
        }];
    }];
}


#pragma mark - PersonalInterestHeader Delegate Method

-(void)onClickBack
{
    [self closePersonalInterest];
}

#pragma mark - InterestCollectionView Delegate Method

-(void)tapInterest:(NSString *)interest
{
    if (!self.arrayOfInterests) {
        self.arrayOfInterests = [NSMutableArray new];
    }

    [self.arrayOfInterests addObject:interest];
}


-(void)removeInterest:(NSString *)interest
{
    [self.arrayOfInterests removeObject:interest];
}

-(BOOL)checkInterest:(NSString *)interest
{
    if ([self.arrayOfInterests containsObject:interest]) {
        return YES;
    }
    else
    {
        return NO;
    }
}

#pragma mark - Helper Method

-(void)clickSignup
{
    [self.textFieldUsername resignFirstResponder];
    [self.textFieldConfirmPassword resignFirstResponder];
    [self.textFieldPassword resignFirstResponder];
    [self.textFieldEmail resignFirstResponder];
//    [self signUpUser];
    [self showPersonalInterest];

}

-(void)clickNext
{
    [self showMerchantQuestion];
}


-(void)clickYes
{
    NSLog(@"Click Yes");
    [self performSegueWithIdentifier:@"goToMerchantSetup" sender:self];
}

-(void)clickNotRightNow
{
    NSLog(@"Not Right Now");
    [self performSegueWithIdentifier:@"pushToMain" sender:self];
}

@end
