//
//  MillieAPIClient.h
//  Millie
//
//  Created by Emmanuel Masangcay on 6/3/15.
//  Copyright (c) 2015 CoderEXP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import <Lockbox/Lockbox.h>

/****************************************************************************************/

static NSString * const URL_LOGIN = @"https://localloop.herokuapp.com/api/v1/users/sign_in";

static NSString * const URL_LOGOUT = @"https://localloop.herokuapp.com/api/v1/users/sign_out?auth_token=";

static NSString * const URL_SIGNUP = @"https://localloop.herokuapp.com/api/v1/users";

static NSString * const URL_GET_USER_INFO = @"https://localloop.herokuapp.com/api/v1/user_info?auth_token=";

static NSString * const URL_FORGOT_PASSWORD = @"https://localloop.herokuapp.com/api/v1/users/password";

static NSString * const URL_SUBMIT_PASSWORD = @"https://localloop.herokuapp.com/api/v1/users/password";

static NSString * const URL_UPDATE_USER = @"https://localloop.herokuapp.com/api/v1/users/";

/****************************************************************************************/

static NSString * const URL_CREATE_BUSINESS = @"https://localloop.herokuapp.com/api/v1/businesses";

static NSString * const URL_GET_ALL_BUSINESS = @"https://localloop.herokuapp.com/api/v1/businesses";

static NSString * const URL_GET_BUSINESS = @"https://localloop.herokuapp.com/api/v1/my_businesses?auth_token=";

static NSString * const URL_GET_BUSINESS_BY_ID = @"https://localloop.herokuapp.com/api/v1/businesses/";

static NSString * const URL_UPDATE_BUSINESS_INFO = @"https://localloop.herokuapp.com/api/v1/businesses/";

/****************************************************************************************/

static NSString * const URL_POST_DEALS = @"https://localloop.herokuapp.com/api/v1/businesses/";

static NSString * const URL_GET_MARKET_DEALS = @"https://localloop.herokuapp.com/api/v1/marketplace_deals?auth_token=";

static NSString * const URL_POST_IMAGE = @"https://localloop.herokuapp.com/api/v1/images";

static NSString * const URL_GET_BUSINESS_IMAGE = @"https://localloop.herokuapp.com/api/v1/my_business_photos?auth_token=";

static NSString * const URL_GET_DEAL_BUSINESS_IMAGE = @"https://localloop.herokuapp.com/api/v1/businesses/";

static NSString * const URL_GET_PROFILE_IMAGE = @"https://localloop.herokuapp.com/api/v1/my_profile_photo?auth_token=";

static NSString * const URL_DELETE_IMAGE = @"https://localloop.herokuapp.com/api/v1/images/";

/****************************************************************************************/

static NSString * const URL_CLAIM_DEAL = @"https://localloop.herokuapp.com/api/v1/businesses/";

static NSString * const URL_GET_ALL_ACTIVATIONS_FOR_DEAL = @"https://localloop.herokuapp.com/api/v1/businesses/";

static NSString * const URL_GET_ALL_ACTIVATIONS_FOR_USER = @"https://localloop.herokuapp.com/api/v1/my_activations?auth_token=";

static NSString * const URL_MY_BUSINESS_DEALS = @"https://localloop.herokuapp.com/api/v1/my_deals?auth_token=";

static NSString * const URL_CHECK_ACTIVATIONS_FOR_DEAL = @"https://localloop.herokuapp.com/api/v1/businesses/";

static NSString * const URL_GET_DEAL_IMAGE = @"https://localloop.herokuapp.com/api/v1/businesses/";

static NSString * const URL_SEARCH_DEALS = @"https://localloop.herokuapp.com/api/v1/search";


/****************************************************************************************/

@interface MillieAPIClient : NSObject

#pragma mark - USER

+(void)logInUser:(NSString*)email password:(NSString*)password completion:(void (^)(NSDictionary*))completionHandler;

+(void)signUpUser:(NSString*)email password:(NSString*)password passwordConfirmation:(NSString*)confirmation
       completion:(void (^)(NSString* result))completionHandler;

+(void)updateUser:(NSString*)token email:(NSString*)email userID:(NSString*)userID username:(NSString*)username address:(NSString*)address
       completion:(void (^)(NSString* result))completionHandler;

