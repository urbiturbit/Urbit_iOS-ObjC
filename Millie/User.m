//
//  User.m
//  Millie
//
//  Created by Emmanuel Masangcay on 6/30/15.
//  Copyright (c) 2015 CoderEXP. All rights reserved.
//

#import "User.h"

@implementation User

+ (User *)sharedSingleton
{
    static User *single = nil;
    {
        //static dispatch_once onceToken;  * Look up
        if ( !single)
        {
            // allocate the shared instance, because it hasn't been done yet
            single = [[User alloc] init];
        }
        return single;
    }
}

@end
