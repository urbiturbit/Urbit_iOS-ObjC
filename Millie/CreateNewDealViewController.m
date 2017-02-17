//
//  CreateNewDealViewController.m
//  Millie
//
//  Created by Emmanuel Masangcay on 6/16/15.
//  Copyright (c) 2015 CoderEXP. All rights reserved.
//

#import "CreateNewDealViewController.h"
#import "MerchantLabelHeaders.h"
#import "UIColor+HEX.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "CreateNewDealFormViewController.h"
#import "LoyaltyCreateDealViewController.h"
#import "Utility.h"
#import "MillieAPIClient.h"
#import "MillieLabel.h"
#import "DealConfirmationViewController.h"
#import "DealPreviewViewController.h"
#import "User.h"
#import "M_CustomTabBarController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <SDWebImage/UIImageView+WebCache.h>


@interface CreateNewDealViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,CLLocationManagerDelegate>


@property UIImagePickerController *imagePicker;
@property UIImage *imageDealPhoto;
@property UIView *viewActionCreateDeal;
@property UIButton *btnNextAction;
@property UILabel *labelConfirmDealPost;
@property UILabel *labelOK;
@property CGFloat heightOfActionButton;
@property CreateNewDealFormViewController *cNDFVC;
@property LoyaltyCreateDealViewController *lCDVC;
@property DealPreviewViewController *dPVC;
@property DealConfirmationViewController *dCVC;
@property UIView *viewAlertMessage;
@property (strong, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *viewScrollViewMain;

@property NSString *businessName;
@property NSString *stringImageData;
@property NSString *startDate;
@property NSString *finishDate;
@property NSString *startDateSave;
@property NSString *finishDateSave;
@property User *currentUser;

@property (strong, nonatomic) IBOutlet MerchantLabelHeaders *labelCreateDeal;
@property (strong, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *scrollViewCreateNewDeal;
@property (strong, nonatomic) IBOutlet UIView *viewCreatNewDealMainForm;
@property (strong, nonatomic) IBOutlet UIButton *buttonCancelCreateNewDealForm;

@property CLGeocoder *location;
@property NSString *dealZip;

@property UITapGestureRecognizer *tapScrollView ;

@property UIView *loadingview ;
@property UIActivityIndicatorView *mannyFresh;
@property MillieLabel *posting;

@end

@implementation CreateNewDealViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self buildUI];


    NSArray *arrayOfBusinessImage = [self.currentUser.business objectForKey:@"images"];

    for (int i = 0; i < arrayOfBusinessImage.count; i++)
    {

        NSNumber * isSuccessNumber = (NSNumber *)[[[arrayOfBusinessImage objectAtIndex:i]objectForKey:@"image"]objectForKey:@"main_image"];
        if([isSuccessNumber boolValue] == YES)
        {
            NSURL *imageURL = [[arrayOfBusinessImage objectAtIndex:i]objectForKey:@"image_url"];

            SDWebImageManager *manager = [SDWebImageManager sharedManager];
            [manager downloadImageWithURL:imageURL
                                  options:0
                                 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                     // progression tracking code
                                 }
                                completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                    if (image) {

                                        self.currentUser.businessProfilePic = image;
                                    }
                                }];
        }

        else
        {
            self.currentUser.businessProfilePic = [UIImage imageNamed:@"EditShop"];
        }

    }




}


-(void)buildUI
{
    self.currentUser = [User sharedSingleton];

    //Hide Nav Bar
    [self.navigationController.navigationBar setHidden:YES];

    //To make the border look very close to a UITextField
    [self.textViewDealDescription.layer setBorderColor:[[[UIColor colorwithHexString:@"334d5c" alpha:1 ] colorWithAlphaComponent:1] CGColor]];
    [self.textViewDealDescription.layer setBorderWidth:1.0];

    //******* Set TapGesture Recognizers *******//
    UITapGestureRecognizer *tapUploadDealPhoto = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addDealPhoto:)];
    tapUploadDealPhoto.numberOfTapsRequired = 1;
    tapUploadDealPhoto.numberOfTouchesRequired = 1;

    self.imageViewDealPhoto.userInteractionEnabled = YES;
    [self.imageViewDealPhoto addGestureRecognizer:tapUploadDealPhoto];

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
    self.btnNextAction = [UIButton new];
    [self.btnNextAction setTitle:@"NEXT" forState:UIControlStateNormal];
    [self.btnNextAction setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnNextAction.titleLabel setFont:[UIFont fontWithName:@"ProximaNova-Semibold" size:24]];;
    [self.btnNextAction.titleLabel setTextAlignment:NSTextAlignmentCenter];

