//
//  AppDelegate.m
//  Millie
//
//  Created by Emmanuel Masangcay on 6/2/15.
//  Copyright (c) 2015 CoderEXP. All rights reserved.
//

#import "AppDelegate.h"
#import "Utility.h"
#import "MillieAPIClient.h"
#import "B_CustomTabBarController.h"
#import "UIColor+HEX.h"
#import "LogInViewController.h"
#import "User.h"

#import "WalkThroughIntroViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <AFNetworking/AFNetworkActivityIndicatorManager.h>
#import <Lockbox/Lockbox.h>
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>


@interface AppDelegate ()

@property User *currentUser;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    //AFNETWORK
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;

    //Settin UI
    [[UITextField appearance] setTintColor:[UIColor colorwithHexString:@"334d5c" alpha:1]];


    [[UIView appearanceWhenContainedIn:[UIAlertController class], nil] setBackgroundColor:[UIColor whiteColor]];
    [[UIView appearanceWhenContainedIn:[UIAlertController class], nil] setTintColor:[UIColor colorwithHexString:@"45b29d" alpha:1]];

    [self setRootViewController:nil];

    //Checking If User is already logged in
    NSString *token = [Lockbox stringForKey:@"token"];
    NSLog(@"Token: %@",token);

    self.currentUser = [User sharedSingleton];


    if (token) {
        // Get Feature Deals
          UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                                   bundle: nil];
          B_CustomTabBarController *rootViewController= [mainStoryboard instantiateViewControllerWithIdentifier:@"tabBarController"];
          [self setRootViewController:rootViewController];
          // Get User Info
          [MillieAPIClient getUserInfo:token completion:^(NSDictionary *result) {
              self.currentUser.email = [[result objectForKey:@"User"]objectForKey:@"email"];
              self.currentUser.userID = [[result objectForKey:@"User"]objectForKey:@"id"];
              self.currentUser.userName = [[result objectForKey:@"User"]objectForKey:@"username"];
          }];

    }

    else
    {
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                                 bundle: nil];
        WalkThroughIntroViewController *rootViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"LaunchPad"];
        [self setRootViewController:rootViewController];

    }

    [Fabric with:@[CrashlyticsKit]];


    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                    didFinishLaunchingWithOptions:launchOptions];


    return YES;
}

-(void)setRootViewController:(UIViewController *)rootViewController {
    self.window.rootViewController = rootViewController;
    [self.window makeKeyAndVisible];
}


- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBSDKAppEvents activateApp];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}




@end
