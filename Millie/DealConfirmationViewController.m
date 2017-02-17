//
//  DealConfirmationViewController.m
//  Millie
//
//  Created by Emmanuel Masangcay on 6/30/15.
//  Copyright (c) 2015 CoderEXP. All rights reserved.
//

#import "DealConfirmationViewController.h"
#import "DealPreviewViewController.h"
#import <Social/Social.h>

@interface DealConfirmationViewController ()


@end

@implementation DealConfirmationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    CALayer *layerFB = self.buttonFacebookShare.layer;
    layerFB.backgroundColor = [[UIColor whiteColor] CGColor];
    layerFB.borderColor = [[UIColor blackColor] CGColor];
    layerFB.borderWidth = 1.0f;

    CALayer *layerTwitter = self.buttonTwitterShare.layer;
    layerTwitter.backgroundColor = [[UIColor whiteColor] CGColor];
    layerTwitter.borderColor = [[UIColor blackColor] CGColor];
    layerTwitter.borderWidth = 1.0f;
}

#pragma mark - Button Press Methods

- (IBAction)buttonPressFacebookShare:(id)sender
{
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];


        [controller addImage:[UIImage imageNamed:@"business"]];


        [self presentViewController:controller animated:YES completion:nil];


    }
}

- (IBAction)buttonPressTwitterShare:(id)sender
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController
                                               composeViewControllerForServiceType:SLServiceTypeTwitter];

        [tweetSheet addImage:[UIImage imageNamed:@"business"]];

        [self presentViewController:tweetSheet animated:YES completion:nil];

    }
}

@end
