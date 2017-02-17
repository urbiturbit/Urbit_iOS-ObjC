//
//  BusinessProfileViewController.m
//  Millie
//
//  Created by Emmanuel Masangcay on 7/4/15.
//  Copyright (c) 2015 CoderEXP. All rights reserved.
//

#import "BusinessProfileViewController.h"
#import "BusinessProfileTableViewCell.h"
#import "User.h"
#import "M_CustomTabBarController.h"
#import "MillieAPIClient.h"
#import "Utility.h"
#import "MillieLabel.h"
#import "UIColor+HEX.h"
#import "Image.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <SDWebImage/UIImageView+WebCache.h>


@interface BusinessProfileViewController ()<UITableViewDataSource, UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableViewBusinessInfo;

@property (strong, nonatomic) IBOutlet UIImageView *imageViewBusinessProfileImage;
@property (strong, nonatomic) IBOutlet MillieLabel *labelBusinessName;
@property User *currentUser;
@property (strong, nonatomic) IBOutlet UIButton *buttonEdit;

@property UIImageView *imageViewPhoto1;
@property UIImageView *imageViewPhoto2;
@property UIImageView *imageViewPhoto3;
@property UIImageView *imageViewPhoto4;


@property UIImagePickerController *imagePicker;
@property UIImage *businessPic;
@property NSString *stringImageData;
@property NSString *photoReference;
@property UITextView *textViewBusinessDescription;
@property UITextView *textViewBusinessAddr;
@property UITextField *textFieldBusinessPhone;
@property UITextField *textFieldBusinessHours;

@property NSDictionary *image;

@property BOOL mainImageSet;
@property BOOL imageEdit;
@property NSMutableArray *arrayOfBusinessPhotos;
@property NSString *stringImageDataMain;
@property NSMutableArray *arrayOfImageIDs;
@property int imageCount;
@property BOOL mainImage;

@property BOOL mainImageDelete;

@property Image *mainBusinessImage;
@property Image *businessImage1;
@property Image *businessImage2;
@property Image *businessImage3;
@property Image *businessImage4;

@property NSMutableArray *arrayOfDeleteImageIDs;
@property NSMutableArray *arrayOfEditImages;
@property NSMutableArray *arrayOfImages;
@property NSMutableArray *arrayOfOrderedImages;

@property int deleteCount;
@property int addCount;

@property UIImage *imageMain;
@property UIImage *imagePhoto1;
@property UIImage *imagePhoto2;
@property UIImage *imagePhoto3;
@property UIImage *imagePhoto4;

@property UIView *loadingview ;
@property UIActivityIndicatorView *mannyFresh;
@property MillieLabel *posting;

@end

