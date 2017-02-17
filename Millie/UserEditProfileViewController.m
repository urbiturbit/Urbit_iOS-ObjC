//
//  UserEditProfileViewController.m
//  Millie
//
//  Created by Emmanuel Masangcay on 7/3/15.
//  Copyright (c) 2015 CoderEXP. All rights reserved.
//

#import "UserEditProfileViewController.h"
#import "UIColor+HEX.h"
#import "User.h"
#import "Utility.h"
#import "MillieAPIClient.h"
#import <MobileCoreServices/MobileCoreServices.h>


@interface UserEditProfileViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UITextField *textFieldUsername;
@property (strong, nonatomic) IBOutlet UITextField *textFieldEmail;
@property (strong, nonatomic) IBOutlet UITextField *textFieldHomeAddr;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewProfileEdit;

@property UIImagePickerController *imagePicker;
@property UIImage *profilePic;
@property NSString *stringImageData;

@property User *currentUser;

@end

@implementation UserEditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.currentUser = [User sharedSingleton];

    NSAttributedString *strUsername = [[NSAttributedString alloc] initWithString:@"USER NAME" attributes:@{ NSForegroundColorAttributeName : [UIColor colorwithHexString:@"334d5c" alpha:1] }];
    self.textFieldUsername.attributedPlaceholder = strUsername;

    NSAttributedString *strEmail = [[NSAttributedString alloc] initWithString:@"EMAIL" attributes:@{ NSForegroundColorAttributeName : [UIColor colorwithHexString:@"334d5c" alpha:1] }];
    self.textFieldEmail.attributedPlaceholder = strEmail;

    NSAttributedString *strHomeAddr = [[NSAttributedString alloc] initWithString:@"HOME ADDRESS" attributes:@{ NSForegroundColorAttributeName : [UIColor colorwithHexString:@"334d5c" alpha:1] }];
    self.textFieldHomeAddr.attributedPlaceholder = strHomeAddr;

    self.textFieldEmail.text = self.currentUser.email;


    self.imageViewProfileEdit.image = self.currentUser.userProfilePic;
    [self.imageViewProfileEdit setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapEditImage:)];
    [self.imageViewProfileEdit addGestureRecognizer:tap];
    if (self.currentUser.userProfilePic == nil)
    {
        self.imageViewProfileEdit.image = [UIImage imageNamed:@"profile"];
    }
    else
    {
        self.imageViewProfileEdit.layer.cornerRadius = self.imageViewProfileEdit.frame.size.height /2;
        self.imageViewProfileEdit.layer.masksToBounds = YES;
    }

}

#pragma mark - OnButtonPress Methods

- (IBAction)onButtonPressCancelEditProfile:(id)sender {

    [self dismissViewControllerAnimated:YES completion:^{

    }];
}

- (IBAction)onButtonPressSaveProfile:(id)sender {

    self.currentUser.email = self.textFieldEmail.text;

        NSString *token = [Lockbox stringForKey:@"token"];
        NSString *userID = self.currentUser.userID;

    if (self.stringImageData !=nil)
    {
        [MillieAPIClient postImage:token businessID:nil dealID:nil userID:userID type:@"user" photoData:self.stringImageData mainImage:nil completion:^(NSDictionary *result) {
            if (result)
            {
                self.currentUser.userProfilePic = self.profilePic;

                [MillieAPIClient updateUser:token email:self.textFieldEmail.text userID:userID username:self.textFieldUsername.text address:self.textFieldHomeAddr.text  completion:^(NSString *result) {

                    self.currentUser.email = self.textFieldEmail.text;
                    self.currentUser.userName = self.textFieldUsername.text;
                    self.currentUser.homeAddr = self.textFieldHomeAddr.text;
                    
                     [self dismissViewControllerAnimated:YES completion:^{}];

                }];

            }

        }];
    }
    else
    {
        [MillieAPIClient updateUser:token email:self.textFieldEmail.text userID:userID username:self.textFieldUsername.text address:self.textFieldHomeAddr.text  completion:^(NSString *result) {

            self.currentUser.email = self.textFieldEmail.text;
            self.currentUser.userName = self.textFieldUsername.text;
            self.currentUser.homeAddr = self.textFieldHomeAddr.text;

            [self dismissViewControllerAnimated:YES completion:^{}];

        }];

    }







}

#pragma mark - UIGesture Methods

-(void)tapEditImage:(UIGestureRecognizer*)gesture
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Add Profile Picture" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo",@"Choose Existing", nil];
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
        self.profilePic = [info objectForKey:UIImagePickerControllerOriginalImage];
        NSData *imageData =  UIImagePNGRepresentation([info objectForKey:UIImagePickerControllerOriginalImage]);

        [imageData base64EncodedDataWithOptions:0];

        self.stringImageData = [imageData base64EncodedStringWithOptions:0];

        // Pictures taken from camera shot are stored to device
        if (self.imagePicker.sourceType == UIImagePickerControllerSourceTypeCamera)
        {
            //Save to Photos Album
            UIImageWriteToSavedPhotosAlbum(self.profilePic, nil, nil, nil);
        }
    }

    [self dismissViewControllerAnimated:YES completion:^{
\
            self.imageViewProfileEdit.image = [Utility squareImageFromImage:self.profilePic scaledToSize:80];
            self.imageViewProfileEdit.layer.cornerRadius = self.imageViewProfileEdit.frame.size.height /2;
            self.imageViewProfileEdit.layer.masksToBounds = YES;
            self.imageViewProfileEdit.layer.borderWidth = 0;

    }];
}



@end
