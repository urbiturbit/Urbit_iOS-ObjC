//
//  CreateNewDealFormViewController.h
//  Millie
//
//  Created by Emmanuel Masangcay on 6/24/15.
//  Copyright (c) 2015 CoderEXP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateNewDealFormViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *textFieldStartDate;
@property (strong, nonatomic) IBOutlet UITextField *textFieldStartTime;
@property (strong, nonatomic) IBOutlet UITextField *textFieldExpirationDate;
@property (strong, nonatomic) IBOutlet UITextField *textFieldExpirationTime;
@property (strong, nonatomic) IBOutlet UITextField *textFieldQuantity;
@property (strong, nonatomic) IBOutlet UITextView *textViewTermsConditions;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePickerStart;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePickerFinish;

@end
