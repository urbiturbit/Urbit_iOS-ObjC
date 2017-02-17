//
//  MerchantSetupViewController.m
//  Millie
//
//  Created by Emmanuel Masangcay on 6/7/15.
//  Copyright (c) 2015 CoderEXP. All rights reserved.
//

#import "MerchantSetupViewController.h"
#import "MerchantTypeCollectionViewController.h"
#import "MerchantSetupBusinessHeader.h"
#import "MerchantSetupPhotos.h"
#import "Utility.h"
#import "MillieAPIClient.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "UIColor+HEX.h"
#import "MillieButton.h"
#import "MillieLabel.h"
#import "User.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface MerchantSetupViewController ()<UITextFieldDelegate,MerchantTypeCollectionViewDelegate,BusinessSetupDelegate,MerchantSetupPhotosDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>

@property (strong, nonatomic) IBOutlet UITextField *textFieldBusinessName;
@property (strong, nonatomic) IBOutlet UITextField *textFieldAddress;
@property (strong, nonatomic) IBOutlet UITextField *textFieldPhone;
@property (strong, nonatomic) IBOutlet UITextField *textFieldHours;

@property (strong, nonatomic) IBOutlet UIView *viewMerchantSetupHeader;

@property (strong, nonatomic) IBOutlet UIView *viewMerchantSetupMain;
@property (strong, nonatomic) IBOutlet MillieLabel *labelMerchantHeaderDescription;
@property (strong, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *viewScrollView;
@property (strong, nonatomic) IBOutlet UITextField *textFieldCity;
@property (strong, nonatomic) IBOutlet UITextField *textFieldZip;
@property (strong, nonatomic) IBOutlet UITextField *textFieldWebsite;
@property (strong, nonatomic) IBOutlet UITextField *textFieldState;


@property MillieButton *btnNextKeyboard;
@property MillieButton *btnNextAction;
@property MillieLabel *labelBusinessName;
@property MillieLabel *labelMerchantPhotoSubheader;

@property NSString *businessType;
@property UIView *viewMerchantAction;
@property UIView *viewSyncSocialProfiles;
@property UIImageView *imageviewEditShop;
@property MerchantTypeCollectionViewController *mTCVC;
@property MerchantSetupBusinessHeader *businessTypeHeader;
@property MerchantSetupPhotos *viewMerchantPhotos;
@property UIImagePickerController *imagePicker;
@property UIImage *imageMerchantPhoto;
@property UIImage *imageMerchantLogo;
@property NSString *photoReference;
@property NSArray *businessLocation;
@property NSString *stringImageDataMain;
@property User *currentUser;

@property BOOL mainImageSet;
@property NSMutableArray *arrayOfBusinessPhotos;

@property UIView *loadingview ;
@property UIActivityIndicatorView *mannyFresh;
@property MillieLabel *posting;

@end


NSString *businessName;

@implementation MerchantSetupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentUser = [User sharedSingleton];
    self.mainImageSet = NO;
    self.arrayOfBusinessPhotos = [NSMutableArray new];
    [self setUpUI];
}

#pragma mark - SETUP UI