@implementation BusinessProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.mainImageDelete = NO;

    self.arrayOfBusinessPhotos = [NSMutableArray new];
    self.arrayOfImageIDs = [NSMutableArray new];
    self.arrayOfDeleteImageIDs = [NSMutableArray new];
    self.arrayOfEditImages = [NSMutableArray new];
    self.arrayOfImages = [NSMutableArray new];
    self.arrayOfOrderedImages = [NSMutableArray new];


    self.currentUser = [User sharedSingleton];
    [self.navigationController.navigationBar setHidden:YES];

    [self buildUI];

    NSArray *images = [self.currentUser.business objectForKey:@"images"];

    //ReOrder Array
    for (int y= 0; y<images.count;  y++) {
        NSNumber * isSuccessNumber = (NSNumber *)[[[images objectAtIndex:y] objectForKey: @"image"]objectForKey:@"main_image"];
        if([isSuccessNumber boolValue] == YES)
        {
            [self.arrayOfOrderedImages addObject:[images objectAtIndex:y]];
        }
        else
        {
            [self.arrayOfOrderedImages addObject:[images objectAtIndex:y]];
        }
    }

    for (int i =0; i<self.arrayOfOrderedImages.count;i++)
        {

            NSString *stringImageMain = [[self.arrayOfOrderedImages objectAtIndex:i] objectForKey:@"image_url"];
            NSURL *urlImageMain = [NSURL URLWithString:stringImageMain];
            NSString *stringImageID = [[[images objectAtIndex:i] objectForKey:@"image"]objectForKey:@"id"];


            SDWebImageManager *manager = [SDWebImageManager sharedManager];
            [manager downloadImageWithURL:urlImageMain
                                  options:0
                                 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                     // progression tracking code
                                 }
                                completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                    if (image)
                                    {
                                        [self.arrayOfImages addObject:image];

                                        if (self.arrayOfImages.count == images.count) {
                                            NSLog(@"Images:%@",self.arrayOfImages);

                                            for (int x = 0 ; x<self.arrayOfImages.count; x++) {
                                                if (self.imageMain == nil) {
                                                    self.imageMain = [self.arrayOfImages objectAtIndex:x];
                                                     self.imageViewBusinessProfileImage.image = self.imageMain;
                                                }
                                                else if (self.imagePhoto1 == nil)
                                                {
                                                    self.imagePhoto1 = [self.arrayOfImages objectAtIndex:x];
                                                    self.imageViewPhoto1.image = self.imagePhoto1;

                                                }
                                                else if (self.imagePhoto2 == nil)
                                                {
                                                    self.imagePhoto2 = [self.arrayOfImages objectAtIndex:x];
                                                    self.imageViewPhoto2.image = self.imagePhoto2;

                                                }
                                                else if (self.imagePhoto3 == nil)
                                                {
                                                    self.imagePhoto3 = [self.arrayOfImages objectAtIndex:x];
                                                    self.imageViewPhoto3.image = self.imagePhoto3;

                                                }
                                                else if (self.imagePhoto4 == nil)
                                                {
                                                    self.imagePhoto4 = [self.arrayOfImages objectAtIndex:x];
                                                    self.imageViewPhoto4.image = self.imagePhoto4;
                                                }}}}}];}
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.labelBusinessName.text = [[self.currentUser.business objectForKey:@"Business"]objectForKey:@"name"];
}

