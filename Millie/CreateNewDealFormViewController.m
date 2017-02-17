//
//  CreateNewDealFormViewController.m
//  Millie
//
//  Created by Emmanuel Masangcay on 6/24/15.
//  Copyright (c) 2015 CoderEXP. All rights reserved.
//

#import "CreateNewDealFormViewController.h"
#import "UIColor+HEX.h"

@interface CreateNewDealFormViewController ()

@property (strong, nonatomic) IBOutlet UITextView *textViewCreateDealTC;
@property (strong, nonatomic) IBOutlet UITextField *textFieldDealQTY;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *startDateHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *startDateWidth;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *finishDateHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *finishDateWidth;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *dealsAndTermsVerticalSpace;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *expirationVerticalSpace;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *textViewHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *startDateVerticalSpace;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *finishDateVerticalSpaceToTop;

@end

@implementation CreateNewDealFormViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //To make the border look very close to a UITextField
    [self.textViewCreateDealTC.layer setBorderColor:[[[UIColor colorwithHexString:@"334d5c" alpha:1 ] colorWithAlphaComponent:1] CGColor]];
    [self.textViewCreateDealTC.layer setBorderWidth:1.0];

    self.datePickerStart.minimumDate = [NSDate date];


    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;

    if (screenWidth == 375) //iphone6
    {
        self.expirationVerticalSpace.constant = 15;

        self.startDateVerticalSpace.constant = 15;

         self.finishDateVerticalSpaceToTop.constant = 220;

        self.dealsAndTermsVerticalSpace.constant = 20;

    }
    if (screenWidth == 320) //iphone5
    {
        self.startDateHeight.constant = 162;
        self.finishDateHeight.constant = 162;
        self.dealsAndTermsVerticalSpace.constant = -15;
        self.expirationVerticalSpace.constant = -10;
        self.textViewHeight.constant = 30;
        self.startDateVerticalSpace.constant = - 10;
        self.finishDateVerticalSpaceToTop.constant = 170;
    }
    if (screenWidth == 414) //iphone6+
    {

    }
 

}



@end
