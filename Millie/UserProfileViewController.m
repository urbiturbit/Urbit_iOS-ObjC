 //
//  UserProfileViewController.m
//  Millie
//
//  Created by Emmanuel Masangcay on 6/28/15.
//  Copyright (c) 2015 CoderEXP. All rights reserved.
//

#import "UserProfileViewController.h"
#import "UIColor+HEX.h"
#import "MillieAPIClient.h"
#import "MerchantSetupViewController.h"
#import "M_CustomTabBarController.h"
#import "Utility.h"
#import "MillieButton.h"
#import "User.h"

@interface UserProfileViewController ()

//@property UIImageView *imageviewProfile;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewProfilePic;

@property UIImagePickerController *imagePicker;
@property UIView *viewActionCreateDeal;

@property MillieButton *btnAction;
@property CGFloat heightOfActionButton;
@property (strong, nonatomic) IBOutlet UILabel *labelProfileHeader;
@property (strong, nonatomic) IBOutlet UIButton *buttonSettings;
@property (strong, nonatomic) IBOutlet UILabel *labelUserEmail;

@property User *currentUser;

@end

@implementation UserProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setHidden:YES];
    self.currentUser = [User sharedSingleton];
    [self buildUI];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.labelUserEmail.text = self.currentUser.email;

    self.imageViewProfilePic.image = self.currentUser.userProfilePic;

    if (self.currentUser.userProfilePic == nil)
    {
        self.imageViewProfilePic.image = [UIImage imageNamed:@"profile"];
    }
    else
    {
        self.imageViewProfilePic.layer.cornerRadius = self.imageViewProfilePic.frame.size.height /2;
        self.imageViewProfilePic.layer.masksToBounds = YES;
    }

}

-(void)buildUI
{
    self.labelUserEmail.text = self.currentUser.email;
    // ******** ActionButtons On Bottom of View ******** //

    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;

    if (screenWidth == 375) {//iphone6
        self.heightOfActionButton = 50;
    }
    else if(screenWidth == 414){//iphone6+
        self.heightOfActionButton = 60 ;
    }
    else
    {
        self.heightOfActionButton = 40;
    }

    //ACTION VIEW
    float y = self.tabBarController.tabBar.frame.origin.y - self.heightOfActionButton;

    self.viewActionCreateDeal = [[UIView alloc]initWithFrame:CGRectMake(0, y, self.view.frame.size.width, self.heightOfActionButton)];
    self.viewActionCreateDeal.backgroundColor = [UIColor colorwithHexString:@"df5a49" alpha:1];

    //BUTTON NEXT
    self.btnAction = [MillieButton new];
    [self.btnAction setTitle:@"SWITCH TO BUSINESS/CREATE" forState:UIControlStateNormal];
    [self.btnAction setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnAction.titleLabel setFont:[UIFont fontWithName:@"ProximaNova-Semibold" size:18]];;
    [self.btnAction.titleLabel setTextAlignment:NSTextAlignmentCenter];
    self.btnAction.titleLabel.adjustsFontSizeToFitWidth = YES;

    // Setup Button Appearance
    CALayer *layerNext = self.btnAction.layer;
    //     layerNext.borderColor = [[UIColor blackColor]CGColor];
    layerNext.borderWidth = 0.5f;

    //Set the frame
    CGRect btnNextActionFrame = CGRectMake(-1, 1, self.viewActionCreateDeal.frame.size.width+2, self.viewActionCreateDeal.frame.size.height);
    self.btnAction.frame = btnNextActionFrame;

    [self.btnAction addTarget:self
                           action:@selector(switchToBusinessCreate)
                 forControlEvents:UIControlEventTouchUpInside];

    [self.viewActionCreateDeal addSubview:self.btnAction];
    [self.view addSubview:self.viewActionCreateDeal];
}

-(void)switchToBusinessCreate
{
    NSLog(@"Switch To Business/Create");

    NSString *token = [Lockbox stringForKey:@"token"];
    [MillieAPIClient getBusiness:token completion:^(NSDictionary *result) {
        if ([[result objectForKey:@"businesses"]count] == 0) {
            [self performSegueWithIdentifier:@"pushToMerchantSetup" sender:nil];
        }
        else
        {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            M_CustomTabBarController *tab=[storyboard instantiateViewControllerWithIdentifier:@"merchantTab"];
            self.currentUser.business = [[result objectForKey:@"businesses"]objectAtIndex:0];
          
            [self.navigationController presentViewController:tab animated:YES completion:nil];
        }
    }];

}

- (IBAction)buttonPressSettings:(id)sender
{
    [self performSegueWithIdentifier:@"showUserProfileSettings" sender:nil];
}

- (IBAction)buttonPressEditProfile:(id)sender {
    [self performSegueWithIdentifier:@"showEditUserProfile" sender:nil];
}

#pragma mark - Segue Methods
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"pushToMerchantSetup"])
    {
    MerchantSetupViewController *mSVC = [segue destinationViewController];
    mSVC.setUpFrom = @"UserProfile";

    }
}
@end
