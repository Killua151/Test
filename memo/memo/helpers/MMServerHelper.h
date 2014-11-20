//
//  FTServerHelper.h
//  fanto
//
//  Created by Ethan Nguyen on 9/24/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"

@class MUser, MBaseQuestion;

@interface MMServerHelper : AFHTTPRequestOperationManager

+ (instancetype)crossSaleHelper;
+ (instancetype)defaultHelper;

#pragma mark - Cross sale methods
- (void)getAllAdsConfigs;
- (void)getRunningAds;

#pragma mark - Default methods
- (void)logInWithUsername:(NSString *)username
                 password:(NSString *)password
               completion:(void(^)(NSDictionary *userData, NSError *error))handler;

- (void)logInWithFacebookId:(NSString *)facebookId
               facebookName:(NSString *)facebookName
                accessToken:(NSString *)accessToken
                 completion:(void(^)(NSDictionary *userData, NSError *error))handler;

- (void)linkFacebookWithFacebookId:(NSString *)facebookId
                       accessToken:(NSString *)accessToken
                        completion:(void(^)(NSError *error))handler;

- (void)logout:(void(^)(NSError *error))handler;

- (void)unlinkFacebook:(void(^)(NSError *error))handler;

- (void)logInWithGmail:(NSString *)gmail
           accessToken:(NSString *)accessToken
            completion:(void(^)(NSDictionary *userData, NSError *error))handler;

- (void)linkGoogleWithGmail:(NSString *)gmail
                accessToken:(NSString *)accessToken
                 completion:(void(^)(NSError *error))handler;

- (void)unlinkGoogle:(void(^)(NSError *error))handler;

- (void)signUpWithFullName:(NSString *)fullName
                     email:(NSString *)email
                  username:(NSString *)username
                  password:(NSString *)password
                completion:(void(^)(NSDictionary *userData, NSError *error))handler;
- (void)sendWelcomeEmail:(NSString *)email;
- (void)forgetPasswordForEmail:(NSString *)email completion:(void(^)(NSError *error))handler;

- (void)extendAuthToken:(void(^)(NSError *error))handler;

- (void)getCourses:(void(^)(NSArray *courses, NSError *error))handler;
- (void)selectCourse:(NSString *)baseCourseId completion:(void(^)(NSError *error))handler;

- (void)getUserProfile:(void(^)(NSDictionary *userData, NSError *error))handler;
- (void)getProfileDetails:(NSString *)friendId completion:(void(^)(MUser *user, NSError *error))handler;
- (void)updateProfile:(NSDictionary *)fields completion:(void(^)(NSError *error))handler;
- (void)updateNotificationSettings:(NSString *)settingsId
                           withKey:(NSString *)settingsKey
                          andValue:(BOOL)settingsValue completion:(void(^)(NSError *error))handler;
- (void)updateBeginnerStatus;

- (void)listFriends:(void(^)(NSArray *followings, NSArray *followers, NSError *error))handler;
- (void)searchFriends:(NSString *)keywords completion:(void(^)(NSArray *results, NSError *error))handler;
- (void)interactFriend:(NSString *)friendId toFollow:(BOOL)follow completion:(void(^)(NSError *error))handler;
- (void)inviteFriendByEmail:(NSString *)email completion:(void(^)(NSString *message, NSError *error))handler;
- (void)findFacebookFriends:(NSString *)fbAccessToken completion:(void(^)(NSArray *results, NSError *error))handler;

- (void)startLesson:(NSInteger)lessonNumber
            inSkill:(NSString *)skillId
         completion:(void(^)(NSString *examToken,
                             NSInteger maxHeartsCount,
                             NSDictionary *availableItems,
                             NSArray *questions, NSError *error))handler;

- (void)startShortcutTest:(NSString *)skillId
               completion:(void(^)(NSString *examToken,
                                   NSInteger maxHeartsCount,
                                   NSDictionary *availableItems,
                                   NSArray *questions, NSError *error))handler;

- (void)startCheckpointTestAtPosition:(NSInteger)checkpointPosition
                           completion:(void(^)(NSString *examToken,
                                               NSInteger maxHeartsCount,
                                               NSDictionary *availableItems,
                                               NSArray *questions, NSError *error))handler;

- (void)startStrengthenSkill:(NSString *)skillId
                  completion:(void(^)(NSString *examToken,
                                      NSInteger maxHeartsCount,
                                      NSDictionary *availableItems,
                                      NSArray *questions, NSError *error))handler;

- (void)startStrengthenAll:(void(^)(NSString *examToken,
                                    NSInteger maxHeartsCount,
                                    NSDictionary *availableItems,
                                    NSArray *questions, NSError *error))handler;

- (void)finishExamWithMetadata:(NSDictionary *)metadata
                    andResults:(NSDictionary *)answerResults
                    completion:(void(^)(NSError *error))handler;

- (void)startPlacementTest:(void(^)(NSString *examToken,
                                    MBaseQuestion *question,
                                    NSInteger questionNumber,
                                    NSInteger totalQuestions,
                                    NSError *error))handler;
- (void)submitPlacementTestAnswer:(NSDictionary *)answerResult
                     withMetadata:(NSDictionary *)metadata
                       completion:(void(^)(NSString *examToken,
                                           MBaseQuestion *question,
                                           NSInteger questionNumber,
                                           NSInteger totalQuestions,
                                           BOOL isFinished,
                                           NSError *error))handler;

- (void)getShopItems:(void(^)(NSInteger virtualMoney, NSArray *items, NSError *error))handler;
- (void)buyItem:(NSString *)itemId completion:(void(^)(NSError *error))handler;
- (void)useItem:(NSString *)itemId completion:(void(^)(NSError *error))handler;

- (void)getAppSettings:(void(^)(NSError *error))handler;

- (void)submitFeedbacks:(NSArray *)feedbacks;

- (void)getDictionary;
- (void)submitViewedWords:(NSDictionary *)viewedWords;

- (void)reportBug:(NSString *)content completion:(void(^)(NSError *error))handler;

- (void)updateApnsToken;
- (void)registerDeviceTokenForAPNS;

@end
