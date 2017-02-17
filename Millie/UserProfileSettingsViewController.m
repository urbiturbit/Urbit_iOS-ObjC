//
//  UserProfileSettingsViewController.m
//  Millie
//
//  Created by Emmanuel Masangcay on 7/1/15.
//  Copyright (c) 2015 CoderEXP. All rights reserved.
//

#import "UserProfileSettingsViewController.h"
#import "User.h"
#import "MillieAPIClient.h"
#import "LogInViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface UserProfileSettingsViewController () <CLLocationManagerDelegate>

@property (strong, nonatomic) IBOutlet UISwitch *switchNotifications;

@property (strong, nonatomic) IBOutlet UITextField *textFieldSearchRadius;
@property (strong, nonatomic) IBOutlet UISwitch *switchLocation;
@property (strong, nonatomic) IBOutlet UITextField *textFieldLocationCityorZip;

@property CLLocation *locationDistance;
@property CLLocationManager *myLocationManager;
@property CLLocation *myLocation;
@property User *currentUser;



@end

@implementation UserProfileSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.currentUser = [User sharedSingleton];

    [self.switchNotifications addTarget:self
                      action:@selector(stateChangedNotifications:) forControlEvents:UIControlEventValueChanged];

    [self.switchLocation addTarget:self
                                 action:@selector(stateChangedLocation:) forControlEvents:UIControlEventValueChanged];





}
- (IBAction)onButtonPressCancelSettings:(id)sender {

    self.currentUser.searchRadius = self.textFieldSearchRadius.text;

    if (self.textFieldLocationCityorZip.alpha == 1) {
        CLGeocoder * geoCoder = [CLGeocoder new];
        [geoCoder geocodeAddressString:self.textFieldLocationCityorZip.text completionHandler:^(NSArray *placemarks, NSError *error) {
            CLPlacemark *placemark = [placemarks lastObject]; // firstObject is iOS7 only.
            NSLog(@"Location is: %@", placemark.location);
            self.currentUser.currentLocation = placemark.location;
        }];
    }
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}


- (void)stateChangedNotifications:(UISwitch *)switchState
{
    if ([switchState isOn]) {
        NSLog(@"The Switch is On");
    } else {
        NSLog(@"The Switch is Off");
    }
}
- (IBAction)onButtonPressLogout:(id)sender
{
//    LOGOUT
        NSString *token = [Lockbox stringForKey:@"token"];
        [MillieAPIClient logOutUser:token completion:^(NSString *result) {
            if (result) {
                 BOOL result = [Lockbox setString:nil forKey:@"token"];

                UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main"
                                                                     bundle:nil];
                LogInViewController *add =
                [storyboard instantiateViewControllerWithIdentifier:@"LaunchPad"];

                [self presentViewController:add
                                   animated:YES 
                                 completion:nil];

            }
        }];
}

- (void)stateChangedLocation:(UISwitch *)switchState
{
    if ([switchState isOn]) {
        NSLog(@"The Switch is On");
        self.textFieldLocationCityorZip.alpha = 0;

        self.myLocationManager = [[CLLocationManager alloc]init];
        self.myLocationManager.delegate = self;
        [self.myLocationManager requestWhenInUseAuthorization];
         [self.myLocationManager startUpdatingLocation];
    } else {
        NSLog(@"The Switch is Off");
        self.textFieldLocationCityorZip.alpha = 1;
    }
}

#pragma mark - CLLocationManagerDelegate Methods

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    for (CLLocation *location in locations) {
        //Setting my location
        self.currentUser.currentLocation = location;

        [self.myLocationManager stopUpdatingLocation];
        break;
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Error = %@",error);

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
    [self.view endEditing:YES];
}



@end
