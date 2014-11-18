//
//  FTServerHelper.m
//  fanto
//
//  Created by Ethan Nguyen on 9/24/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "MMServerHelper.h"
#import "MMAppDelegate.h"
#import "MUser.h"
#import "MSkill.h"
#import "MBaseQuestion.h"
#import "MFriend.h"
#import "MCourse.h"
#import "MCheckpoint.h"
#import "MItem.h"
#import "MWord.h"
#import "MAppSettings.h"
#import "MAds.h"
#import "MCrossSale.h"

@interface MMServerHelper ()

- (void)logInWithParam:(NSDictionary *)params completion:(void(^)(NSDictionary *userData, NSError *error))handler;
- (void)startExamWithParam:(NSDictionary *)params
                completion:(void(^)(NSString *examToken,
                                    NSInteger maxHeartsCount,
                                    NSDictionary *availableItems,
                                    NSArray *questions, NSError *error))handler;
- (void)interactSocialServicesAtPath:(NSString *)path
                          withParams:(NSDictionary *)params
                          completion:(void(^)(NSError *error))handler;
- (void)handleFailedOperation:(AFHTTPRequestOperation *)operation withError:(NSError *)error fallback:(void(^)())handler;

@end

@implementation MMServerHelper

+ (instancetype)crossSaleHelper {
  static MMServerHelper *_crossSaleHelper = nil;
  
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    NSString *baseUrl = [NSString stringWithFormat:@"%@/", kServerCrossSaleUrl];
    _crossSaleHelper = [[MMServerHelper alloc] initWithBaseURL:[NSURL URLWithString:baseUrl]];
    _crossSaleHelper.responseSerializer = [AFJSONResponseSerializer serializer];
  });
  
  return _crossSaleHelper;
}

+ (instancetype)defaultHelper {
  static MMServerHelper *_defaultHelper = nil;
  
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    NSString *baseUrl = [NSString stringWithFormat:@"%@/%@/", kServerDefaultUrl, kServerApiVersion];
    _defaultHelper = [[MMServerHelper alloc] initWithBaseURL:[NSURL URLWithString:baseUrl]];
    _defaultHelper.responseSerializer = [AFHTTPResponseSerializer serializer];
  });
  
  return _defaultHelper;
}

#pragma mark - Cross sale methods
- (void)getAllAdsConfigs {
  NSDictionary *params = @{
                           kParamAuthToken : [NSString normalizedString:[MUser currentUser].auth_token],
                           kParamDevice : kValueCurrentDevice
                           };
  
  [self
   GET:@"ads/all_configs"
   parameters:params
   success:^(AFHTTPRequestOperation *operation, id responseObject) {
   }
   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
   }];
}

- (void)getRunningAds {
  NSDictionary *params = @{
                           kParamAuthToken : [NSString normalizedString:[MUser currentUser].auth_token],
                           kParamDevice : kValueCurrentDevice
                           };
  
  [self
   GET:@"ads"
   parameters:params
   success:^(AFHTTPRequestOperation *operation, id responseObject) {
     [[MCrossSale sharedModel] loadRunningAds:responseObject];
   }
   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
     DLog(@"%@", error);
   }];
}

#pragma mark - Default methods
- (void)logInWithUsername:(NSString *)username
                 password:(NSString *)password
               completion:(void (^)(NSDictionary *, NSError *))handler {
  [self logInWithParam:@{
                         kParamUsername : [NSString normalizedString:username],
                         kParamPassword : [NSString normalizedString:password]
                         }
            completion:handler];
}

- (void)logInWithFacebookId:(NSString *)facebookId
               facebookName:(NSString *)facebookName
                accessToken:(NSString *)accessToken
                 completion:(void (^)(NSDictionary *, NSError *))handler {
  [self logInWithParam:@{
                         kParamFbName : [NSString normalizedString:facebookName],
                         kParamFbId : [NSString normalizedString:facebookId],
                         kParamFbAccessToken : [NSString normalizedString:accessToken]
                         }
            completion:handler];
}