-(void)buildUI
{
    self.imageViewPhoto1 = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x + 30, self.view.frame.origin.y + 15, 150, 150)];
    self.imageViewPhoto2.image = [UIImage imageNamed:@"Upload"];
    self.imageViewPhoto1.image = self.imagePhoto1;
    self.imageViewPhoto1.contentMode = UIViewContentModeCenter;
    self.imageViewPhoto1.contentMode = UIViewContentModeScaleToFill;

    self.imageViewPhoto2 = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x + 20 + self.imageViewPhoto1.frame.size.width+30, self.view.frame.origin.y + 15, 150, 150)];
        self.imageViewPhoto2.image = [UIImage imageNamed:@"Upload"];
    self.imageViewPhoto2.image = self.imagePhoto2;
    self.imageViewPhoto2.contentMode = UIViewContentModeCenter;
    self.imageViewPhoto2.contentMode = UIViewContentModeScaleToFill;

    self.imageViewPhoto3 = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x + 30, self.view.frame.origin.y + 15 + self.imageViewPhoto1.frame.size.height + 20, 150, 150)];
        self.imageViewPhoto3.image = [UIImage imageNamed:@"Upload"];
    self.imageViewPhoto3.image = self.imagePhoto3;

    self.imageViewPhoto3.contentMode = UIViewContentModeCenter;
    self.imageViewPhoto3.contentMode = UIViewContentModeScaleToFill;

    self.imageViewPhoto4 = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x + 20 + self.imageViewPhoto3.frame.size.width+30, self.view.frame.origin.y + 15 + self.imageViewPhoto1.frame.size.height + 20, 150, 150)];
        self.imageViewPhoto4.image = [UIImage imageNamed:@"Upload"];
    self.imageViewPhoto4.image = self.imagePhoto4;

    self.imageViewPhoto4.contentMode = UIViewContentModeCenter;
    self.imageViewPhoto4.contentMode = UIViewContentModeScaleToFill;

    //UITextView
    self.textViewBusinessDescription = [[UITextView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x + 10, self.view.frame.origin.y + 5, self.view.frame.size.width - 10, 100)];
    self.textViewBusinessDescription.text = [[self.currentUser.business objectForKey:@"Business"]objectForKey:@"description"];
    [self.textViewBusinessDescription setFont:[UIFont fontWithName:@"ProximaNova-Semibold" size:20]];
    [self.textViewBusinessDescription setEditable:NO];


    [self.imageViewPhoto1 setUserInteractionEnabled:NO];
    [self.imageViewPhoto2 setUserInteractionEnabled:NO];
    [self.imageViewPhoto3 setUserInteractionEnabled:NO];
    [self.imageViewPhoto4 setUserInteractionEnabled:NO];
    [self.imageViewBusinessProfileImage setUserInteractionEnabled:NO];

    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapPhoto1:)];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapPhoto2:)];
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapPhoto3:)];
    UITapGestureRecognizer *tap4 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapPhoto4:)];
    UITapGestureRecognizer *tapMain = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapPhotoMain:)];

    [self.imageViewPhoto1 addGestureRecognizer:tap1];
    [self.imageViewPhoto2 addGestureRecognizer:tap2];
    [self.imageViewPhoto3 addGestureRecognizer:tap3];
    [self.imageViewPhoto4 addGestureRecognizer:tap4];
    [self.imageViewBusinessProfileImage addGestureRecognizer:tapMain];

    self.imageViewBusinessProfileImage.layer.cornerRadius = self.imageViewBusinessProfileImage.frame.size.height /2;
    self.imageViewBusinessProfileImage.layer.masksToBounds = YES;

    //Business Info

    self.textViewBusinessAddr = [[UITextView alloc]initWithFrame:CGRectMake(5, 25, self.view.frame.size.width, 50)];

    self.textViewBusinessAddr.text = [[self.currentUser.business objectForKey:@"Business"]objectForKey:@"address"];

    [self.textViewBusinessAddr setFont:[UIFont fontWithName:@"ProximaNova-Regular" size:17]];
    [self.textViewBusinessAddr setTextAlignment:NSTextAlignmentCenter];
    [self.textViewBusinessAddr setEditable:NO];

    self.textFieldBusinessPhone = [[UITextField alloc]initWithFrame:CGRectMake(0, self.textViewBusinessAddr.frame.size.height, self.view.frame.size.width, 100)];
    self.textFieldBusinessPhone.textAlignment = NSTextAlignmentCenter;
    self.textFieldBusinessPhone.text = [[self.currentUser.business objectForKey:@"Business"] objectForKey:@"phone"];
    [self.textFieldBusinessPhone setFont:[UIFont fontWithName:@"ProximaNova-Regular" size:17]];
    NSAttributedString *str2 = [[NSAttributedString alloc] initWithString:self.textFieldBusinessPhone.text attributes:@{ NSForegroundColorAttributeName : [UIColor colorwithHexString:@"334d5c" alpha:1],NSKernAttributeName : @(1.5f) }];
    [self.textFieldBusinessPhone setAttributedText:str2];
    [self.textFieldBusinessPhone setEnabled:NO];

    self.textFieldBusinessHours = [[UITextField alloc]initWithFrame:CGRectMake(0, self.textFieldBusinessPhone.frame.size.height, self.view.frame.size.width, 100)];
    self.textFieldBusinessHours.textAlignment = NSTextAlignmentCenter;
    self.textFieldBusinessHours.text = [[self.currentUser.business objectForKey:@"Business"] objectForKey:@"hours_of_operation"];
    [self.textFieldBusinessHours setFont:[UIFont fontWithName:@"ProximaNova-Regular" size:17]];
    NSAttributedString *str3 = [[NSAttributedString alloc] initWithString:self.textFieldBusinessHours.text attributes:@{ NSForegroundColorAttributeName : [UIColor colorwithHexString:@"334d5c" alpha:1],NSKernAttributeName : @(1.5f) }];
    [self.textFieldBusinessHours setAttributedText:str3];
    [self.textFieldBusinessHours setEnabled:NO];

    [self.tableViewBusinessInfo reloadData];

    self.mannyFresh = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x + 10 , self.view.frame.origin.y + 10, 20, 20)];
    self.mannyFresh.tintColor = [UIColor whiteColor];
    self.mannyFresh.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [self.mannyFresh startAnimating];

    self.posting = [[MillieLabel alloc]initWithFrame:CGRectMake(self.mannyFresh.frame.origin.x + 40, self.mannyFresh.frame.origin.y, 100, 30)];
    self.posting.textColor = [UIColor whiteColor];
    [self.posting setFont:[UIFont fontWithName:@"ProximaNova-Semibold" size:20]];
    self.posting.backgroundColor = [UIColor clearColor];
    self.posting.text = @"Updating...";

    [self.loadingview addSubview:self.mannyFresh];
    [self.loadingview addSubview:self.posting];

    self.loadingview.alpha = 0;

    [self.view addSubview:self.loadingview];

}