-(void)setUpUI
{
    NSAttributedString *strBusinessname = [[NSAttributedString alloc] initWithString:@"BUSINESS NAME" attributes:@{ NSForegroundColorAttributeName : [UIColor colorwithHexString:@"334d5c" alpha:1],NSKernAttributeName : @(1.5f) }];
    self.textFieldBusinessName.attributedPlaceholder = strBusinessname;

    NSAttributedString *strBusinessAddr = [[NSAttributedString alloc] initWithString:@"ADDRESS" attributes:@{ NSForegroundColorAttributeName : [UIColor colorwithHexString:@"334d5c" alpha:1],NSKernAttributeName : @(1.5f) }];
    self.textFieldAddress.attributedPlaceholder = strBusinessAddr;

    NSAttributedString *strBusinessPhone = [[NSAttributedString alloc] initWithString:@"PHONE" attributes:@{ NSForegroundColorAttributeName : [UIColor colorwithHexString:@"334d5c" alpha:1],NSKernAttributeName : @(1.5f) }];
    self.textFieldPhone.attributedPlaceholder = strBusinessPhone;

    NSAttributedString *strBusinessHours = [[NSAttributedString alloc] initWithString:@"HOURS" attributes:@{ NSForegroundColorAttributeName : [UIColor colorwithHexString:@"334d5c" alpha:1],NSKernAttributeName : @(1.5f) }];
    self.textFieldHours.attributedPlaceholder = strBusinessHours;

    NSAttributedString *strBusinessCity = [[NSAttributedString alloc] initWithString:@"CITY" attributes:@{ NSForegroundColorAttributeName : [UIColor colorwithHexString:@"334d5c" alpha:1],NSKernAttributeName : @(1.5f) }];
    self.textFieldCity.attributedPlaceholder = strBusinessCity;

    NSAttributedString *strBusinessState = [[NSAttributedString alloc] initWithString:@"STATE" attributes:@{ NSForegroundColorAttributeName : [UIColor colorwithHexString:@"334d5c" alpha:1],NSKernAttributeName : @(1.5f) }];
    self.textFieldState.attributedPlaceholder = strBusinessState;

    NSAttributedString *strBusinessZip = [[NSAttributedString alloc] initWithString:@"ZIP" attributes:@{ NSForegroundColorAttributeName : [UIColor colorwithHexString:@"334d5c" alpha:1],NSKernAttributeName : @(1.5f) }];
    self.textFieldZip.attributedPlaceholder = strBusinessZip;

    NSAttributedString *strBusinessWebsite = [[NSAttributedString alloc] initWithString:@"WEBSITE" attributes:@{ NSForegroundColorAttributeName : [UIColor colorwithHexString:@"334d5c" alpha:1],NSKernAttributeName : @(1.5f) }];
    self.textFieldWebsite.attributedPlaceholder = strBusinessWebsite;

// ******** SignUp Button ******** //
    self.btnNextKeyboard = [MillieButton buttonWithType:UIButtonTypeRoundedRect];
    [self.btnNextKeyboard setTitle:@"NEXT" forState:UIControlStateNormal];
    [self.btnNextKeyboard.titleLabel setFont:[UIFont fontWithName:@"ProximaNova-Regular" size:21]];

    [self.btnNextKeyboard setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnNextKeyboard setBackgroundColor:[UIColor colorwithHexString:@"45b29d" alpha:1]];
    //set the frame
    CGRect btnNextFrame = CGRectMake(0, 0, 50, 60);

    self.btnNextKeyboard.frame = btnNextFrame;

    [self.btnNextKeyboard addTarget:self
                       action:@selector(clickNext)
             forControlEvents:UIControlEventTouchUpInside];

// ******** Interest CollectionView ******** //
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.mTCVC = [mainStoryBoard instantiateViewControllerWithIdentifier:@"businessTypeCollectionView"];
    self.mTCVC.delegate = self;
    CGRect collectionFrame = CGRectMake(self.view.frame.origin.x, self.viewMerchantSetupHeader.frame.origin.y + 140, self.mTCVC.view.frame.size.width, self.mTCVC.view.frame.size.height);
    self.mTCVC.view.frame = collectionFrame;

    [self.view addSubview:self.mTCVC.view];
    self.mTCVC.view.alpha = 0;

// ******** Merchant Setup Business Type Header View ******** //
    self.businessTypeHeader= [[[NSBundle mainBundle] loadNibNamed:@"MerchantSetupBusinessHeader"
                                                                    owner:self
                                                                  options:nil] objectAtIndex:0];
    self.businessTypeHeader.delegate = self;
    CGRect headerFrame = CGRectMake(0, 0, self.businessTypeHeader.frame.size.width, self.businessTypeHeader.frame.size.height);
    self.businessTypeHeader.frame = headerFrame;
    [self.view addSubview:self.businessTypeHeader];
    self.businessTypeHeader.alpha = 0;

// ******** ActionButtons On Bottom of View ******** //

    //ACTION VIEW
    float y = [UIScreen mainScreen].bounds.size.height - 50;

    self.viewMerchantAction = [[UIView alloc]initWithFrame:CGRectMake(0, y, self.view.frame.size.width, 50)];
    self.viewMerchantAction.backgroundColor = [UIColor colorwithHexString:@"45b29d" alpha:1];

    //BUTTON NEXT
    self.btnNextAction = [MillieButton new];
    [self.btnNextAction setTitle:@"NEXT" forState:UIControlStateNormal];
    [self.btnNextAction setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnNextAction.titleLabel setFont:[UIFont fontWithName:@"ProximaNova-Regular" size:24]];;
    [self.btnNextAction.titleLabel setTextAlignment:NSTextAlignmentCenter];

    // Setup Button Appearance
    CALayer *layerNext = self.btnNextAction.layer;
//     layerNext.borderColor = [[UIColor blackColor]CGColor];
    layerNext.borderWidth = 0.5f;

    //Set the frame
    CGRect btnNextActionFrame = CGRectMake(-1, 1, self.viewMerchantAction.frame.size.width+2, self.viewMerchantAction.frame.size.height);
    self.btnNextAction.frame = btnNextActionFrame;

    [self.btnNextAction addTarget:self
                        action:@selector(clickNextAction)
              forControlEvents:UIControlEventTouchUpInside];

    [self.viewMerchantAction addSubview:self.btnNextAction];
    [self.view addSubview:self.viewMerchantAction];

    self.viewMerchantAction.alpha = 0;

// ******** Merchant Photos View ******** //

    //****** Main ImageView ******//
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;

    CGFloat xPosition;


    if (screenWidth == 375) {//iphone6
        xPosition = 70;
    }
    else if(screenWidth == 320){//iphone5,5s
        xPosition = 100;
    }
    else if(screenWidth == 414){//iphone6+
        xPosition = 50;
    }

    self.imageviewEditShop = [[UIImageView alloc]initWithFrame:CGRectMake(self.viewScrollView.frame.size.width /2 - xPosition, self.viewMerchantSetupHeader.frame.origin.y+20, 140, 140)];
    [self.imageviewEditShop setContentMode:UIViewContentModeScaleAspectFill];
    UIImage *imageEditShop = [UIImage imageNamed:@"EditShop"];
    [self.imageviewEditShop setImage:imageEditShop];

    //******* Set TapGesture Recognizers *******//
    UITapGestureRecognizer *tapMerchantIcon = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addMerchantIcon:)];
    tapMerchantIcon.numberOfTapsRequired = 1;
    tapMerchantIcon.numberOfTouchesRequired = 1;
    self.imageviewEditShop.userInteractionEnabled = YES;
    [self.imageviewEditShop addGestureRecognizer:tapMerchantIcon];

    [self.imageviewEditShop setAlpha:0];

    //Custom Loading Screen
    self.loadingview = [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width / 2 -75, self.view.frame.size.height / 2 -75, 150, 60)];
    self.loadingview.backgroundColor = [UIColor colorwithHexString:@"45b29d" alpha:1];

    self.mannyFresh = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x + 10 , self.view.frame.origin.y + 10, 20, 20)];
    self.mannyFresh.tintColor = [UIColor whiteColor];
    self.mannyFresh.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [self.mannyFresh startAnimating];

    self.posting = [[MillieLabel alloc]initWithFrame:CGRectMake(self.mannyFresh.frame.origin.x + 40, self.mannyFresh.frame.origin.y, 100, 30)];
    self.posting.textColor = [UIColor whiteColor];
    [self.posting setFont:[UIFont fontWithName:@"ProximaNova-Semibold" size:20]];
    self.posting.backgroundColor = [UIColor clearColor];
    self.posting.text = @"Setting Up Merchant...";

    [self.loadingview addSubview:self.mannyFresh];
    [self.loadingview addSubview:self.posting];

    self.loadingview.alpha = 0;

    [self.view addSubview:self.loadingview];

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

}