- (void)logout:(void (^)(NSError *))handler {
  NSDictionary *params = @{kParamAuthToken : [NSString normalizedString:[MUser currentUser].auth_token]};
  
  [self
   POST:@"users/logout"
   parameters:params
   success:^(AFHTTPRequestOperation *operation, id responseObject) {
     handler(nil);
   }
   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
     [self handleFailedOperation:operation withError:error fallback:^{
       handler(error);
     }];
   }];
}

- (void)linkFacebookWithFacebookId:(NSString *)facebookId
                       accessToken:(NSString *)accessToken
                        completion:(void (^)(NSError *))handler {
  NSDictionary *params = @{
                           kParamFbId : [NSString normalizedString:facebookId],
                           kParamFbAccessToken : [NSString normalizedString:accessToken],
                           kParamAuthToken : [NSString normalizedString:[MUser currentUser].auth_token]
                           };
  
  [self interactSocialServicesAtPath:@"users/link_facebook" withParams:params completion:handler];
}

- (void)unlinkFacebook:(void (^)(NSError *))handler {
  NSDictionary *params = @{kParamAuthToken : [NSString normalizedString:[MUser currentUser].auth_token]};
  [self interactSocialServicesAtPath:@"users/unlink_facebook" withParams:params completion:handler];
}

- (void)logInWithGmail:(NSString *)gmail
           accessToken:(NSString *)accessToken
            completion:(void (^)(NSDictionary *, NSError *))handler {
  [self logInWithParam:@{
                         kParamGmail : [NSString normalizedString:gmail],
                         kParamGAccessToken : [NSString normalizedString:accessToken]
                         }
            completion:handler];
}

- (void)linkGoogleWithGmail:(NSString *)gmail
                accessToken:(NSString *)accessToken
                 completion:(void (^)(NSError *))handler {
  NSDictionary *params = @{
                           kParamGmail : [NSString normalizedString:gmail],
                           kParamGAccessToken : [NSString normalizedString:accessToken],
                           kParamAuthToken : [NSString normalizedString:[MUser currentUser].auth_token]
                           };
  
  [self interactSocialServicesAtPath:@"users/link_google" withParams:params completion:handler];
}

- (void)unlinkGoogle:(void (^)(NSError *))handler {
  NSDictionary *params = @{kParamAuthToken : [NSString normalizedString:[MUser currentUser].auth_token]};
  [self interactSocialServicesAtPath:@"users/unlink_google" withParams:params completion:handler];
}

- (void)signUpWithFullName:(NSString *)fullName
                     email:(NSString *)email
                  username:(NSString *)username
                  password:(NSString *)password
                completion:(void (^)(NSDictionary *, NSError *))handler {
  NSMutableDictionary *params =
  [NSMutableDictionary dictionaryWithDictionary:@{
                                                  kParamName : [NSString normalizedString:fullName],
                                                  kParamEmail : [NSString normalizedString:email],
                                                  kParamUsername : [NSString normalizedString:username],
                                                  kParamPassword : [NSString normalizedString:password]
                                                  }];
  
  NSString *apnsToken = [[NSUserDefaults standardUserDefaults] stringForKey:kUserDefApnsToken];
  
  if (apnsToken != nil)
    params[kParamApnsToken] = apnsToken;
  
  [self
   POST:@"users"
   parameters:params
   success:^(AFHTTPRequestOperation *operation, id responseObject) {
     handler([responseObject objectFromJSONData], nil);
   }
   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
     [self handleFailedOperation:operation withError:error fallback:^{
       handler(nil, error);
     }];
   }];
}

- (void)forgetPasswordForEmail:(NSString *)email completion:(void (^)(NSError *))handler {
  NSDictionary *params = @{kParamEmail : [NSString normalizedString:email]};
  
  [self
   POST:@"users/forget_password"
   parameters:params
   success:^(AFHTTPRequestOperation *operation, id responseObject) {
     handler(nil);
   }
   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
     [self handleFailedOperation:operation withError:error fallback:^{
       handler(error);
     }];
   }];
}

- (void)extendAuthToken:(void (^)(NSError *))handler {
  NSDictionary *params = @{kParamAuthToken : [NSString normalizedString:[MUser currentUser].auth_token]};
  
  [self
   POST:@"users/extendauthtoken"
   parameters:params
   success:^(AFHTTPRequestOperation *operation, id responseObject) {
     handler(nil);
   }
   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
     handler(error);
   }];
}