#pragma mark - UITableView Delegate Methods

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;

    if (screenWidth == 375) {//iphone6
        return 50;
    }
    else if(screenWidth == 320){//iphone5,5s
        return 40;
    }
    else if(screenWidth == 414){//iphone6+
        return 60;
    }
    else
    {
    return 0;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.section==0) {
        return 350;
    }
    else if (indexPath.section==1)
    {
        return 100;
    }
    else if (indexPath.section==2)
    {
        return 200;
    }
    else
    {
        return 0;
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"BUSINESS PHOTOS";
    }
    else if (section == 1)
    {
        return @"BUSINESS DESCRIPTION";
    }
    else if (section == 2)
    {
        return @"BUSINESS INFO";
    }

    return nil;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    BusinessProfileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"businessProfileCell"];

    if (indexPath.section==0) {

        [cell addSubview:self.imageViewPhoto1];
        [cell addSubview:self.imageViewPhoto2];
        [cell addSubview:self.imageViewPhoto3];
        [cell addSubview:self.imageViewPhoto4];

        return cell;
    }
    else if (indexPath.section==1)
    {
        [cell addSubview:self.textViewBusinessDescription];

        return cell;
    }
    else if (indexPath.section==2)
    {

        [cell addSubview:self.textViewBusinessAddr];
        [cell addSubview:self.textFieldBusinessPhone];
        [cell addSubview:self.textFieldBusinessHours];

        return cell;
    }
    else
    {
        return nil;
    }


}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 3;
}
- (IBAction)buttonOnPressEdit:(id)sender
{

    if ([self.buttonEdit.titleLabel.text isEqualToString:@"EDIT"])
    {
        [self.buttonEdit setTitle:@"SAVE" forState:UIControlStateNormal];

        [self.imageViewPhoto1 setUserInteractionEnabled:YES];
        [self.imageViewPhoto2 setUserInteractionEnabled:YES];
        [self.imageViewPhoto3 setUserInteractionEnabled:YES];
        [self.imageViewPhoto4 setUserInteractionEnabled:YES];
        [self.imageViewBusinessProfileImage setUserInteractionEnabled:YES];
        [self.textViewBusinessDescription setEditable:YES];
        [self.textViewBusinessAddr setEditable:YES];
        [self.textFieldBusinessPhone setEnabled:YES];
        [self.textFieldBusinessHours setEnabled:YES];



    }
    else if ([self.buttonEdit.titleLabel.text isEqualToString:@"SAVE"])
    {
        NSString *token = [Lockbox stringForKey:@"token"];
       NSString *businessID =  [[self.currentUser.business objectForKey:@"Business"]objectForKey:@"id"];
        NSString *businessType = [[self.currentUser.business objectForKey:@"Business"]objectForKey:@"type_of_business"];
        NSString *longitude = [[self.currentUser.business objectForKey:@"Business"]objectForKey:@"longitude"];
        NSString *latitude = [[self.currentUser.business objectForKey:@"Business"]objectForKey:@"latitude"];

         self.loadingview.alpha = .75;

        [MillieAPIClient updateBusiness:token businessName:self.labelBusinessName.text businessAddress:self.textViewBusinessAddr.text businessPhone:self.textFieldBusinessPhone.text businessHours:self.textFieldBusinessHours.text businessType:businessType longitude:longitude latitude:latitude businessID:businessID businessDescription:self.textViewBusinessDescription.text completion:^(NSDictionary *result) {
            if (result) {
                NSLog(@"Business Update:%@",result);
                self.loadingview.alpha = 0;
            }
        }];


    }
}


- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    // Background color
    view.tintColor = [UIColor colorwithHexString:@"334d5c" alpha:1];

    // Text Color
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor colorwithHexString:@"D4ECDC" alpha:1]];
    


}
#pragma mark - onButton Press Methods

- (IBAction)buttonOnPressSwitchToPersonalAccount:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    M_CustomTabBarController *tab=[storyboard instantiateViewControllerWithIdentifier:@"tabBarController"];
    
    [self.navigationController presentViewController:tab animated:YES completion:nil];
}

#pragma mark - UIGesture Methods

-(void)tapPhoto1:(UIGestureRecognizer*)gesture
{
    self.photoReference = @"photo1";
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Add Business Picture" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo",@"Choose Existing", nil];
    [actionSheet showInView:self.view];
}
-(void)tapPhoto2:(UIGestureRecognizer*)gesture
{
    self.photoReference = @"photo2";
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Add Business Picture" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo",@"Choose Existing", nil];
    [actionSheet showInView:self.view];
}
-(void)tapPhoto3:(UIGestureRecognizer*)gesture
{
    self.photoReference = @"photo3";
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Add Business Picture" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo",@"Choose Existing", nil];
    [actionSheet showInView:self.view];
}
-(void)tapPhoto4:(UIGestureRecognizer*)gesture
{
    self.photoReference = @"photo4";
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Add Business Picture" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo",@"Choose Existing", nil];
    [actionSheet showInView:self.view];
}

-(void)tapPhotoMain:(UIGestureRecognizer*)gesture
{
    self.photoReference = @"photoMain";
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Add Business Picture" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo",@"Choose Existing", nil];
    [actionSheet showInView:self.view];
}

#pragma mark UIAction Sheet Methods

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self setupCamera];
    }
    else if (buttonIndex == 1)
    {
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self setupLibrary];

    }
}

#pragma mark - UIImagePicker Methods

-(void)setupCamera
{
    self.imagePicker = [[UIImagePickerController alloc]init];
    self.imagePicker.delegate = self;
    self.imagePicker.allowsEditing = YES;
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.imagePicker.mediaTypes =  [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];

    [self presentViewController:self.imagePicker animated:YES completion:^{
    }];
}

-(void)setupLibrary
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

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];

    if ([mediaType isEqualToString:(NSString *)kUTTypeImage])
    {
        self.businessPic = [info objectForKey:UIImagePickerControllerOriginalImage];

        // Pictures taken from camera shot are stored to device
        if (self.imagePicker.sourceType == UIImagePickerControllerSourceTypeCamera)
        {
            //Save to Photos Album
            UIImageWriteToSavedPhotosAlbum(self.businessPic, nil, nil, nil);
        }

        NSData *imageData =  UIImagePNGRepresentation([info objectForKey:UIImagePickerControllerOriginalImage]);

        [imageData base64EncodedDataWithOptions:0];


        self.stringImageData = [imageData base64EncodedStringWithOptions:0];

    }
    [self dismissViewControllerAnimated:YES completion:^{
        [self setBusinessPhoto:self.businessPic photoReference:self.photoReference];
        self.photoReference = @"";
        self.imageEdit =YES;

    }];
}