+(void)getUserInfo:(NSString*)token completion:(void (^)(NSDictionary* result))completionHandler;

+(void)logOutUser:(NSString*)token completion:(void (^)(NSString* result))completionHandler;

+(void)forgetPassword:(NSString*)email completion:(void (^)(NSDictionary* result))completionHandler;

+(void)submitPassword:(NSString*)confirmToken password:(NSString*)password confirmPassword:(NSString*)confirmPassword  completion:(void (^)(NSDictionary* result))completionHandler;

#pragma mark - Business

+(void)createBusiness:(NSString*)token businessName:(NSString*)name businessAddress:(NSString*)addr businessPhone:(NSString*)phone businessHours:(NSString*)hours businessType:(NSString*)type longitude:(NSString*)longitude latitude:(NSString*)latitude businessCity:(NSString*)city businessZip:(NSString*)zip businessState:(NSString*)state website:(NSString*)website description:(NSString*)description completion:(void (^)(NSDictionary* result))completionHandler;

+(void)getBusiness:(NSString*)token completion:(void (^)(NSDictionary* result))completionHandler;

+(void)getBusinessByID:(NSString*)token businessID:(NSString*)businessID completion:(void (^)(NSDictionary* result))completionHandler;

+(void)updateBusiness:(NSString*)token businessName:(NSString*)name businessAddress:(NSString*)addr businessPhone:(NSString*)phone businessHours:(NSString*)hours businessType:(NSString*)type longitude:(NSString*)longitude latitude:(NSString*)latitude businessID:(NSString*)businessID businessDescription:(NSString*)description completion:(void (^)(NSDictionary* result))completionHandler;

#pragma mark - Deals

+(void)postDeals:(NSString*)token startTime:(NSString*)startTime expirationTime:(NSString*)expTime termsAndCondition:(NSString*)termsConditions quantity:(NSNumber*)quantity dealLevel:(NSString*)level category:(NSString*)category zip:(NSString*)zip businessID:(NSNumber*)businessID dealDescripton:(NSString*)description dealTitle:(NSString*)title
      completion:(void (^)(NSDictionary* result))completionHandler;

+(void)getMarketPlaceDeals:(NSString*)token completion:(void (^)(NSDictionary* result))completionHandler;

+(void)claimDeal:(NSString*)token businessID:(NSString*)businessID dealID:(NSString*)dealID  completion:(void (^)(NSDictionary* result))completionHandler;

+(void)getMyBusinessDeals:(NSString*)token completion:(void (^)(NSDictionary* result))completionHandler;

+(void)searchDeals:(NSString*)token search:(NSString*)search completion:(void (^)(NSDictionary* result))completionHandler;

#pragma mark - Activations

+(void)getActivationsForDeal:(NSString*)token businessID:(NSString*)businessID dealID:(NSString*)dealID completion:(void (^)(NSDictionary* result))completionHandler;

+(void)checkActivationsForDeal:(NSString*)token businessID:(NSString*)businessID dealID:(NSString*)dealID activationCode:(NSString*) code completion:(void (^)(NSDictionary* result))completionHandler;

+(void)getActivationsForUser:(NSString*)token completion:(void (^)(NSDictionary* result))completionHandler;

#pragma mark - IMAGE

+(void)postImage:(NSString*)token businessID:(NSString*)businessID dealID:(NSString*)dealID userID:(NSString*)userID type:(NSString*)type photoData:(NSString*)photo mainImage:(NSNumber*)mainImage completion:(void (^)(NSDictionary* result))completionHandler;

+(void)getBusinessImage:(NSString*)token completion:(void (^)(NSDictionary* result))completionHandler;

+(void)getProfileImage:(NSString*)token completion:(void (^)(NSDictionary* result))completionHandler;

+(void)getDealImage:(NSString*)token businessID:(NSString*)businessID dealID:(NSString*)dealID completion:(void (^)(NSDictionary* result))completionHandler;

+(void)getDealBusinessImage:(NSString*)token businessID:(NSString*)businessID completion:(void (^)(NSDictionary* result))completionHandler;

+(void)deleteImage:(NSString*)token imageID:(NSString*)imageID completion:(void (^)(NSDictionary* result))completionHandler;


@end
