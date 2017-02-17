//
//  TESTViewController.m
//  Millie
//
//  Created by Emmanuel Masangcay on 6/4/15.
//  Copyright (c) 2015 CoderEXP. All rights reserved.
//

#import "TESTViewController.h"

@interface TESTViewController ()

@end

@implementation TESTViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController.interactivePopGestureRecognizer setEnabled:NO];
  
}


- (IBAction)buttonTest:(id)sender {

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UITabBarController *tab=[storyboard instantiateViewControllerWithIdentifier:@"merchantTab"];
    [self.navigationController presentViewController:tab animated:YES completion:nil];

}



@end