// Clicking off any controls will close the keypad
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {

    textField.inputAccessoryView = self.btnNextKeyboard;

    return YES;
}

#pragma mark - Button Press Methods
- (IBAction)onButtonPressBack:(id)sender
{
    if (self.viewMerchantPhotos.alpha == 1) {

        [self closeMerchantSetupPhotos];
    }
    else if(self.mTCVC.view.alpha == 1)
    {
        [self closeMerchantPreferences];
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:^{}];

    }
}

-(void)clickNext
{
    NSLog(@"Click Next");
    [self.textFieldBusinessName resignFirstResponder];
    [self.textFieldAddress resignFirstResponder];
    [self.textFieldPhone resignFirstResponder];
    [self.textFieldHours resignFirstResponder];
    [self.textFieldCity resignFirstResponder];
    [self.textFieldZip resignFirstResponder];
    [self.textFieldWebsite resignFirstResponder];
    [self.textFieldState resignFirstResponder];
    
    [self showMerchantPreferences];
}

-(void)clickNextAction
{
    if ([self.btnNextAction.titleLabel.text isEqualToString:@"CONFIRM"])
    {
        if (self.mainImageSet == NO) {
            UIAlertView *createBusinessSuccess = [[UIAlertView alloc] initWithTitle:@"URBIT" message:@"You Must Add A Business Logo" delegate:self cancelButtonTitle:@"Next" otherButtonTitles:nil, nil];
            [createBusinessSuccess show];
        }
        else
        {

        NSLog(@"CONFIRM AND SAVE");

        NSString *token = [Lockbox stringForKey:@"token"];
      //  NSString *token = @"jGCNwoQpZEBQ_LyaLDWM";
        NSString *businessName = self.textFieldBusinessName.text;
        NSString *businessAddr = self.textFieldAddress.text;
        NSString *businessPhone = self.textFieldPhone.text;
        NSString *businessHours = self.textFieldHours.text;
        NSString *businessType = self.businessType;
        NSString *businessCity = self.textFieldCity.text;
        NSString *businessState = self.textFieldState.text;
        NSString *businessWebsite = self.textFieldWebsite.text;
        NSString *businessZip = self.textFieldZip.text;
        NSString *businessDescription = self.mTCVC.textViewBusinessDescription.text;


        NSString *locationAddr = [NSString stringWithFormat:@"%@ %@, %@ %@",businessAddr,businessCity,businessState,businessZip];

        self.businessLocation = [Utility getLatLongfromAddress:locationAddr];


        NSString *latitude = [self.businessLocation valueForKey:@"lat"];
        NSString *longitude = [self.businessLocation valueForKey:@"lng"];


        self.loadingview.alpha = .75;

        [MillieAPIClient createBusiness:token businessName:businessName businessAddress:businessAddr businessPhone:businessPhone businessHours:businessHours businessType:businessType longitude:longitude latitude:latitude businessCity:businessCity businessZip:businessZip businessState:businessState website:businessWebsite description:businessDescription completion:^(NSDictionary *result) {
            
            if (result) {

                NSString *businessID = [result objectForKey:@"id"];
                 self.currentUser.business = result;

                NSNumber *main = [NSNumber numberWithInt:1];

                [MillieAPIClient postImage:token businessID:businessID dealID:nil userID:nil type:@"business" photoData:self.stringImageDataMain mainImage:main completion:^(NSDictionary *result) {

//                    NSData *dataImage = [NSData dataWithContentsOfFile:self.stringImageDataMain];
//                    UIImage *businessImage = [UIImage imageWithData:dataImage];

                    self.currentUser.businessProfilePic = self.imageMerchantLogo;

                    if (self.arrayOfBusinessPhotos.count !=0) {


                    for (NSString *stringImageData in self.arrayOfBusinessPhotos) {

                        NSNumber *main = [NSNumber numberWithInt:0];

                        [MillieAPIClient postImage:token businessID:businessID dealID:nil userID:nil type:@"business" photoData:stringImageData mainImage:main completion:^(NSDictionary *result) {
                            if (stringImageData == self.arrayOfBusinessPhotos.lastObject) {
                                UIAlertView *createBusinessSuccess = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Your Business Has Been Added" delegate:self cancelButtonTitle:@"Next" otherButtonTitles:nil, nil];
                                [createBusinessSuccess show];

                                self.loadingview.alpha = 0;

                                [self performSegueWithIdentifier:@"pushToMerchant" sender:self];
                            }
                        }];
                    }
                    }

                    else
                    {
                        UIAlertView *createBusinessSuccess = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Your Business Has Been Added" delegate:self cancelButtonTitle:@"Next" otherButtonTitles:nil, nil];
                        [createBusinessSuccess show];

                        [self performSegueWithIdentifier:@"pushToMerchant" sender:self];
                    }

                }];
            }
            else
            {
                NSLog(@"SHIT FAILED");
            }
        }];

    }
    }
    else
    {
    NSLog(@"Next Action");
    [self showMerchantPhoto];
    }

}

