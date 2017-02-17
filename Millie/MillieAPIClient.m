//
//  MillieAPIClient.m
//  Millie
//
//  Created by Emmanuel Masangcay on 6/3/15.
//  Copyright (c) 2015 CoderEXP. All rights reserved.
//

#import "MillieAPIClient.h"


@implementation MillieAPIClient

#pragma mark - SIGNUP AND LOGIN

+(void)getUserInfo:(NSString *)token completion:(void (^)(NSDictionary *))completionHandler
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept" ];

    NSString *URLUserInfo= [NSString stringWithFormat:@"%@%@",URL_GET_USER_INFO,token];

    [manager GET:URLUserInfo parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"Success");
         completionHandler(responseObject);
     }
     //Failed To Signup
            failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         completionHandler(nil);

     }];
}

+(void)logOutUser:(NSString *)token completion:(void (^)(NSString *))completionHandler
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept" ];

    NSString *URLlogout= [NSString stringWithFormat:@"%@%@",URL_LOGOUT,token];

    [manager DELETE:URLlogout parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"Success");
         completionHandler(@"YES");
     }
     //Failed To Signup
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         completionHandler(@"Error");
         
     }];
}

+(void)logInUser:(NSString *)email password:(NSString *)password completion:(void (^)(NSDictionary *))completionHandler
{
    NSDictionary *user = @{@"user": @{@"email":email,
                                      @"password":password}};

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

    [manager POST:URL_LOGIN parameters:user success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"Success");
         NSString *token = [responseObject objectForKey:@"authentication_token"];
         [Lockbox setString:token forKey:@"token"];
         completionHandler(responseObject);
     }
     //Failed To Signup
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         completionHandler(nil);
     }];
}

+(void)signUpUser:(NSString *)email password:(NSString *)password passwordConfirmation:(NSString *)confirmation completion:(void (^)(NSString *))completionHandler
{
    NSDictionary *user = @{@"user": @{@"email":email,
                                      @"password":password,
                                      @"password_confirmation":confirmation
                                      }};

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    manager.requestSerializer = [AFJSONRequestSerializer serializer];

    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

    [manager POST:URL_SIGNUP parameters:user success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"Success");
         completionHandler(@"YES");

         //
     }
     //Failed To Signup
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         //JSON object to dictionary
         NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:operation.responseData options:kNilOptions error:&error];

         //Error Message
         NSArray *key = [dictionary allKeys];
         NSString *keyValue = [key objectAtIndex:0];
         NSString *message = [[dictionary objectForKey:keyValue]objectAtIndex:0];
         NSString *errorMsg = [NSString stringWithFormat:@"Signup Unsuccessful: %@ %@",keyValue,message];
         //Display Alert Error Message
         completionHandler(errorMsg);

     }];

}

+(void)updateUser:(NSString *)token email:(NSString *)email userID:(NSString *)userID username:(NSString *)username address:(NSString *)address completion:(void (^)(NSString *))completionHandler
{
    NSDictionary *user = @{@"user": @{@"email":email,
                                      @"username":username,
                                      @"address":address
                                      },
                           @"auth_token":token
                           };

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    manager.requestSerializer = [AFJSONRequestSerializer serializer];

    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

//    NSString *URL_update_User = [NSString stringWithFormat:@"%@%@",URL_UPDATE_USER,userID];


    [manager PUT:URL_UPDATE_USER parameters:user success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"Success");
         completionHandler(@"YES");

         //
     }
     //Failed To Signup
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {

     }];

}

+(void)forgetPassword:(NSString *)email completion:(void (^)(NSDictionary *))completionHandler
{
    NSDictionary *user = @{@"user": @{@"email":email,
                                      }};

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

    [manager POST:URL_FORGOT_PASSWORD parameters:user success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"Success");
         completionHandler(responseObject);
     }
     //Failed To Signup
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         completionHandler(nil);
     }];
}