- (void)getCourses:(void (^)(NSArray *, NSError *))handler {
  NSDictionary *params = @{kParamAuthToken : [NSString normalizedString:[MUser currentUser].auth_token]};
  
  [self
   GET:@"courses"
   parameters:params
   success:^(AFHTTPRequestOperation *operation, id responseObject) {
     NSArray *courses = [MCourse modelsFromArr:[responseObject objectFromJSONData]];
     handler(courses, nil);
   }
   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
     [self handleFailedOperation:operation withError:error fallback:^{
       handler(nil, error);
     }];
   }];
}

- (void)selectCourse:(NSString *)baseCourseId completion:(void (^)(NSError *))handler {
  NSDictionary *params = @{
                           kParamAuthToken : [NSString normalizedString:[MUser currentUser].auth_token],
                           kParamBaseCourseId : [NSString normalizedString:baseCourseId]
                           };
  
  [self
   POST:@"users/select_course"
   parameters:params
   success:^(AFHTTPRequestOperation *operation, id responseObject) {
     handler(nil);
   }
   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
     [self handleFailedOperation:operation withError:error fallback:^{
       handler(error);
     }];
   }];
}

- (void)getUserProfile:(void (^)(NSDictionary *, NSError *))handler {
  NSDictionary *params = @{kParamAuthToken : [NSString normalizedString:[MUser currentUser].auth_token]};
  
  [self
   GET:[NSString stringWithFormat:@"users/%@", [MUser currentUser]._id]
   parameters:params
   success:^(AFHTTPRequestOperation *operation, id responseObject) {
     NSDictionary *userData = [responseObject objectFromJSONData];
     [[MUser currentUser] updateAttributesFromProfileData:userData];
     
     [self getAppSettings:^(NSError *error) {
       if (error != nil)
         handler(nil, error);
       else
         handler(userData, nil);
     }];
   }
   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
     [self handleFailedOperation:operation withError:error fallback:^{
       handler(nil, error);
     }];
   }];
}

- (void)getProfileDetails:(NSString *)friendId completion:(void (^)(MUser *, NSError *))handler {
  NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:
  @{kParamAuthToken : [NSString normalizedString:[MUser currentUser].auth_token]}];
  
  BOOL isFriend = friendId != nil && ![friendId isEqualToString:[MUser currentUser]._id];
  
  if (isFriend)
    params[kParamFriendId] = friendId;
  
  [self
   GET:@"users/profile_details"
   parameters:params
   success:^(AFHTTPRequestOperation *operation, id responseObject) {
     NSDictionary *userData = [responseObject objectFromJSONData];
     
     MUser *user = [MUser currentUser];
     
     if (isFriend)
       user = [MUser new];
     
     [user assignProperties:userData];
     handler(user, nil);
   }
   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
     [self handleFailedOperation:operation withError:error fallback:^{
       handler(nil, error);
     }];
   }];
}

- (void)updateProfile:(NSDictionary *)fields completion:(void (^)(NSError *))handler {
  NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:fields];
  params[kParamAuthToken] = [NSString normalizedString:[MUser currentUser].auth_token];
  
  [self
   POST:@"users/edit"
   parameters:params
   success:^(AFHTTPRequestOperation *operation, id responseObject) {
     handler(nil);
   }
   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
     [self handleFailedOperation:operation withError:error fallback:^{
       handler(error);
     }];
   }];
}

- (void)updateNotificationSettings:(NSString *)settingsId
                           withKey:(NSString *)settingsKey
                          andValue:(BOOL)settingsValue completion:(void (^)(NSError *))handler {
  NSDictionary *params = @{
                           kParamAuthToken : [NSString normalizedString:[MUser currentUser].auth_token],
                           kParamSetting : [@{
                                              kParamId : [NSString normalizedString:settingsId],
                                              [NSString normalizedString:settingsKey] : @(settingsValue)
                                              } JSONString]
                           };
  
  [self
   POST:@"users/edit_setting"
   parameters:params
   success:^(AFHTTPRequestOperation *operation, id responseObject) {
     handler(nil);
   }
   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
     [self handleFailedOperation:operation withError:error fallback:^{
       handler(error);
     }];
   }];
}