#pragma mark - Animation Methods

-(void)showMerchantPreferences
{
    businessName = self.textFieldBusinessName.text;

    if (!self.viewMerchantPhotos) {
        self.viewMerchantPhotos = [[MerchantSetupPhotos alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];

        float yOfViewMerchantPhotos = self.viewMerchantSetupHeader.frame.size.height + 60 + self.imageviewEditShop.frame.size.height - 50;

        CGRect merchantPhotosFrame = CGRectMake(0, yOfViewMerchantPhotos, self.viewScrollView.frame.size.width, self.viewMerchantPhotos.frame.size.height);
        self.viewMerchantPhotos.frame = merchantPhotosFrame;
        [self.viewScrollView addSubview:self.viewMerchantPhotos];
        self.viewMerchantPhotos.alpha = 0;

    }
    else
    {
        [self.viewMerchantPhotos setBusinessName:self.textFieldBusinessName.text];
    }
    [UIView animateWithDuration:0.3 animations:^{
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
        } completion:^(BOOL finished) {
            self.viewMerchantSetupHeader.transform = CGAffineTransformMakeTranslation(0, 0);
                       [UIView animateKeyframesWithDuration:0.8/4 delay:0 options:0 animations:^{
                self.viewMerchantSetupMain.transform = CGAffineTransformMakeTranslation(0, 0);
            } completion:^(BOOL finished) {
                [UIView animateKeyframesWithDuration:0.8/4 delay:0 options:0 animations:^{
                    self.viewMerchantSetupMain.transform = CGAffineTransformMakeTranslation(0, 200);
                } completion:^(BOOL finished) {
                    [UIView animateKeyframesWithDuration:0.8/4 delay:0 options:0 animations:^{
                        self.viewMerchantSetupMain.transform = CGAffineTransformMakeTranslation(0, 500);
                        self.viewMerchantAction.alpha = 1;
                        self.viewMerchantAction.transform = CGAffineTransformMakeTranslation(0, 200);
                    } completion:^(BOOL finished) {
                        [UIView animateKeyframesWithDuration:0.8/4 delay:0 options:0 animations:^{
                            self.viewMerchantSetupMain.transform = CGAffineTransformMakeTranslation(0, 1000);
                            self.viewMerchantAction.transform = CGAffineTransformMakeTranslation(0, 0);
                        } completion:^(BOOL finished) {
                            [UIView animateWithDuration:0.2f delay:0.f options:UIViewAnimationOptionCurveEaseIn animations:^{
                                [self.mTCVC.view setAlpha:1.f];
                            } completion:^(BOOL finished) {

                            }];
                        }];
                    }];
                }];
            }];
        }];
    }];
}