+(void)submitPassword:(NSString *)confirmToken password:(NSString *)password confirmPassword:(NSString *)confirmPassword completion:(void (^)(NSDictionary *))completionHandler
{

    NSDictionary *param = @{
                            @"reset_password_token":confirmToken,
                            @"password":password,
                            @"password_confirmation":confirmPassword
                            };

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

    [manager PUT:URL_FORGOT_PASSWORD parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"Success");
         completionHandler(responseObject);
     }
     //Failed To Signup
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         completionHandler(nil);
     }];
}


#pragma mark - BUSINESS

+(void)createBusiness:(NSString *)token businessName:(NSString *)name businessAddress:(NSString *)addr businessPhone:(NSString *)phone businessHours:(NSString *)hours businessType:(NSString *)type longitude:(NSString *)longitude latitude:(NSString *)latitude businessCity:(NSString *)city businessZip:(NSString *)zip businessState:(NSString *)state website:(NSString *)website description:(NSString *)description completion:(void (^)(NSDictionary *))completionHandler
{

    NSDictionary *business = @{@"business":
                                   @{
                                       @"name":name,
                                       @"address":addr,
                                       @"city":city,
                                       @"state":state,
                                       @"zip_code":zip,
                                       @"website":website,
                                       @"phone":phone,
                                       @"hours_of_operation":hours,
                                       @"type_of_business":type,
                                       @"latitude":latitude,
                                       @"longitude":longitude,
                                       @"description":description
                                       },
                               @"auth_token":token
                               };

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept" ];

    [manager POST:URL_CREATE_BUSINESS parameters:business success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"Success");
         completionHandler(responseObject);

         //
     }
     //Failed To Signup
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         completionHandler(nil);
     }];
}

+(void)updateBusiness:(NSString *)token businessName:(NSString *)name businessAddress:(NSString *)addr businessPhone:(NSString *)phone businessHours:(NSString *)hours businessType:(NSString *)type longitude:(NSString *)longitude latitude:(NSString *)latitude businessID:(NSString *)businessID businessDescription:(NSString *)description completion:(void (^)(NSDictionary *))completionHandler
{
    {
        NSDictionary *business = @{@"business":
                                       @{
                                           @"name":name,
                                           @"address":addr,
                                           @"phone":phone,
                                           @"hours_of_operation":hours,
                                           @"type_of_business":type,
                                           @"latitude":latitude,
                                           @"longitude":longitude,
                                           @"description":description
                                           },
                                   @"auth_token":token
                                   };

        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept" ];

        NSString *URL_Update = [NSString stringWithFormat:@"%@%@",URL_UPDATE_BUSINESS_INFO,businessID];

        [manager PUT:URL_Update parameters:business success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             NSLog(@"Success");
             completionHandler(responseObject);

             //
         }
         //Failed To Signup
              failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             completionHandler(nil);
         }];
    }
}


+(void)getBusiness:(NSString *)token completion:(void (^)(NSDictionary*))completionHandler
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept" ];

    NSString *URL_GET_BIZ = [NSString stringWithFormat:@"%@%@",URL_GET_BUSINESS,token];

    [manager GET:URL_GET_BIZ parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"Success");
         completionHandler(responseObject);
     }
     //Failed To Signup
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         completionHandler(nil);
     }];
}

+(void)getBusinessByID:(NSString *)token businessID:(NSString *)businessID completion:(void (^)(NSDictionary *))completionHandler
{
    NSDictionary *param = @{
                            @"auth_token":token
                            };

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept" ];

    NSString *URL_GET_BIZ = [NSString stringWithFormat:@"%@%@",URL_GET_BUSINESS_BY_ID,businessID];

    [manager GET:URL_GET_BIZ parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"Success");
         completionHandler(responseObject);
     }
     //Failed To Signup
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         completionHandler(nil);
     }];
}

#pragma mark - DEALS