//    // Setup Button Appearance
//    CALayer *layerNext = self.btnNextAction.layer;
//    //     layerNext.borderColor = [[UIColor blackColor]CGColor];
//    layerNext.borderWidth = 0.5f;

    //Set the frame
    CGRect btnNextActionFrame = CGRectMake(-1, 1, self.viewActionCreateDeal.frame.size.width+2, self.viewActionCreateDeal.frame.size.height);
    self.btnNextAction.frame = btnNextActionFrame;

    [self.btnNextAction addTarget:self
                           action:@selector(clickNextAction)
                 forControlEvents:UIControlEventTouchUpInside];

    [self.viewActionCreateDeal addSubview:self.btnNextAction];
    [self.view addSubview:self.viewActionCreateDeal];


    //UILABEL CONFIRM DEAL POST
    self.labelConfirmDealPost = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.viewActionCreateDeal.frame.size.width, self.viewActionCreateDeal.frame.size.height)];
    self.labelConfirmDealPost.text = @"CONFIRM DEAL POST";
    self.labelConfirmDealPost.numberOfLines = 0;
    self.labelConfirmDealPost.textColor = [UIColor whiteColor];
    [self.labelConfirmDealPost setFont:[UIFont fontWithName:@"ProximaNova-Semibold" size:24]];
    self.labelConfirmDealPost.textAlignment = NSTextAlignmentCenter;
    self.labelConfirmDealPost.backgroundColor = [UIColor clearColor];
    self.labelConfirmDealPost.alpha = 0;

    //******* Set TapGesture Recognizers *******//
    UITapGestureRecognizer *tapConfirmDealPost = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapConfirmDealPost:)];
    tapUploadDealPhoto.numberOfTapsRequired = 1;
    tapUploadDealPhoto.numberOfTouchesRequired = 1;

    self.labelConfirmDealPost.userInteractionEnabled = YES;
    [self.labelConfirmDealPost addGestureRecognizer:tapConfirmDealPost];

    //UILABEL OK
    self.labelOK = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.viewActionCreateDeal.frame.size.width, self.viewActionCreateDeal.frame.size.height)];
    self.labelOK .text = @"OK";
    self.labelOK .numberOfLines = 0;
    self.labelOK .textColor = [UIColor whiteColor];
    [self.labelOK  setFont:[UIFont fontWithName:@"raleway" size:24]];
    self.labelOK .textAlignment = NSTextAlignmentCenter;
    self.labelOK .backgroundColor = [UIColor clearColor];
    self.labelOK .alpha = 0;

    //******* Set TapGesture Recognizers *******//
    UITapGestureRecognizer *tapOKDealPost = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapOKDealPost:)];
    tapUploadDealPhoto.numberOfTapsRequired = 1;
    tapUploadDealPhoto.numberOfTouchesRequired = 1;

    self.labelOK.userInteractionEnabled = YES;
    [self.labelOK addGestureRecognizer:tapOKDealPost];


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
    self.posting.text = @"Posting...";

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

// Clicking off any controls will close the keypad
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self closeAlertMessage];
    [self.btnNextAction setEnabled:YES];
    [self.scrollViewCreateNewDeal endEditing:YES];
}

#pragma mark - UITapGesture Methods
-(void)addDealPhoto:(UIGestureRecognizer *)gesture
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Add Merchant Photo" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo",@"Choose Existing", nil];
    [actionSheet showInView:self.view];
}


