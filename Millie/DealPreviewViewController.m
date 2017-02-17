//
//  DealPreviewViewController.m
//  Millie
//
//  Created by Emmanuel Masangcay on 6/29/15.
//  Copyright (c) 2015 CoderEXP. All rights reserved.
//

#import "DealPreviewViewController.h"
#import "User.h"

@interface DealPreviewViewController ()
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *startDateVerticalSpaceToImage;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *imageViewHeight;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *imageViewWidth;


@property CGFloat Height;
@property CGFloat Width;

@end

@implementation DealPreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;

    if (screenWidth == 375) //iphone6
    {
        self.imageViewHeight.constant = 140;
        self.imageViewWidth.constant = 140;

    }
    if (screenWidth == 320) //iphone5
    {
        self.imageViewHeight.constant = 140;
        self.imageViewWidth.constant = 140;
        self.startDateVerticalSpaceToImage.constant = 10;
    }
    if (screenWidth == 414) //iphone6+
    {
        self.imageViewHeight.constant = 180;
        self.imageViewWidth.constant = 180;
    }



}



@end