-(void)closeMerchantPreferences
{
    // Merchant Photo Setup
    [UIView animateWithDuration:0.2f delay:0.f options:UIViewAnimationOptionCurveEaseIn animations:^{
        [self.mTCVC.view setAlpha:0.f];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
        } completion:^(BOOL finished) {
            self.viewMerchantAction.transform = CGAffineTransformMakeTranslation(0, 0);

            [UIView animateKeyframesWithDuration:0.8/4 delay:0 options:0 animations:^{
                self.viewMerchantSetupMain.transform = CGAffineTransformMakeTranslation(0, 1000);
                self.viewMerchantAction.transform = CGAffineTransformMakeTranslation(0, 100);
                self.viewMerchantAction.alpha = 0;

            } completion:^(BOOL finished) {
                [UIView animateKeyframesWithDuration:0.8/4 delay:0 options:0 animations:^{
                    self.viewMerchantSetupMain.transform = CGAffineTransformMakeTranslation(0, 500);
                    self.viewMerchantAction.transform = CGAffineTransformMakeTranslation(0, 200);

                } completion:^(BOOL finished) {
                    [UIView animateKeyframesWithDuration:0.8/4 delay:0 options:0 animations:^{
                        self.viewMerchantSetupMain.transform = CGAffineTransformMakeTranslation(0, 200);
                    } completion:^(BOOL finished) {
                        [UIView animateKeyframesWithDuration:0.8/4 delay:0 options:0 animations:^{
                            self.viewMerchantSetupMain.transform = CGAffineTransformMakeTranslation(0, 0);
                        } completion:^(BOOL finished) {
                        }];
                    }];
                }];
            }];
        }];
    }];
}