- (void)updateBeginnerStatus {
  if (![MUser currentUser].is_beginner)
    return;
  
  NSDictionary *params = @{kParamAuthToken : [NSString normalizedString:[MUser currentUser].auth_token]};
  [self POST:@"users/update_is_beginner" parameters:params success:NULL failure:NULL];
}

- (void)listFriends:(void (^)(NSArray *, NSArray *, NSError *))handler {
  NSDictionary *params = @{kParamAuthToken : [NSString normalizedString:[MUser currentUser].auth_token]};
  
  [self
   GET:@"users/list_friends"
   parameters:params
   success:^(AFHTTPRequestOperation *operation, id responseObject) {
   }
   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
   }];
}

- (void)searchFriends:(NSString *)keywords completion:(void (^)(NSArray *, NSError *))handler {
  NSDictionary *params = @{
                           kParamAuthToken : [NSString normalizedString:[MUser currentUser].auth_token],
                           kParamKeywords : [NSString normalizedString:keywords]
                           };
  [self
   POST:@"users/search_friends"
   parameters:params
   success:^(AFHTTPRequestOperation *operation, id responseObject) {
     NSArray *searchResults = [MFriend modelsFromArr:[responseObject objectFromJSONData]];
     handler(searchResults, nil);
   }
   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
     [self handleFailedOperation:operation withError:error fallback:^{
       handler(nil, error);
     }];
   }];
}

- (void)interactFriend:(NSString *)friendId toFollow:(BOOL)follow completion:(void (^)(NSError *))handler {
  NSDictionary *params = @{
                           kParamAuthToken : [NSString normalizedString:[MUser currentUser].auth_token],
                           kParamFriendId : [NSString normalizedString:friendId]
                           };
  NSString *interactAction = follow ? @"follow" : @"unfollow";
  
  [self
   POST:[NSString stringWithFormat:@"users/%@", interactAction]
   parameters:params
   success:^(AFHTTPRequestOperation *operation, id responseObject) {
     NSDictionary *userData = [responseObject objectFromJSONData];
     [[MUser currentUser] assignProperties:userData];
     handler(nil);
   }
   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
     [self handleFailedOperation:operation withError:error fallback:^{
       handler(error);
     }];
   }];
}

- (void)inviteFriendByEmail:(NSString *)email completion:(void (^)(NSString *, NSError *))handler {
  NSDictionary *params = @{
                           kParamAuthToken : [NSString normalizedString:[MUser currentUser].auth_token],
                           kParamEmail : [NSString normalizedString:email]
                           };
  
  [self
   POST:@"users/invite_by_email"
   parameters:params
   success:^(AFHTTPRequestOperation *operation, id responseObject) {
     handler(MMLocalizedString(@"Invite email sent successfully"), nil);
   }
   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
     [self handleFailedOperation:operation withError:error fallback:^{
       handler(nil, error);
     }];
   }];
}

- (void)findFacebookFriends:(NSString *)fbAccessToken completion:(void (^)(NSArray *, NSError *))handler {
  NSDictionary *params = @{
                           kParamAuthToken : [NSString normalizedString:[MUser currentUser].auth_token],
                           kParamFbAccessToken : [NSString normalizedString:fbAccessToken]
                           };
  
  [self
   POST:@"users/search_fb_friend"
   parameters:params
   success:^(AFHTTPRequestOperation *operation, id responseObject) {
     NSArray *searchResults = [MFriend modelsFromArr:[responseObject objectFromJSONData]];
     handler(searchResults, nil);
   }
   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
     [self handleFailedOperation:operation withError:error fallback:^{
       handler(nil, error);
     }];
   }];
}

- (void)startLesson:(NSInteger)lessonNumber
            inSkill:(NSString *)skillId
         completion:(void (^)(NSString *, NSInteger, NSDictionary *, NSArray *, NSError *))handler {
  NSDictionary *params = @{
                           kParamType : kValueExamTypeLesson,
                           kParamLessonNumber : @(lessonNumber),
                           kParamSkillId : [NSString normalizedString:skillId],
                           kParamAuthToken : [NSString normalizedString:[MUser currentUser].auth_token]
                           };
  
  [self startExamWithParam:params completion:handler];
}

