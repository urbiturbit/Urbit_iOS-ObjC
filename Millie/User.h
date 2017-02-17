//
//  User.h
//  Millie
//
//  Created by Emmanuel Masangcay on 6/30/15.
//  Copyright (c) 2015 CoderEXP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface User : NSObject

@property NSString *userName;
@property UIImage *userProfilePic;
@property UIImage *businessProfilePic;
@property NSString *userID;
@property NSString *email;
@property NSString *homeAddr;
@property NSString *searchRadius;
@property NSDictionary *business;
@property NSMutableArray *featureDeals;
@property CLLocation *currentLocation;

// This is the method to access this Singleton class
+ (User *)sharedSingleton;

@end