#pragma mark UIAction Sheet Methods

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        self.imagePicker = [[UIImagePickerController alloc]init];
        self.imagePicker.delegate = self;
        self.imagePicker.allowsEditing = YES;
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        self.imagePicker.mediaTypes =  [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];

        [self presentViewController:self.imagePicker animated:YES completion:^{

        }];
    }
    else if (buttonIndex == 1)
    {
        self.imagePicker = [[UIImagePickerController alloc]init];
        self.imagePicker.delegate = self;
        self.imagePicker.allowsEditing = YES;
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        UIColor *backgroundColor = [UIColor colorWithRed:0.38 green:0.51 blue:0.85 alpha:1.0];
        self.imagePicker.navigationBar.barTintColor = backgroundColor;
        self.imagePicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:self.imagePicker.sourceType];
        [self presentViewController:self.imagePicker animated:YES completion:^{

        }];
    }
}

#pragma mark - UIImagePicker Methods

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];

    if ([mediaType isEqualToString:(NSString *)kUTTypeImage])
    {
        self.imageDealPhoto = [info objectForKey:UIImagePickerControllerOriginalImage];

        NSData *imageData =  UIImagePNGRepresentation([info objectForKey:UIImagePickerControllerOriginalImage]);

        [imageData base64EncodedDataWithOptions:0];

        self.stringImageData = [imageData base64EncodedStringWithOptions:0];

        // Pictures taken from camera shot are stored to device
        if (self.imagePicker.sourceType == UIImagePickerControllerSourceTypeCamera)
        {
            //Save to Photos Album
            UIImageWriteToSavedPhotosAlbum(self.imageDealPhoto, nil, nil, nil);
        }

        UIImage *imageEdit = info[UIImagePickerControllerEditedImage];
        imageEdit = [Utility scaleImage:imageEdit toSize:CGSizeMake(375,98)];


        self.imageViewDealPhoto.image = imageEdit;
    }

    [self dismissViewControllerAnimated:YES completion:^{

    }];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

#pragma mark - Action Button Method

-(void)clickNextAction
{
    if (self.imageDealPhoto == nil){

        [self.btnNextAction setEnabled:NO];
        [self presentAlertMessage:@"YOU MUST HAVE A DEAL PHOTO TO POST A DEAL!"];
    }
    else if ([self.textFieldDealTitle.text isEqual:@""])
    {
        [self.btnNextAction setEnabled:NO];
        [self presentAlertMessage:@"YOU MUST HAVE A DEAL TITLE TO POST A DEAL!"];
    }
    else if ([self.textViewDealDescription.text isEqual:@""])
    {
        [self.btnNextAction setEnabled:NO];
        [self presentAlertMessage:@"YOU MUST HAVE A DEAL DESCRIPTION TO POST A DEAL!"];
    }

    else
    {

    NSLog(@"Next Action");
    if (self.viewCreatNewDealMainForm.alpha == 1)
    {

        [self showCreateNewDealForm];
    }
    else if(self.cNDFVC.view.alpha == 1)
    {
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"cccc, MMM d, hh:mm aa"];

        self.startDate = [dateFormat stringFromDate:self.cNDFVC.datePickerStart.date];
        self.finishDate = [dateFormat stringFromDate:self.cNDFVC.datePickerFinish.date];
        NSLog(@"date is >>> , %@",self.startDate);
        NSLog(@"date is >>> , %@",self.finishDate);

        [self showCreateLoyaltyNewDeal];

    }
    else if(self.lCDVC.view.alpha ==1)
    {
        [self showDetailPreview];
    }

    }
}
- (IBAction)buttonCancelCreateNewDealForm:(id)sender
{

    if (self.labelConfirmDealPost.alpha == 1)
    {
        [self closeDealPreview];
    }

  else if (self.cNDFVC.view.alpha == 0 ){
        [self CancelCreateLoyaltyNewDeal];
    }

    else
    {
        [self closeCreateNewDealForm];
    }
}