- (void)startShortcutTest:(NSString *)skillId
               completion:(void (^)(NSString *, NSInteger, NSDictionary *, NSArray *, NSError *))handler {
  NSDictionary *params = @{
                           kParamType : kValueExamTypeShortcut,
                           kParamSkillId : [NSString normalizedString:skillId],
                           kParamAuthToken : [NSString normalizedString:[MUser currentUser].auth_token]
                           };
  
  [self startExamWithParam:params completion:handler];
}

- (void)startCheckpointTestAtPosition:(NSInteger)checkpointPosition
                           completion:(void (^)(NSString *, NSInteger, NSDictionary *, NSArray *, NSError *))handler {
  NSDictionary *params = @{
                           kParamType : kValueExamTypeCheckpoint,
                           kParamCheckpointPosition : @(checkpointPosition),
                           kParamAuthToken : [NSString normalizedString:[MUser currentUser].auth_token]
                           };
  
  [self startExamWithParam:params completion:handler];
}

- (void)startStrengthenSkill:(NSString *)skillId
                  completion:(void (^)(NSString *, NSInteger, NSDictionary *, NSArray *, NSError *))handler {
  NSDictionary *params = @{
                           kParamType : kValueExamTypeStrengthenSkill,
                           kParamSkillId : [NSString normalizedString:skillId],
                           kParamAuthToken : [NSString normalizedString:[MUser currentUser].auth_token]
                           };
  
  [self startExamWithParam:params completion:handler];
}

- (void)startStrengthenAll:(void (^)(NSString *, NSInteger, NSDictionary *, NSArray *, NSError *))handler {
  NSDictionary *params = @{
                           kParamType : kValueExamTypeStrengthenAll,
                           kParamAuthToken : [NSString normalizedString:[MUser currentUser].auth_token]
                           };
  
  [self startExamWithParam:params completion:handler];
}

- (void)finishExamWithMetadata:(NSDictionary *)metadata
                    andResults:(NSDictionary *)answerResults
                    completion:(void (^)(NSError *))handler {
  NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:metadata];
  params[kParamAuthToken] = [NSString normalizedString:[MUser currentUser].auth_token];
  params[kParamAnswers] = [answerResults JSONString];
  
  [self
   POST:@"exam/finish"
   parameters:params
   success:^(AFHTTPRequestOperation *operation, id responseObject) {
     [MUser currentUser].lastReceivedBonuses = [responseObject objectFromJSONData];
     handler(nil);
   }
   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
     [self handleFailedOperation:operation withError:error fallback:^{
       handler(error);
     }];
   }];
}

- (void)startPlacementTest:(void (^)(NSString *, MBaseQuestion *, NSInteger, NSInteger, NSError *))handler {
  NSDictionary *params = @{
                           kParamAuthToken : [NSString normalizedString:[MUser currentUser].auth_token],
                           kParamDevice : kValueCurrentDevice,
                           kParamSpeakEnabled : @([[NSUserDefaults standardUserDefaults] boolForKey:kUserDefSpeakEnabled])
                           };
  
  [self
   POST:@"placement_test/start"
   parameters:params
   success:^(AFHTTPRequestOperation *operation, id responseObject) {
     NSDictionary *responseDict = [responseObject objectFromJSONData];
     NSInteger questionNumber = [responseDict[kParamNumQuestions] integerValue];
     NSInteger totalQuestions = [responseDict[kParamTotalNumQuestions] integerValue];
     MBaseQuestion *question = [MBaseQuestion modelFromDict:responseDict[kParamQuestion]];
     handler(responseDict[kParamExamToken], question, questionNumber, totalQuestions, nil);
   }
   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
     [self handleFailedOperation:operation withError:error fallback:^{
       handler(nil, nil, -1, -1, error);
     }];
   }];
}

