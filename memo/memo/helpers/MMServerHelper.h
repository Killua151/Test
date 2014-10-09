//
//  FTServerHelper.h
//  fanto
//
//  Created by Ethan Nguyen on 9/24/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"

@class MUser;

@interface MMServerHelper : AFHTTPRequestOperationManager

+ (instancetype)sharedHelper;

- (void)logInWithUsername:(NSString *)username
                 password:(NSString *)password
               completion:(void(^)(NSDictionary *userData, NSError *error))handler;

- (void)logInWithFacebookId:(NSString *)facebookId
               facebookName:(NSString *)facebookName
                accessToken:(NSString *)accessToken
                 completion:(void(^)(NSDictionary *userData, NSError *error))handler;

- (void)linkFacebookWithFacebookId:(NSString *)facebookId
                       accessToken:(NSString *)accessToken
                        completion:(void(^)(NSDictionary *userData, NSError *error))handler;

- (void)unlinkFacebook:(void(^)(NSError *error))handler;

- (void)logInWithGmail:(NSString *)gmail
           accessToken:(NSString *)accessToken
            completion:(void(^)(NSDictionary *userData, NSError *error))handler;

- (void)linkGoogleWithGmail:(NSString *)gmail
                accessToken:(NSString *)accessToken
                 completion:(void(^)(NSDictionary *userData, NSError *error))handler;

- (void)unlinkGoogle:(void(^)(NSError *error))handler;

- (void)signUpWithFullName:(NSString *)fullName
                     email:(NSString *)email
                  username:(NSString *)username
                  password:(NSString *)password
                completion:(void(^)(NSDictionary *userData, NSError *error))handler;

- (void)extendAuthToken:(void(^)(NSError *error))handler;

- (void)getUserProfile:(void(^)(NSDictionary *userData, NSError *error))handler;
- (void)getProfileDetails:(void(^)(MUser *user, NSError *error))handler;

- (void)startLesson:(NSInteger)lessonNumber
            inSkill:(NSString *)skillId
         completion:(void(^)(NSString *examToken, NSArray *questions, NSError *error))handler;

- (void)finishLesson:(NSInteger)lessonNumber
             inSkill:(NSString *)skillId
           withToken:(NSString *)examToken
          andResults:(NSDictionary *)answerResults
          completion:(void(^)(NSError *error))handler;

- (void)listFriends:(void(^)(NSArray *followings, NSArray *followers, NSError *error))handler;

- (void)registerDeviceTokenForAPNS;

@end