+(void)postDeals:(NSString *)token startTime:(NSString *)startTime expirationTime:(NSString *)expTime termsAndCondition:(NSString *)termsConditions quantity:(NSNumber *)quantity dealLevel:(NSString *)level category:(NSString *)category zip:(NSString *)zip businessID:(NSNumber *)businessID dealDescripton:(NSString *)description dealTitle:(NSString *)title completion:(void (^)(NSDictionary*))completionHandler
{
    NSDictionary *deals = @{@"deal": @{

                                      @"start_time":startTime,
                                      @"expiration_time":expTime,
                                      @"terms_and_condition":termsConditions,
                                      @"quantity":quantity,
                                      @"level":level,
                                      @"category":category,
                                      @"zipcode":zip,
                                      @"business_id":businessID,
                                      @"description":description,
                                      @"title":title
                                      },
                           @"auth_token":token
                           };
                       

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    manager.requestSerializer = [AFJSONRequestSerializer serializer];

    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept" ];

     NSString *URL_Post_Deals = [NSString stringWithFormat:@"%@%@/deals",URL_POST_DEALS,businessID];

    [manager POST:URL_Post_Deals parameters:deals success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"Success");
         completionHandler(responseObject);

     }
     //Failed To Signup
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         completionHandler(nil);

     }];
}

+(void)getMarketPlaceDeals:(NSString *)token completion:(void (^)(NSDictionary *))completionHandler
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept" ];

    NSString *URL_GET_Deals = [NSString stringWithFormat:@"%@%@",URL_GET_MARKET_DEALS,token];
    [manager GET:URL_GET_Deals parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"Success");
         completionHandler(responseObject);
     }
     //Failed To Signup
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         completionHandler(nil);

     }];
}

+(void)getMyBusinessDeals:(NSString *)token completion:(void (^)(NSDictionary *))completionHandler
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept" ];

    NSString *URL_GET_Deals = [NSString stringWithFormat:@"%@%@",URL_MY_BUSINESS_DEALS,token];
    [manager GET:URL_GET_Deals parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"Success");
         completionHandler(responseObject);
     }
     //Failed To Signup
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         completionHandler(nil);

     }];
}


+(void)claimDeal:(NSString *)token businessID:(NSString *)businessID dealID:(NSString *)dealID completion:(void (^)(NSDictionary *))completionHandler
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept" ];

    NSString *URL_CLAIM = [NSString stringWithFormat:@"%@%@/deals/%@/send_activation?auth_token=%@",URL_CLAIM_DEAL,businessID,dealID,token];
    [manager GET:URL_CLAIM parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"Success");
         completionHandler(responseObject);
     }
     //Failed To Signup
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         completionHandler(nil);

     }];
}

+(void)searchDeals:(NSString *)token search:(NSString *)search completion:(void (^)(NSDictionary *))completionHandler
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept" ];

    NSString *URL_SEARCH = [NSString stringWithFormat:@"%@?auth_token=%@&search=%@",URL_SEARCH_DEALS,token,search];
    [manager GET:URL_SEARCH parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"Success");
         completionHandler(responseObject);
     }
     //Failed To Signup
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         completionHandler(nil);

     }];
}

#pragma mark Activations

+(void)getActivationsForDeal:(NSString *)token businessID:(NSString *)businessID dealID:(NSString *)dealID completion:(void (^)(NSDictionary *))completionHandler
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept" ];

    NSString *URL_GET_ACTIVATIONS = [NSString stringWithFormat:@"%@%@/deals/%@/activations?auth_token=%@",URL_GET_ALL_ACTIVATIONS_FOR_DEAL,businessID,dealID,token];
    [manager GET:URL_GET_ACTIVATIONS parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"Success");
         completionHandler(responseObject);
     }
     //Failed To Signup
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         completionHandler(nil);
     }];
}

+(void)checkActivationsForDeal:(NSString *)token businessID:(NSString *)businessID dealID:(NSString *)dealID activationCode:(NSString *)code completion:(void (^)(NSDictionary *))completionHandler
{
    NSDictionary *activation = @{
                                 @"entered_code":code,
                                 @"auth_token":token
                               };

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept" ];

    NSString *URL_CHECK_ACT = [NSString stringWithFormat:@"%@%@/deals/%@/check_activation",URL_CHECK_ACTIVATIONS_FOR_DEAL,businessID,dealID];
    [manager PUT:URL_CHECK_ACT parameters:activation success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"Success");
         completionHandler(responseObject);
     }
     //Failed To Signup
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         completionHandler(nil);
     }];
}