- (void)submitPlacementTestAnswer:(NSDictionary *)answerResult
                     withMetadata:(NSDictionary *)metadata
                       completion:(void (^)(NSString *, MBaseQuestion *, NSInteger, NSInteger, BOOL, NSError *))handler {
  NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:metadata];
  params[kParamAuthToken] = [NSString normalizedString:[MUser currentUser].auth_token];
  params[kParamAnswer] = [answerResult JSONString];
  params[kParamDevice] = kValueCurrentDevice;
  params[kParamSpeakEnabled] = @([[NSUserDefaults standardUserDefaults] boolForKey:kUserDefSpeakEnabled]);
  
  [self
   POST:@"placement_test/submit_answer"
   parameters:params
   success:^(AFHTTPRequestOperation *operation, id responseObject) {
     NSDictionary *responseDict = [responseObject objectFromJSONData];
     
     BOOL finished = responseDict[kParamQuestion] == nil;
     
     if (finished) {
       [MUser currentUser].lastReceivedBonuses = responseDict;
       handler(nil, nil, -1, -1, YES, nil);
       return;
     }
     
     NSInteger questionNumber = [responseDict[kParamNumQuestions] integerValue];
     NSInteger totalQuestions = [responseDict[kParamTotalNumQuestions] integerValue];
     MBaseQuestion *question = [MBaseQuestion modelFromDict:responseDict[kParamQuestion]];
     handler(responseDict[kParamExamToken], question, questionNumber, totalQuestions, NO, nil);
   }
   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
     [self handleFailedOperation:operation withError:error fallback:^{
       handler(nil, nil, -1, -1, NO, error);
     }];
   }];
}

- (void)getShopItems:(void (^)(NSInteger, NSArray *, NSError *))handler {
  NSDictionary *params = @{
                           kParamAuthToken : [NSString normalizedString:[MUser currentUser].auth_token],
                           kParamDevice : kValueCurrentDevice,
                           kParamLocalize : PreferedAppLanguage()
                           };
  
  [self
   GET:@"plaza"
   parameters:params
   success:^(AFHTTPRequestOperation *operation, id responseObject) {
     NSDictionary *responseDict = [responseObject objectFromJSONData];
     NSInteger virtualMoney = [responseDict[kParamVirtualMoney] integerValue];
     NSArray *items = [MItem modelsFromArr:responseDict[kParamItems]];
     handler(virtualMoney, items, nil);
   }
   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
     [self handleFailedOperation:operation withError:error fallback:^{
       handler(0, nil, nil);
     }];
   }];
}

- (void)buyItem:(NSString *)itemId completion:(void (^)(NSError *))handler {
  NSDictionary *params = @{
                           kParamAuthToken : [NSString normalizedString:[MUser currentUser].auth_token],
                           kParamDevice : kValueCurrentDevice,
                           kParamBaseItemId : [NSString normalizedString:itemId],
                           };
  
  [self
   POST:@"plaza/buy_item"
   parameters:params
   success:^(AFHTTPRequestOperation *operation, id responseObject) {
     handler(nil);
   }
   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
     [self handleFailedOperation:operation withError:error fallback:^{
       handler(error);
     }];
   }];
}

- (void)useItem:(NSString *)itemId completion:(void (^)(NSError *))handler {
  NSDictionary *params = @{
                           kParamAuthToken : [NSString normalizedString:[MUser currentUser].auth_token],
                           kParamDevice : kValueCurrentDevice,
                           kParamBaseItemId : [NSString normalizedString:itemId],
                           };
  
  [self
   POST:@"plaza/use_item"
   parameters:params
   success:^(AFHTTPRequestOperation *operation, id responseObject) {
     handler(nil);
   }
   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
     [self handleFailedOperation:operation withError:error fallback:^{
       handler(error);
     }];
   }];
}

- (void)getAppSettings:(void (^)(NSError *))handler {
  NSDictionary *params = @{
                           kParamAuthToken : [NSString normalizedString:[MUser currentUser].auth_token],
                           kParamDevice : kValueCurrentDevice
                           };
  
  [self
   GET:@"appsettings"
   parameters:params
   success:^(AFHTTPRequestOperation *operation, id responseObject) {
     NSDictionary *responseDict = [responseObject objectFromJSONData];
     [MAppSettings loadAppSettings:responseDict];
     handler(nil);
   }
   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
     [self handleFailedOperation:operation withError:error fallback:^{
       handler(error);
     }];
   }];
}