-(void)showMerchantPhoto
{
  self.viewMerchantPhotos.delegate = self;
 [self.viewScrollView addSubview:self.imageviewEditShop];
    [self.viewScrollView bringSubviewToFront:self.imageviewEditShop];

    //Animation
    [UIView animateWithDuration:0.2f delay:0.f options:UIViewAnimationOptionCurveEaseIn animations:^{
        [self.mTCVC.view setAlpha:0.f];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
        } completion:^(BOOL finished) {
            self.labelMerchantHeaderDescription.text = @" ";
//            self.imageviewEditShop.alpha = 1;
            self.imageviewEditShop.transform = CGAffineTransformMakeScale(0, 0);
            self.viewMerchantPhotos.alpha = 1;
            self.viewMerchantPhotos.transform = CGAffineTransformMakeTranslation(0, 600);
            [UIView animateKeyframesWithDuration:0.8/4 delay:0 options:0 animations:^{
                self.imageviewEditShop.alpha = 1;
                self.imageviewEditShop.transform = CGAffineTransformMakeScale(0.25, 0.25);
                self.viewMerchantPhotos.transform = CGAffineTransformMakeTranslation(0, 340);
            } completion:^(BOOL finished) {
                [UIView animateKeyframesWithDuration:0.8/4 delay:0 options:0 animations:^{

                    self.imageviewEditShop.transform = CGAffineTransformMakeScale(0.5, 0.5);
                    self.viewMerchantPhotos.transform = CGAffineTransformMakeTranslation(0, 100);
                    [self.btnNextAction setTitle:@"CONFIRM" forState:UIControlStateNormal];

                } completion:^(BOOL finished) {
                    [UIView animateKeyframesWithDuration:0.8/4 delay:0 options:0 animations:^{

                        self.imageviewEditShop.transform = CGAffineTransformMakeScale(0.75, 0.75);
                        self.viewMerchantPhotos.transform = CGAffineTransformMakeTranslation(0, 10);
                    } completion:^(BOOL finished) {
                        [UIView animateKeyframesWithDuration:0.8/4 delay:0 options:0 animations:^{

                            self.imageviewEditShop.transform = CGAffineTransformMakeScale(1, 1);
                            self.viewSyncSocialProfiles.alpha = 1;
                            self.viewMerchantPhotos.transform = CGAffineTransformMakeTranslation(0, 0);
                        } completion:^(BOOL finished) {
                            self.labelMerchantHeaderDescription.text = @"";
                        }];
                    }];
                }];
            }];
        }];
    }];
}

