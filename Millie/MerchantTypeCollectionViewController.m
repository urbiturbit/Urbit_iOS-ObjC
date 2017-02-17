//
//  MerchantTypeCollectionViewController.m
//  Millie
//
//  Created by Emmanuel Masangcay on 6/8/15.
//  Copyright (c) 2015 CoderEXP. All rights reserved.
//

#import "MerchantTypeCollectionViewController.h"
#import "InterestsCollectionViewCell.h"

@interface MerchantTypeCollectionViewController () <UIPickerViewDataSource,UIPickerViewDelegate>

@property NSArray *arrayOfBusinessTypes;
@property (strong, nonatomic) IBOutlet UIPickerView *pickerViewBusinessType;

@end

@implementation MerchantTypeCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.arrayOfBusinessTypes = [NSArray arrayWithObjects:@"FOOD and DRINK",@"ENTERTAINMENT",@"HEALTH AND FITNESS",@"BEAUTY AND SPA",@"HOME SERVICES",@"LOCAL SERVICES",@"AUTOMOTIVE",@"SHOPPING",nil];


//    if ([self.delegate checkBusinessType:businessType])
//    {
//        [self.delegate removeBusinessType:businessType];
//    }
//    else
//    {
//        [self.delegate tapBusinessType:businessType];
//    }

}

#pragma mark Picker Delegate Methods

// The number of columns of data
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.arrayOfBusinessTypes.count;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.arrayOfBusinessTypes[row];
}

// Catpure the picker view selection
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSString *businessType = self.arrayOfBusinessTypes[row];

    [self.delegate tapBusinessType:businessType];

}


@end