- (void)submitFeedbacks:(NSArray *)feedbacks {
  NSDictionary *params = @{
                           kParamAuthToken : [NSString normalizedString:[MUser currentUser].auth_token],
                           kParamFeedbacks : [feedbacks JSONString]
                           };
  
  [self
   POST:@"feedback/create"
   parameters:params
   success:^(AFHTTPRequestOperation *operation, id responseObject) {
   }
   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
     [self handleFailedOperation:operation withError:error fallback:NULL];
   }];
}

- (void)getDictionary {
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  id savedDictionaryData = [userDefaults objectForKey:kUserDefWordsDictionary];
  NSInteger dictionaryVersion = [userDefaults integerForKey:kUserDefDictionaryVersion];
  
  if ([savedDictionaryData count] > 0)
    [[MWord sharedModel] setupDictionary:savedDictionaryData];
  else
    dictionaryVersion = 0;
  
  NSDictionary *params = @{kParamVersion : @(dictionaryVersion)};
  
  [self
   GET:@"words"
   parameters:params
   success:^(AFHTTPRequestOperation *operation, id responseObject) {
     NSDictionary *responseDict = [responseObject objectFromJSONData];
     NSInteger newVersion = [responseDict[kParamVersion] integerValue];
     
     if (newVersion <= dictionaryVersion && [savedDictionaryData count] > 0)
       return;
     
     [userDefaults setInteger:newVersion forKey:kUserDefDictionaryVersion];
     [userDefaults setObject:responseDict[kParamWords] forKey:kUserDefWordsDictionary];
     [userDefaults synchronize];
     
     [[MWord sharedModel] setupDictionary:responseDict[kParamWords]];
   }
   failure:NULL];
}

- (void)submitViewedWords:(NSDictionary *)viewedWords {
  if (viewedWords == nil || ![viewedWords isKindOfClass:[NSDictionary class]] || [viewedWords count] == 0)
    return;
  
  NSDictionary *params = @{
                           kParamAuthToken : [NSString normalizedString:[MUser currentUser].auth_token],
                           kParamWords : [viewedWords JSONString]
                           };
  
  [self POST:@"words" parameters:params success:NULL failure:NULL];
}

- (void)reportBug:(NSString *)content completion:(void (^)(NSError *))handler {
  NSDictionary *params = @{
                           kParamAuthToken : [NSString normalizedString:[MUser currentUser].auth_token],
                           kParamContent : [NSString normalizedString:content],
                           kParamDevice : kValueCurrentDevice,
                           kParamVersion : CurrentBuildVersion()
                           };
  
  [self
   POST:@"bug_report"
   parameters:params
   success:^(AFHTTPRequestOperation *operation, id responseObject) {
     handler(nil);
   }
   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
     [self handleFailedOperation:operation withError:error fallback:^{
       handler(error);
     }];
   }];
}

- (void)updateApnsToken {
  NSString *apnsToken = [[NSUserDefaults standardUserDefaults] stringForKey:kUserDefApnsToken];
  
  if (apnsToken == nil || ![apnsToken isKindOfClass:[NSString class]])
    return;
  
  NSDictionary *params = @{
                           kParamAuthToken : [NSString normalizedString:[MUser currentUser].auth_token],
                           kParamApnsToken : apnsToken
                           };
  
#if kTestPushNotification
  DLog(@"%@", params);
#endif
  
  [self
   POST:@"notification/update"
   parameters:params
   success:^(AFHTTPRequestOperation *operation, id responseObject) {
#if kTestPushNotification
     DLog(@"%@", [responseObject objectFromJSONData]);
#endif
   }
   failure:NULL];
}

- (void)registerDeviceTokenForAPNS {
  NSString *deviceToken = [[NSUserDefaults standardUserDefaults] stringForKey:kUserDefApnsToken];
  
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:
                                  [NSURL URLWithString:@"https://api.parse.com/1/installations"]];
  [request setHTTPMethod:@"POST"];
  [request setValue:kParseApplicationId forHTTPHeaderField:@"X-Parse-Application-Id"];
  [request setValue:kParseRestApiKey forHTTPHeaderField:@"X-Parse-REST-API-Key"];
  [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
  
  NSDictionary *params = @{
                           @"deviceType" : kValueCurrentDevice,
                           @"deviceToken" : [NSString normalizedString:deviceToken],
#if kTestPushNotification
                           @"channels": @[@"test_apns"]
#else
                           @"channels": @[@""]
#endif
                           };
  
#if kTestPushNotification
  DLog(@"%@", params);
#endif
  
  [request setHTTPBody:[params JSONData]];
  AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
  [operation
   setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
#if kTestPushNotification
     DLog(@"%@", [responseObject objectFromJSONData]);
#endif
   }
   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
   }];
  
  [operation start];
}