-(void)closeMerchantSetupPhotos
{
    [UIView animateWithDuration:0.2f delay:0.f options:UIViewAnimationOptionCurveEaseIn animations:^{
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
        } completion:^(BOOL finished) {
            self.imageviewEditShop.transform = CGAffineTransformMakeScale(1, 1);
            self.viewMerchantPhotos.transform = CGAffineTransformMakeTranslation(0, 0);

            [UIView animateKeyframesWithDuration:0.8/4 delay:0 options:0 animations:^{
                self.imageviewEditShop.transform = CGAffineTransformMakeScale(0.75, 0.75);
                self.viewMerchantPhotos.transform = CGAffineTransformMakeTranslation(0, 10);


            } completion:^(BOOL finished) {
                [UIView animateKeyframesWithDuration:0.8/4 delay:0 options:0 animations:^{
                    self.imageviewEditShop.transform = CGAffineTransformMakeScale(0.5, 0.5);
                    self.viewMerchantPhotos.transform = CGAffineTransformMakeTranslation(0, 100);


                } completion:^(BOOL finished) {
                    [UIView animateKeyframesWithDuration:0.8/4 delay:0 options:0 animations:^{
                        self.imageviewEditShop.transform = CGAffineTransformMakeScale(0.25, 0.25);
                        self.viewMerchantPhotos.transform = CGAffineTransformMakeTranslation(0, 340);
                        [self.btnNextAction setTitle:@"NEXT" forState:UIControlStateNormal];

                    } completion:^(BOOL finished) {
                        [UIView animateKeyframesWithDuration:0.8/4 delay:0 options:0 animations:^{                            self.imageviewEditShop.transform = CGAffineTransformMakeScale(0, 0);
                            self.viewMerchantPhotos.transform = CGAffineTransformMakeTranslation(0, 600);

                        } completion:^(BOOL finished) {
                            [UIView animateWithDuration:0.2f delay:0.f options:UIViewAnimationOptionCurveEaseIn animations:^{
                                [self.mTCVC.view setAlpha:1.f];
                                self.viewMerchantPhotos.alpha = 0;
                            } completion:^(BOOL finished) {
                                self.labelMerchantHeaderDescription.text = @"BUSINESS DESCRIPTION";

                            }];
                        }];
                    }];
                }];
            }];
        }];
    }];
}

#pragma mark - MerchantType Delegate Method

-(void)tapBusinessType:(NSString *)businessType
{
    self.businessType = businessType;
}

#pragma mark - BusinessType Delegate Method

-(void)onClickBack
{
    NSLog(@"Click back to Merchant Setup fields");
    [self closeMerchantPreferences];
}

#pragma mark - CustomProfileDelegate Methods

-(void)tapOnCamera:(NSString *)photoReference
{
    [self setupCamera:photoReference];
}

-(void)tapOnLibrary:(NSString *)photoReference
{
    [self setupLibrary:photoReference];
}

#pragma mark - UIImagePicker Methods

-(void)setupCamera:(NSString*)photoReference
{
    self.imagePicker = [[UIImagePickerController alloc]init];
    self.imagePicker.delegate = self;
    self.imagePicker.allowsEditing = YES;
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.imagePicker.mediaTypes =  [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];

    [self presentViewController:self.imagePicker animated:YES completion:^{
        self.photoReference = photoReference;
    }];
}