-(void)tapConfirmDealPost:(UITapGestureRecognizer*)gesture
{

    self.labelConfirmDealPost.userInteractionEnabled = NO;

    NSString *tC = self.cNDFVC.textViewTermsConditions.text;
    NSString *level = self.lCDVC.loyaltyLevel;


    NSString *businessCategory;
    NSNumber *businessID;

    if (self.currentUser.business.count == 12)
        {
            businessCategory = [self.currentUser.business objectForKey:@"type_of_business"];
            businessID = [self.currentUser.business objectForKey:@"id"];
        }
    else
    {
        businessCategory = [[self.currentUser.business objectForKey:@"Business" ] objectForKey:@"type_of_business"];
        businessID = [[self.currentUser.business objectForKey:@"Business" ] objectForKey:@"id"];
    }




    NSString *description = self.textViewDealDescription.text;
    NSString *title = self.textFieldDealTitle.text;

    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *quantity = [f numberFromString:self.cNDFVC.textFieldQuantity.text];

    NSString *token = [Lockbox stringForKey:@"token"];

    self.loadingview.alpha = .75;
    self.buttonCancelCreateNewDealForm.alpha = 0;

    [MillieAPIClient postDeals:token startTime:self.startDateSave expirationTime:self.finishDateSave termsAndCondition:tC quantity:quantity dealLevel:level category:businessCategory zip:self.dealZip businessID:businessID dealDescripton:description dealTitle:title completion:^(NSDictionary *result)
    {

        NSLog(@"Result:%@",result);
        NSString *dealID = [result objectForKey:@"id"];

        NSNumber *main = [NSNumber numberWithInt:0];

    [MillieAPIClient postImage:token businessID:nil dealID:dealID userID:nil type:@"deal" photoData:self.stringImageData mainImage:main completion:^(NSDictionary *result) {
        NSLog(@"Deal Posted");
        self.loadingview.alpha = 0;
        [self showDealConfirm];
    }];

    }];

}

-(void)tapOKDealPost:(UITapGestureRecognizer*)gesture
{
    NSLog(@"OK");

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    M_CustomTabBarController *tab=[storyboard instantiateViewControllerWithIdentifier:@"merchantTab"];

    [self.navigationController presentViewController:tab animated:YES completion:nil];

}

#pragma mark - Animation Methods

-(void)showCreateNewDealForm
{
    // ******** Create New Deal Form View ******** //

    if (!self.cNDFVC) {
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        self.cNDFVC = [mainStoryBoard instantiateViewControllerWithIdentifier:@"CreateNewDealForm"];

        CGFloat sizeDifference = self.tabBarController.tabBar.frame.size.height + self.heightOfActionButton;

        CGRect createNewDealFrame = CGRectMake(0, self.labelCreateDeal.frame.size.height + 10, self.scrollViewCreateNewDeal.frame.size.width, self.view.frame.size.height - sizeDifference);

        self.cNDFVC.view.frame = createNewDealFrame;

        [self.scrollViewCreateNewDeal addSubview:self.cNDFVC.view];
        self.cNDFVC.view.alpha = 0;
    }

    [Utility animateView_downHide_showLeft_fade:self.cNDFVC.view hideView:self.viewCreatNewDealMainForm withViewAlphaAnimate:self.buttonCancelCreateNewDealForm completion:^(BOOL result) {
        [self.scrollViewCreateNewDeal bringSubviewToFront:self.viewActionCreateDeal];
    }];
}

-(void)closeCreateNewDealForm
{
    [Utility animateView_upShow_hideRight:self.viewCreatNewDealMainForm hideView:self.cNDFVC.view withViewAlphaAnimate:self.buttonCancelCreateNewDealForm completion:^(BOOL result) {
        [self.scrollViewCreateNewDeal bringSubviewToFront:self.viewActionCreateDeal];
    }];
}

-(void)showCreateLoyaltyNewDeal
{
    // ******** Create New Deal Form View ******** //
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.lCDVC = [mainStoryBoard instantiateViewControllerWithIdentifier:@"CreateLoyaltyDeal"];

    CGFloat sizeDifference = self.tabBarController.tabBar.frame.size.height + self.heightOfActionButton;

    CGRect createNewDealFrame = CGRectMake(0, self.labelCreateDeal.frame.size.height + 10, self.scrollViewCreateNewDeal.frame.size.width, self.view.frame.size.height - sizeDifference);

    self.lCDVC.view.frame = createNewDealFrame;

    [self.scrollViewCreateNewDeal addSubview:self.lCDVC.view];
    self.lCDVC.view.alpha = 0;

    [Utility animateView_downHide_showLeft_fade:self.lCDVC.view hideView:self.cNDFVC.view withViewAlphaAnimate:nil completion:^(BOOL result) {
        [self.scrollViewCreateNewDeal bringSubviewToFront:self.viewActionCreateDeal];
    }];

}