-(void)setBusinessPhoto:(UIImage*)photo photoReference:(NSString*)reference
{
    NSString *token = [Lockbox stringForKey:@"token"];

    if ([reference isEqualToString:@"photo1"])
    {
        self.imageViewPhoto1.image = [Utility squareImageFromImage:photo scaledToSize:150];
        self.imagePhoto1 = [Utility squareImageFromImage:photo scaledToSize:150];
         NSString *businessID = [[self.currentUser.business objectForKey:@"Business"]objectForKey:@"id"];

        if (self.arrayOfOrderedImages.count != 2) {

            self.loadingview.alpha = .75;

            NSNumber *main = [NSNumber numberWithInt:0];

            [MillieAPIClient postImage:token businessID:businessID dealID:nil userID:nil type:@"business" photoData:self.stringImageData mainImage:main completion:^(NSDictionary *result) {
                NSLog(@"New Picture Posted");
                self.loadingview.alpha = 0;
            }];
        }
        else
        {

        NSString *imageID = [[[self.arrayOfOrderedImages objectAtIndex:1]objectForKey:@"image"]objectForKey:@"id"];

        [MillieAPIClient deleteImage:token imageID:imageID completion:^(NSDictionary *result) {
            if (result) {

                self.loadingview.alpha = .75;
                NSNumber *main = [NSNumber numberWithInt:0];

                [MillieAPIClient postImage:token businessID:businessID dealID:nil userID:nil type:@"business" photoData:self.stringImageData mainImage:main completion:^(NSDictionary *result) {
                    self.loadingview.alpha = 0;
                    NSLog(@"New Picture Posted");

                }];
            }
        }];

        }



    }
    else if ([reference isEqualToString:@"photo2"])
    {
        self.imageViewPhoto2.image = [Utility squareImageFromImage:photo scaledToSize:150];
        self.imagePhoto2 = [Utility squareImageFromImage:photo scaledToSize:150];
        NSString *businessID = [[self.currentUser.business objectForKey:@"Business"]objectForKey:@"id"];

        if (self.arrayOfOrderedImages.count != 3) {

            self.loadingview.alpha = .75;
            NSNumber *main = [NSNumber numberWithInt:0];

            [MillieAPIClient postImage:token businessID:businessID dealID:nil userID:nil type:@"business" photoData:self.stringImageData mainImage:main completion:^(NSDictionary *result) {
                self.loadingview.alpha = 0;
                NSLog(@"New Picture Posted");
            }];
        }
        else
        {

            NSString *imageID = [[[self.arrayOfOrderedImages objectAtIndex:2]objectForKey:@"image"]objectForKey:@"id"];

            [MillieAPIClient deleteImage:token imageID:imageID completion:^(NSDictionary *result) {
                if (result) {

                    self.loadingview.alpha = .75;
                    NSNumber *main = [NSNumber numberWithInt:0];

                    [MillieAPIClient postImage:token businessID:businessID dealID:nil userID:nil type:@"business" photoData:self.stringImageData mainImage:main completion:^(NSDictionary *result) {
                        self.loadingview.alpha = 0;
                        NSLog(@"New Picture Posted");
                    }];
                }
            }];
            
        }

    }
    else if ([reference isEqualToString:@"photo3"])
    {
        self.imageViewPhoto3.image = [Utility squareImageFromImage:photo scaledToSize:150];
        self.imagePhoto3 = [Utility squareImageFromImage:photo scaledToSize:150];

        NSString *businessID = [[self.currentUser.business objectForKey:@"Business"]objectForKey:@"id"];

        if (self.arrayOfOrderedImages.count != 4) {

            self.loadingview.alpha = .75;
            NSNumber *main = [NSNumber numberWithInt:0];

            [MillieAPIClient postImage:token businessID:businessID dealID:nil userID:nil type:@"business" photoData:self.stringImageData mainImage:main completion:^(NSDictionary *result) {
                self.loadingview.alpha = 0;
                NSLog(@"New Picture Posted");
            }];
        }
        else
        {

            NSString *imageID = [[[self.arrayOfOrderedImages objectAtIndex:3]objectForKey:@"image"]objectForKey:@"id"];

            [MillieAPIClient deleteImage:token imageID:imageID completion:^(NSDictionary *result) {
                if (result) {

                    self.loadingview.alpha = .75;
                    NSNumber *main = [NSNumber numberWithInt:0];

                    [MillieAPIClient postImage:token businessID:businessID dealID:nil userID:nil type:@"business" photoData:self.stringImageData mainImage:main completion:^(NSDictionary *result) {
                        self.loadingview.alpha = 0;
                        NSLog(@"New Picture Posted");
                    }];
                }
            }];
            
        }
    }
    else if ([reference isEqualToString:@"photo4"])
    {
        self.imageViewPhoto4.image = [Utility squareImageFromImage:photo scaledToSize:150];
        self.imagePhoto4 = [Utility squareImageFromImage:photo scaledToSize:150];

        NSString *businessID = [[self.currentUser.business objectForKey:@"Business"]objectForKey:@"id"];

        if (self.arrayOfOrderedImages.count != 5) {

            self.loadingview.alpha = .75;
            NSNumber *main = [NSNumber numberWithInt:0];

            [MillieAPIClient postImage:token businessID:businessID dealID:nil userID:nil type:@"business" photoData:self.stringImageData mainImage:main completion:^(NSDictionary *result) {
                self.loadingview.alpha = 0;
                NSLog(@"New Picture Posted");
            }];
        }
        else
        {

            NSString *imageID = [[[self.arrayOfOrderedImages objectAtIndex:4]objectForKey:@"image"]objectForKey:@"id"];

            [MillieAPIClient deleteImage:token imageID:imageID completion:^(NSDictionary *result) {
                if (result) {

                    self.loadingview.alpha = .75;
                    NSNumber *main = [NSNumber numberWithInt:0];

                    [MillieAPIClient postImage:token businessID:businessID dealID:nil userID:nil type:@"business" photoData:self.stringImageData mainImage:main
                                    completion:^(NSDictionary *result) {

                                        self.loadingview.alpha = 0;
                                        NSLog(@"New Picture Posted");
                    }];
                }
            }];
            
        }
    }
    else if ([reference isEqualToString:@"photoMain"])
    {
        self.imageViewBusinessProfileImage.image = [Utility squareImageFromImage:photo scaledToSize:150];
        self.imageMain = [Utility squareImageFromImage:photo scaledToSize:150];

        NSString *businessID = [[self.currentUser.business objectForKey:@"Business"]objectForKey:@"id"];

        if (self.arrayOfOrderedImages.count != 1) {

            NSNumber *main = [NSNumber numberWithInt:0];

            [MillieAPIClient postImage:token businessID:businessID dealID:nil userID:nil type:@"business" photoData:self.stringImageData mainImage:main completion:^(NSDictionary *result) {
                NSLog(@"New Picture Posted");
            }];
        }
        else
        {
            NSString *imageID = [[[self.arrayOfOrderedImages objectAtIndex:0]objectForKey:@"image"]objectForKey:@"id"];

            [MillieAPIClient deleteImage:token imageID:imageID completion:^(NSDictionary *result) {
                if (result) {

                    NSNumber *main = [NSNumber numberWithInt:1];

                    [MillieAPIClient postImage:token businessID:businessID dealID:nil userID:nil type:@"business" photoData:self.stringImageData mainImage:main completion:^(NSDictionary *result) {
                        NSLog(@"New Picture Posted");
                    }];
                }
            }];
            
        }


    }
}


@end