+(void)getActivationsForUser:(NSString *)token completion:(void (^)(NSDictionary *))completionHandler
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept" ];

    NSString *URL_GET_Act = [NSString stringWithFormat:@"%@%@",URL_GET_ALL_ACTIVATIONS_FOR_USER,token];

    [manager GET:URL_GET_Act parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"Success");
         completionHandler(responseObject);
     }
     //Failed To Signup
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         completionHandler(nil);
     }];
}


#pragma mark - IMAGE

+(void)postImage:(NSString *)token businessID:(NSString *)businessID dealID:(NSString *)dealID userID:(NSString *)userID type:(NSString *)type photoData:(NSString *)photo mainImage:(NSNumber *)mainImage completion:(void (^)(NSDictionary *))completionHandler
{

    NSDictionary *image;

    if ([type isEqualToString:@"business"]) {

        image = @{@"image": @{@"business_id":businessID,
                                               @"main_image":mainImage,
                                               @"image":photo
                                               },
                                   @"auth_token":token
                                   };
    }
    else if ([type isEqualToString:@"deal"])
    {
       image = @{@"image": @{
                                       @"deal_id":dealID,
                                       @"image":photo
                                       },
                               @"auth_token":token
                               };
    }
    else if ([type isEqualToString:@"user"])
    {
        image = @{@"image": @{
                                       @"user_id":userID,
                                       @"image":photo
                                       },
                               @"auth_token":token
                               };
    }

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    manager.requestSerializer = [AFJSONRequestSerializer serializer];

    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept" ];

    [manager POST:URL_POST_IMAGE parameters:image success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"Success");
         completionHandler(responseObject);

     }
     //Failed To Signup
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         completionHandler(nil);
     }];
}

+(void)getBusinessImage:(NSString *)token completion:(void (^)(NSDictionary *))completionHandler
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept" ];

    NSString *URL_GET_Business_image = [NSString stringWithFormat:@"%@%@",URL_GET_BUSINESS_IMAGE,token];
    [manager GET:URL_GET_Business_image parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"Success");
         completionHandler(responseObject);
     }
     //Failed To Signup
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         completionHandler(nil);

     }];
}

+(void)getProfileImage:(NSString *)token completion:(void (^)(NSDictionary *))completionHandler
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept" ];

    NSString *URL_GET_Profile_image = [NSString stringWithFormat:@"%@%@",URL_GET_PROFILE_IMAGE,token];

    [manager GET:URL_GET_Profile_image parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"Success");
         completionHandler(responseObject);
     }
     //Failed To Signup
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         completionHandler(nil);

     }];
}


+(void)getDealImage:(NSString *)token businessID:(NSString *)businessID dealID:(NSString *)dealID completion:(void (^)(NSDictionary *))completionHandler
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept" ];

    NSString *URL_GET_Deal_image = [NSString stringWithFormat:@"%@%@/deals/%@/deal_photo?auth_token=%@",URL_GET_DEAL_IMAGE,businessID,dealID,token];
    [manager GET:URL_GET_Deal_image parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"Success");
         completionHandler(responseObject);
     }
     //Failed To Signup
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         completionHandler(nil);

     }];
}

+(void)getDealBusinessImage:(NSString *)token businessID:(NSString *)businessID completion:(void (^)(NSDictionary *))completionHandler
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept" ];

    NSString *URL_GET_businessDeal_image = [NSString stringWithFormat:@"%@%@/business_photo?auth_token=%@",URL_GET_DEAL_BUSINESS_IMAGE,businessID,token];
    [manager GET:URL_GET_businessDeal_image parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"Success");
         completionHandler(responseObject);
     }
     //Failed To Signup
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         completionHandler(nil);

     }];
}

+(void)deleteImage:(NSString *)token imageID:(NSString *)imageID completion:(void (^)(NSDictionary *))completionHandler
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept" ];

    NSString *URL_delete_image = [NSString stringWithFormat:@"%@%@?auth_token=%@",URL_DELETE_IMAGE,imageID,token];
    [manager DELETE:URL_delete_image parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"Success");
         completionHandler(responseObject);
     }
     //Failed To Signup
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         completionHandler(nil);

     }];
}




@end