#pragma mark - Private methods
- (void)logInWithParam:(NSDictionary *)params completion:(void (^)(NSDictionary *, NSError *))handler {
  NSMutableDictionary *paramsDict = [NSMutableDictionary dictionaryWithDictionary:params];
  
  NSString *apnsToken = [[NSUserDefaults standardUserDefaults] stringForKey:kUserDefApnsToken];
  
  if (apnsToken != nil)
    paramsDict[kParamApnsToken] = apnsToken;
  
  [self
   POST:@"users/login"
   parameters:paramsDict
   success:^(AFHTTPRequestOperation *operation, id responseObject) {
     NSDictionary *userData = [responseObject objectFromJSONData];
     
     [Utils updateSavedUserWithAttributes:userData];
     [MUser loadCurrentUserFromUserDef];
     
     [self getAppSettings:^(NSError *error) {
       if (error != nil) {
         handler(nil, error);
         return;
       }
       
       if (userData != nil && [userData isKindOfClass:[NSDictionary class]])
         handler(userData, nil);
       else
         handler(nil, [NSError errorWithDomain:MMLocalizedString(@"Unknown error") code:-1 userInfo:nil]);
     }];
   }
   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
     [self handleFailedOperation:operation withError:error fallback:^{
       handler(nil, error);
     }];
   }];
}

- (void)startExamWithParam:(NSDictionary *)params
                completion:(void (^)(NSString *, NSInteger, NSDictionary *, NSArray *, NSError *))handler {
  if (![AFNetworkReachabilityManager sharedManager].reachable) {
    BOOL speakEnabled = [[NSUserDefaults standardUserDefaults] boolForKey:kUserDefSpeakEnabled];
    
    if (speakEnabled) {
      [UIAlertView
       showWithTitle:MMLocalizedString(@"No internet connection")
       andMessage:MMLocalizedString(@"No internet connection available. Check your network connection and try again.")];
      return;
    }
  }
  
  NSMutableDictionary *paramsDict = [NSMutableDictionary dictionaryWithDictionary:params];
  paramsDict[kParamDevice] = kValueCurrentDevice;
  paramsDict[kParamSpeakEnabled] = @([[NSUserDefaults standardUserDefaults] boolForKey:kUserDefSpeakEnabled]);
  
  [self
   POST:@"exam/start"
   parameters:params
   success:^(AFHTTPRequestOperation *operation, id responseObject) {
     NSDictionary *responseDict = [responseObject objectFromJSONData];
     handler(responseDict[kParamExamToken],
             [responseDict[kParamMaxHeartsCount] integerValue],
             responseDict[kParamAvailableItems],
             [MBaseQuestion modelsFromArr:responseDict[kParamQuestions]],
             nil);
   }
   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
     [self handleFailedOperation:operation withError:error fallback:^{
       handler(nil, 0, nil, nil, error);
     }];
   }];
}

- (void)interactSocialServicesAtPath:(NSString *)path
                          withParams:(NSDictionary *)params
                          completion:(void (^)(NSError *))handler {
  [self
   POST:path
   parameters:params
   success:^(AFHTTPRequestOperation *operation, id responseObject) {
     handler(nil);
   }
   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
     [self handleFailedOperation:operation withError:error fallback:^{
       handler(error);
     }];
   }];
}

- (void)handleFailedOperation:(AFHTTPRequestOperation *)operation withError:(NSError *)error fallback:(void (^)())handler {
  if ([[operation response] statusCode] == 401) {
    MMAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [MUser logOutCurrentUser];
    [appDelegate setupRootViewController];
    [UIAlertView showWithTitle:MMLocalizedString(@"Error") andMessage:[error errorMessage]];
    return;
  }
  
  if (handler != NULL)
    handler();
}

@end