-(void)CancelCreateLoyaltyNewDeal
{
    [Utility animateView_upShow_hideRight:self.cNDFVC.view hideView:self.lCDVC.view withViewAlphaAnimate:self.lCDVC.view completion:^(BOOL result) {
        self.cNDFVC.view.alpha = 1;
        [self.scrollViewCreateNewDeal bringSubviewToFront:self.viewActionCreateDeal];
    }];
}

-(void)showDetailPreview
{

    CLLocationDegrees longitude = [[[self.currentUser.business objectForKey:@"Business" ] objectForKey:@"longitude"]doubleValue];
    CLLocationDegrees latitude = [[[self.currentUser.business objectForKey:@"Business" ] objectForKey:@"latitude"]doubleValue];

    CLLocationCoordinate2D local = CLLocationCoordinate2DMake(latitude, longitude);

    CLLocation *location = [[CLLocation alloc]initWithCoordinate:local altitude:500 horizontalAccuracy:500 verticalAccuracy:500 timestamp:nil];

    [self reverseGeoCode: location];
    
    // ******** Create New Deal Form View ******** //
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.dPVC = [mainStoryBoard instantiateViewControllerWithIdentifier:@"DealPreview"];

    CGFloat sizeDifference = self.tabBarController.tabBar.frame.size.height + self.heightOfActionButton;

    CGRect createDealPreviewFrame = CGRectMake(0, self.labelCreateDeal.frame.size.height, self.scrollViewCreateNewDeal.frame.size.width, self.view.frame.size.height - sizeDifference);

    self.dPVC.view.frame = createDealPreviewFrame;

    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd hh:mm:ss a"];

    self.startDateSave = [dateFormat stringFromDate:self.cNDFVC.datePickerStart.date];
    self.finishDateSave = [dateFormat stringFromDate:self.cNDFVC.datePickerFinish.date];
    NSLog(@"SAVEdate is >>> , %@",self.startDateSave);
    NSLog(@"FINISHdate is >>> , %@",self.finishDateSave);


    if (self.currentUser.business.count == 12) {

        self.dPVC.labelDealBusinessName.text = [self.currentUser.business objectForKey:@"name"];

    }
    else
    {
         self.dPVC.labelDealBusinessName.text = [[self.currentUser.business objectForKey:@"Business"]objectForKey:@"name"];
    }

    self.dPVC.labelDealDescription.text = self.textViewDealDescription.text;
    self.dPVC.labelDealValidDate.text = [NSString stringWithFormat:@"%@",self.startDate];
    self.dPVC.labelDealValidExpDate.text = [NSString stringWithFormat:@"%@",self.finishDate];

    self.dPVC.imageViewDealPhoto.image = self.imageDealPhoto;
    self.dPVC.imageViewDealBusiness.image = self.currentUser.businessProfilePic;
    self.dPVC.imageViewDealBusiness.layer.cornerRadius = self.dPVC.imageViewDealBusiness.frame.size.height /2;
    self.dPVC.imageViewDealBusiness.layer.masksToBounds = YES;

    [self.scrollViewCreateNewDeal addSubview:self.dPVC.view];
    self.dPVC.view.alpha = 0;


[Utility animateView_downHide_showLeft_fade:self.dPVC.view hideView:self.lCDVC.view withViewAlphaAnimate:nil completion:^(BOOL result) {
    [self.viewActionCreateDeal addSubview:self.labelConfirmDealPost];
    self.labelConfirmDealPost.transform = CGAffineTransformMakeTranslation(0, 300);
    [self.scrollViewCreateNewDeal bringSubviewToFront:self.viewActionCreateDeal];
    [UIView animateWithDuration:0.2f delay:0.f options:UIViewAnimationOptionCurveEaseIn animations:^{

        self.labelConfirmDealPost.alpha = 1;
        self.labelConfirmDealPost.transform = CGAffineTransformMakeTranslation(0, 200);
        self.btnNextAction.transform = CGAffineTransformMakeTranslation(0, 300);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2f delay:0.f options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.labelConfirmDealPost.transform = CGAffineTransformMakeTranslation(0, 0);
            self.labelCreateDeal.text = @"DEAL PREVIEW";
            self.labelCreateDeal.alpha = 1;

        } completion:^(BOOL finished) {

        }];
    }];
}];
}
-(void)closeDealPreview
{
    [Utility animateView_upShow_hideRight:self.lCDVC.view hideView:self.dPVC.view withViewAlphaAnimate:nil completion:^(BOOL result) {

    }];

    [UIView animateKeyframesWithDuration:0.8/4 delay:0 options:0 animations:^{

        self.labelConfirmDealPost.transform = CGAffineTransformMakeTranslation(0, 0);
        self.btnNextAction.transform = CGAffineTransformMakeTranslation(0, 300);

    } completion:^(BOOL finished) {
        [UIView animateKeyframesWithDuration:0.8/4 delay:.7 options:0 animations:^{

            self.labelConfirmDealPost.transform = CGAffineTransformMakeTranslation(0, 200);
            self.btnNextAction.transform = CGAffineTransformMakeTranslation(0, 0);

        } completion:^(BOOL finished) {

             self.labelConfirmDealPost.transform = CGAffineTransformMakeTranslation(0, 0);
            self.labelConfirmDealPost.alpha = 0;
            self.labelCreateDeal.text = @"CREATE NEW DEAL";


        }];
    }];

}

