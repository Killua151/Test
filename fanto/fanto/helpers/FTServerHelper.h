//
//  FTServerHelper.h
//  fanto
//
//  Created by Ethan Nguyen on 9/24/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"

@interface FTServerHelper : AFHTTPRequestOperationManager

+ (instancetype)sharedHelper;

- (void)logInWithUsername:(NSString *)username
                 password:(NSString *)password
               completion:(void(^)(NSDictionary *userData, NSError *error))handler;

- (void)logInWithFacebookId:(NSString *)facebookId
                accessToken:(NSString *)accessToken
                 completion:(void(^)(NSDictionary *userData, NSError *error))handler;

- (void)logInWithGmail:(NSString *)gmail
           accessToken:(NSString *)accessToken
            completion:(void(^)(NSDictionary *userData, NSError *error))handler;

- (void)signUpWithFullName:(NSString *)fullName
                     email:(NSString *)email
                  username:(NSString *)username
                  password:(NSString *)password
                completion:(void(^)(NSDictionary *userData, NSError *error))handler;

- (void)extendAuthToken:(void(^)(NSError *error))handler;

@end
