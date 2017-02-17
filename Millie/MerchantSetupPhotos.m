//
//  MerchantSetupPhotos.m
//  Millie
//
//  Created by Emmanuel Masangcay on 6/9/15.
//  Copyright (c) 2015 CoderEXP. All rights reserved.
//

#import "MerchantSetupPhotos.h"
#import "MerchantSetupViewController.h"
#import "Utility.h"


@implementation MerchantSetupPhotos


-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self = [[[NSBundle mainBundle] loadNibNamed:@"MerchantSetupPhotos"
                                       owner:self
                                     options:nil] objectAtIndex:0];


        CGRect screenRect = [[UIScreen mainScreen] bounds];
        CGFloat screenWidth = screenRect.size.width;

        CGFloat Height;


        if (screenWidth == 375) {//iphone6
            Height = 414;
        }
        else if(screenWidth == 414){//iphone6+
            Height = 500;
        }
        else
        {
            Height = self.frame.size.height;
        }


        CGRect frameOfMerchantPhotos = CGRectMake(0, 0, self.frame.size.width, Height);
        
        self.frame = frameOfMerchantPhotos;

        //Set Business Name
        self.labelBusinessName.text = businessName;

        //******* Set TapGesture Recognizers *******//
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addPhoto1:)];
        tap1.numberOfTapsRequired = 1;
        tap1.numberOfTouchesRequired = 1;

        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addPhoto2:)];
        tap2.numberOfTapsRequired = 1;
        tap2.numberOfTouchesRequired = 1;

        UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addPhoto3:)];
        tap3.numberOfTapsRequired = 1;
        tap3.numberOfTouchesRequired = 1;

        UITapGestureRecognizer *tap4 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addPhoto4:)];
        tap4.numberOfTapsRequired = 1;
        tap4.numberOfTouchesRequired = 1;


        self.imageViewFirstMerchantPhoto.userInteractionEnabled = NO;
        self.imageViewFirstMerchantPhoto.alpha = .15;
        self.imageViewSecondMerchantPhoto.userInteractionEnabled = NO;
        self.imageViewSecondMerchantPhoto.alpha = .15;
        self.imageViewThirdMerchantPhoto.userInteractionEnabled = NO;
        self.imageViewThirdMerchantPhoto.alpha = .15;
        self.imageViewFourthMerchantPhoto.userInteractionEnabled = NO;
        self.imageViewFourthMerchantPhoto.alpha = .15;

        [self.imageViewFirstMerchantPhoto addGestureRecognizer:tap1];
        [self.imageViewSecondMerchantPhoto addGestureRecognizer:tap2];
        [self.imageViewThirdMerchantPhoto addGestureRecognizer:tap3];
        [self.imageViewFourthMerchantPhoto addGestureRecognizer:tap4];

    }
    return self;

}


-(void)setBusinessName:(NSString*)businessName
{
    self.labelBusinessName.text = businessName;
}

-(void)setBusinessPhoto:(UIImage*)photo photoReference:(NSString*)reference
{
    if ([reference isEqualToString:@"photo1"])
    {
        self.imageViewFirstMerchantPhoto.image = [Utility squareImageFromImage:photo scaledToSize:150];
    }
    else if ([reference isEqualToString:@"photo2"])
    {
        self.imageViewSecondMerchantPhoto.image = [Utility squareImageFromImage:photo scaledToSize:150];
    }
    else if ([reference isEqualToString:@"photo3"])
    {
        self.imageViewThirdMerchantPhoto.image = [Utility squareImageFromImage:photo scaledToSize:150];
    }
    else if ([reference isEqualToString:@"photo4"])
    {
        self.imageViewFourthMerchantPhoto.image = [Utility squareImageFromImage:photo scaledToSize:150];
    }
}

#pragma mark - Tap Methods

-(void)addPhoto1:(UIGestureRecognizer *)gesture
{
    self.photoReference = @"photo1";
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Add Merchant Photo" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo",@"Choose Existing",@"Remove Photo", nil];
    [actionSheet showInView:self];
}

-(void)addPhoto2:(UIGestureRecognizer *)gesture
{
    self.photoReference = @"photo2";
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Add Merchant Photo" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo",@"Choose Existing",@"Remove Photo", nil];
    [actionSheet showInView:self];
}

-(void)addPhoto3:(UIGestureRecognizer *)gesture
{
    self.photoReference = @"photo3";
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Add Merchant Photo" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo",@"Choose Existing",@"Remove Photo", nil];
    [actionSheet showInView:self];
}

-(void)addPhoto4:(UIGestureRecognizer *)gesture
{
    self.photoReference = @"photo4";
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Add Merchant Photo" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo",@"Choose Existing",@"Remove Photo", nil];
    [actionSheet showInView:self];
}

#pragma mark UIAction Sheet Methods

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        [self.delegate tapOnCamera:self.photoReference];
    }
    else if (buttonIndex == 1)
    {
        [self.delegate tapOnLibrary:self.photoReference];
    }
    else if (buttonIndex == 2)
    {
        if ([self.photoReference isEqualToString:@"photo1"]) {
            self.imageViewFirstMerchantPhoto.image = [UIImage imageNamed:@"Upload"];
        }
        else if ([self.photoReference isEqualToString:@"photo2"]) {
            self.imageViewSecondMerchantPhoto.image = [UIImage imageNamed:@"Upload"];
        }
        else if ([self.photoReference isEqualToString:@"photo3"]) {
            self.imageViewThirdMerchantPhoto.image = [UIImage imageNamed:@"Upload"];
        }
        else if ([self.photoReference isEqualToString:@"photo4"]) {
            self.imageViewFourthMerchantPhoto.image = [UIImage imageNamed:@"Upload"];
        }
    }

}


@end