-(void)showDealConfirm
{
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.dCVC = [mainStoryBoard instantiateViewControllerWithIdentifier:@"DealConfirmation"];
    self.dCVC.dealBusinessName = self.dPVC.labelDealBusinessName.text;
    self.dCVC.dealDescription = self.textViewDealDescription.text;
    self.dCVC.dealValidDate = self.dPVC.labelDealValidDate.text;

    CGFloat sizeDifference = self.tabBarController.tabBar.frame.size.height + self.heightOfActionButton;

    CGRect createDealConfirmationFrame = CGRectMake(0, self.labelCreateDeal.frame.size.height + 10, self.scrollViewCreateNewDeal.frame.size.width, self.view.frame.size.height - sizeDifference);

    self.dCVC.view.frame = createDealConfirmationFrame;

    [self.scrollViewCreateNewDeal addSubview:self.dCVC.view];
    self.dCVC.view.alpha = 0;

    self.dPVC.view.layer.borderColor = [[UIColor blackColor] CGColor];
    self.dPVC.view.layer.borderWidth = 1.0f;

    [Utility setRoundedView:self.dPVC.view toDiameter:self.dPVC.view.frame.size.height];

    self.labelCreateDeal.alpha = 0;
    self.buttonCancelCreateNewDealForm.alpha = 0;
    self.labelCreateDeal.text = @"DEAL CONFIRMATION";

    [Utility animateView_scaleshow_scaleHide:self.dCVC.view hideView:self.dPVC.view accessoryView:self.labelCreateDeal completion:^(BOOL result) {
        if (result) {
            [self.viewActionCreateDeal addSubview:self.labelOK];
            self.labelOK.transform = CGAffineTransformMakeTranslation(0, 300);
            [UIView animateWithDuration:0.2f delay:0.f options:UIViewAnimationOptionCurveEaseIn animations:^{
                self.labelOK.alpha = 1;
                self.labelOK.transform = CGAffineTransformMakeTranslation(0, 200);
                self.labelConfirmDealPost.transform = CGAffineTransformMakeTranslation(0, 300);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.2f delay:0.f options:UIViewAnimationOptionCurveEaseIn animations:^{
                    self.labelOK.transform = CGAffineTransformMakeTranslation(0, 0);
                } completion:^(BOOL finished) {
                    
                }];
            }];
        }
    }];
}

#pragma mark - Helper Methods

- (void)reverseGeoCode:(CLLocation *)location
{
    CLGeocoder * geoCoder = [CLGeocoder new];
    [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {

        if (error) {
            NSLog(@"%@",[error userInfo]);
        }
        else
        {
            CLPlacemark *placemark = [placemarks lastObject];
            NSLog(@"Postal code:%@",placemark.postalCode);
            self.dealZip = placemark.postalCode;
        }
    }];
}


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
                        self.viewScrollViewMain.transform = CGAffineTransformMakeTranslation(0, 50);
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
            self.viewScrollViewMain.transform = CGAffineTransformMakeTranslation(0, 0);
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


@end