-(void)setupLibrary:(NSString*)photoReference
{
    self.imagePicker = [[UIImagePickerController alloc]init];
    self.imagePicker.delegate = self;
    self.imagePicker.allowsEditing = YES;
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    UIColor *backgroundColor = [UIColor colorWithRed:0.38 green:0.51 blue:0.85 alpha:1.0];
    self.imagePicker.navigationBar.barTintColor = backgroundColor;
    self.imagePicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:self.imagePicker.sourceType];
    [self presentViewController:self.imagePicker animated:YES completion:^{
        self.photoReference = photoReference;
    }];
}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];

    if ([mediaType isEqualToString:(NSString *)kUTTypeImage])
    {
        self.imageMerchantPhoto = [info objectForKey:UIImagePickerControllerOriginalImage];
        NSData *imageData =  UIImagePNGRepresentation([info objectForKey:UIImagePickerControllerOriginalImage]);

        [imageData base64EncodedDataWithOptions:0];

        if (self.mainImageSet == NO) {
            self.stringImageDataMain = [imageData base64EncodedStringWithOptions:0];
            self.imageMerchantLogo = self.imageMerchantPhoto;
        }
        else
        {
            NSString *stringImageData = [imageData base64EncodedStringWithOptions:0];
            [self.arrayOfBusinessPhotos addObject:stringImageData];
        }

        // Pictures taken from camera shot are stored to device
        if (self.imagePicker.sourceType == UIImagePickerControllerSourceTypeCamera)
        {
            //Save to Photos Album
            UIImageWriteToSavedPhotosAlbum(self.imageMerchantPhoto, nil, nil, nil);
        }

        NSLog(@"Photo: %@",self.photoReference);
    }

    [self dismissViewControllerAnimated:YES completion:^{
        if ([self.photoReference isEqualToString:@"merchantIcon"]) {

            self.imageviewEditShop.image = [Utility squareImageFromImage:self.imageMerchantPhoto scaledToSize:80];
            self.imageviewEditShop.layer.cornerRadius = self.imageviewEditShop.frame.size.height /2;
            self.imageviewEditShop.layer.masksToBounds = YES;
            self.imageviewEditShop.layer.borderWidth = 0;

            self.viewMerchantPhotos.imageViewFirstMerchantPhoto.alpha = 1;
            [self.viewMerchantPhotos.imageViewFirstMerchantPhoto setUserInteractionEnabled:YES];
            self.viewMerchantPhotos.imageViewSecondMerchantPhoto.alpha = 1;
            [self.viewMerchantPhotos.imageViewSecondMerchantPhoto setUserInteractionEnabled:YES];
            self.viewMerchantPhotos.imageViewThirdMerchantPhoto.alpha = 1;
            [self.viewMerchantPhotos.imageViewThirdMerchantPhoto setUserInteractionEnabled:YES];
            self.viewMerchantPhotos.imageViewFourthMerchantPhoto.alpha = 1;
            [self.viewMerchantPhotos.imageViewFourthMerchantPhoto setUserInteractionEnabled:YES];

            self.mainImageSet = YES;
        }
        else
        {
        [self.viewMerchantPhotos setBusinessPhoto:self.imageMerchantPhoto photoReference:self.photoReference];
        }
        self.photoReference = @"";
    }];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{
        self.photoReference = @"";
    }];
}

#pragma mark - Tap Gesture Methods

-(void)addMerchantIcon:(UIGestureRecognizer*)gesture
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Add Merchant Photo" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo",@"Choose Existing",@"Remove Photo", nil];
    [actionSheet showInView:self.view];
}

#pragma mark UIAction Sheet Methods

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self setupCamera:@"merchantIcon"];
    }
    else if (buttonIndex == 1)
    {
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self setupLibrary:@"merchantIcon"];

    }
    else if (buttonIndex == 2)
    {
        self.imageviewEditShop.image = [UIImage imageNamed:@"EditShop"];
        self.mainImageSet = NO;
    }

}


@end
