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

+ (instancetype)sharedHelper {
  static MMServerHelper *_sharedHelper = nil;
  
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    NSString *baseUrl = [NSString stringWithFormat:@"%@/%@/", kServerApiUrl, kServerApiVersion];
    _sharedHelper = [[MMServerHelper alloc] initWithBaseURL:[NSURL URLWithString:baseUrl]];
    _sharedHelper.responseSerializer = [AFHTTPResponseSerializer serializer];
  });
  
  return _sharedHelper;
}

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
     handler(userData, nil);
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
  handler(MMLocalizedString(@"Invite email sent successfully"), nil);
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

- (void)startPlacementTest:(void (^)(NSString *, MBaseQuestion *, NSError *))handler {
  NSDictionary *params = @{
                           kParamAuthToken : [NSString normalizedString:[MUser currentUser].auth_token],
                           kParamDevice : @"ios",
                           kParamSpeakEnabled : @([[NSUserDefaults standardUserDefaults] boolForKey:kUserDefSpeakEnabled])
                           };
  
  [self
   POST:@"placement_test/start"
   parameters:params
   success:^(AFHTTPRequestOperation *operation, id responseObject) {
     NSDictionary *responseDict = [responseObject objectFromJSONData];
     MBaseQuestion *question = [MBaseQuestion modelFromDict:responseDict[kParamQuestion]];
     handler(responseDict[kParamExamToken], question, nil);
   }
   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
     [self handleFailedOperation:operation withError:error fallback:^{
       handler(nil, nil, error);
     }];
   }];
}

- (void)submitPlacementTestAnswer:(NSDictionary *)answerResult
                     withMetadata:(NSDictionary *)metadata
                       completion:(void (^)(NSString *, MBaseQuestion *, BOOL, NSError *))handler {
  NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:metadata];
  params[kParamAuthToken] = [NSString normalizedString:[MUser currentUser].auth_token];
  params[kParamAnswer] = [answerResult JSONString];
  params[kParamDevice] = @"ios";
  params[kParamSpeakEnabled] = @([[NSUserDefaults standardUserDefaults] boolForKey:kUserDefSpeakEnabled]);
  
  [self
   POST:@"placement_test/submit_answer"
   parameters:params
   success:^(AFHTTPRequestOperation *operation, id responseObject) {
     NSDictionary *responseDict = [responseObject objectFromJSONData];
     
     BOOL finished = responseDict[kParamQuestion] == nil;
     
     if (finished) {
       [MUser currentUser].lastReceivedBonuses = responseDict;
       handler(nil, nil, YES, nil);
       return;
     }
     
     MBaseQuestion *question = [MBaseQuestion modelFromDict:responseDict[kParamQuestion]];
     handler(responseDict[kParamExamToken], question, NO, nil);
   }
   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
     DLog(@"%@", operation.responseString);
     
     [self handleFailedOperation:operation withError:error fallback:^{
       handler(nil, nil, NO, error);
     }];
   }];
}

- (void)getShopItems:(void (^)(NSInteger, NSArray *, NSError *))handler {
  NSDictionary *params = @{
                           kParamAuthToken : [NSString normalizedString:[MUser currentUser].auth_token],
                           kParamDevice : @"ios",
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
                           kParamDevice : @"ios",
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
                           kParamDevice : @"ios",
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

- (void)submitFeedbackInQuestion:(NSString *)questionLogId
                     forSentence:(NSString *)sentenceText
                      completion:(void (^)(NSError *))handler {
  NSDictionary *params = @{
                           kParamAuthToken : [NSString normalizedString:[MUser currentUser].auth_token],
                           kParamQuestionLogId : [NSString normalizedString:questionLogId],
                           kParamContent : [NSString normalizedString:sentenceText],
                           kParamAutoFeedback : @(YES)
                           };
  
  [self
   POST:@"feedback/create"
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

- (void)getDictionary {
  NSInteger dictionaryVersion = [[NSUserDefaults standardUserDefaults] integerForKey:kUserDefDictionaryVersion];
  
  NSDictionary *params = @{kParamVersion : @(dictionaryVersion)};
  
  [self
   GET:@"words"
   parameters:params
   success:^(AFHTTPRequestOperation *operation, id responseObject) {
     NSDictionary *responseDict = [responseObject objectFromJSONData];
     NSInteger newVersion = [responseDict[kParamVersion] integerValue];
     [[NSUserDefaults standardUserDefaults] setInteger:newVersion forKey:kUserDefDictionaryVersion];
     [[NSUserDefaults standardUserDefaults] synchronize];
     [[MWord sharedModel] setupDictionary:responseDict[kParamWords]];
   }
   failure:NULL];
}

- (void)submitViewedWords:(NSDictionary *)viewedWords {
  NSDictionary *params = @{
                           kParamAuthToken : [NSString normalizedString:[MUser currentUser].auth_token],
                           kParamWords : viewedWords
                           };
  
  [self POST:@"words" parameters:params success:NULL failure:NULL];
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
                           @"deviceType" : @"ios",
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
   parameters:params
   success:^(AFHTTPRequestOperation *operation, id responseObject) {
     NSDictionary *userData = [responseObject objectFromJSONData];
     
     if (userData != nil && [userData isKindOfClass:[NSDictionary class]])
       handler(userData, nil);
     else
       handler(nil, [NSError errorWithDomain:@"Unknown error" code:-1 userInfo:nil]);
   }
   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
     [self handleFailedOperation:operation withError:error fallback:^{
       handler(nil, error);
     }];
   }];
}

- (void)startExamWithParam:(NSDictionary *)params
                completion:(void (^)(NSString *, NSInteger, NSDictionary *, NSArray *, NSError *))handler {
  NSString *response = @"{\"exam_token\":\"EthanNguyen_544524a0b2466\",\"questions\":[{\"type\":\"translate\",\"question\":\"Girl\",\"translation\":\"C\u00f4 g\u00e1i\",\"compact_translations\":[[\"C\u00f4 g\u00e1i\"],[[\"C\u00f4 g\u00e1i\",\"C\u00f4 b\u00e9\"]],[[\"Ng\u01b0\u1eddi\",\"\u0110\u1ee9a\",\"C\u00f4\"],\" con g\u00e1i\"],[\"B\u00e9 g\u00e1i\"]],\"common_errors\":[],\"special_objectives\":[\"girl\"],\"objectives\":[],\"normal_question_audio\":\"http://api.memo.edu.vn/static/1.1/sentence_sounds/normal_751fbab2-ee58-43c4-9534-94c84ff338f5.mp3\",\"question_log_id\":\"544524a02d917169a4b7add1\"},{\"type\":\"translate\",\"question\":\"I am a man.\",\"translation\":\"T\u00f4i l\u00e0 m\u1ed9t ng\u01b0\u1eddi \u0111\u00e0n \u00f4ng.\",\"compact_translations\":[[\"T\u00f4i l\u00e0 m\u1ed9t ng\u01b0\u1eddi \u0111\u00e0n \u00f4ng.\"],[\"T\u00f4i l\u00e0 m\u1ed9t ng\u01b0\u1eddi nam.\"],[\"T\u00f4i l\u00e0 m\u1ed9t \",[\"con\",\"\"],\" ng\u01b0\u1eddi.\"]],\"common_errors\":[],\"special_objectives\":[\"man\"],\"objectives\":[],\"normal_question_audio\":\"http://api.memo.edu.vn/static/1.1/sentence_sounds/normal_a5ed5278-a985-48bd-8a09-6bf1ca7abc62.mp3\",\"question_log_id\":\"544524a02d917169a4b7add2\"},{\"type\":\"translate\",\"question\":\"I am a girl.\",\"translation\":\"T\u00f4i l\u00e0 m\u1ed9t c\u00f4 g\u00e1i.\",\"compact_translations\":[[\"T\u00f4i l\u00e0 m\u1ed9t c\u00f4 g\u00e1i.\"],[\"T\u00f4i l\u00e0 m\u1ed9t \",[\"c\u00f4 b\u00e9\",\"c\u00f4 con g\u00e1i\",\"ng\u01b0\u1eddi con g\u00e1i\",\"b\u00e9 g\u00e1i\",\"\u0111\u1ee9a con g\u00e1i\",\"\u0111\u1ee9a b\u00e9 g\u00e1i\"],\".\"]],\"common_errors\":[],\"special_objectives\":[\"girl\"],\"objectives\":[],\"normal_question_audio\":\"http://api.memo.edu.vn/static/1.1/sentence_sounds/normal_db4b62e4-b859-43cb-8997-b8cbd34bb8a5.mp3\",\"question_log_id\":\"544524a02d917169a4b7add3\"},{\"type\":\"translate\",\"question\":\"Man\",\"translation\":\"Ng\u01b0\u1eddi \u0111\u00e0n \u00f4ng\",\"compact_translations\":[[\"Ng\u01b0\u1eddi \u0111\u00e0n \u00f4ng\"],[\"Ng\u01b0\u1eddi\"],[\"Con ng\u01b0\u1eddi\"],[\"\u0110\u00e0n \u00f4ng\"]],\"common_errors\":[],\"special_objectives\":[\"man\"],\"objectives\":[],\"normal_question_audio\":\"http://api.memo.edu.vn/static/1.1/sentence_sounds/normal_c72096df-93e7-43fe-b8e3-7413da1f880f.mp3\",\"question_log_id\":\"544524a02d917169a4b7add4\"},{\"type\":\"translate\",\"question\":\"Boy\",\"translation\":\"C\u1eadu b\u00e9\",\"compact_translations\":[[\"C\u1eadu b\u00e9\"],[[\"C\u1eadu b\u00e9\",\"Ch\u00fa b\u00e9\"]],[\"Con trai\"],[\"C\u1eadu \",[\"con\",\"b\u00e9\"],\" trai\"],[\"Ch\u00e0ng trai\"],[\"B\u00e9 trai\"]],\"common_errors\":[],\"special_objectives\":[],\"objectives\":[\"boy\"],\"normal_question_audio\":\"http://api.memo.edu.vn/static/1.1/sentence_sounds/normal_2b401403-fcae-46b6-a4eb-580d62efe479.mp3\",\"question_log_id\":\"544524a02d917169a4b7add5\"},{\"type\":\"translate\",\"question\":\"A boy\",\"translation\":\"M\u1ed9t c\u1eadu b\u00e9\",\"compact_translations\":[[\"M\u1ed9t c\u1eadu b\u00e9\"]],\"common_errors\":[],\"special_objectives\":[],\"objectives\":[\"boy\"],\"normal_question_audio\":\"http://api.memo.edu.vn/static/1.1/sentence_sounds/normal_0b41eb37-88f3-40e1-9357-fc4ff2440125.mp3\",\"question_log_id\":\"544524a02d917169a4b7add6\"},{\"type\":\"translate\",\"question\":\"Woman\",\"translation\":\"Ph\u1ee5 n\u1eef\",\"compact_translations\":[[\"Ph\u1ee5 n\u1eef\"],[\"\u0110\u00e0n b\u00e0\"],[\"Ng\u01b0\u1eddi \",[\"ph\u1ee5 n\u1eef\",\"\u0111\u00e0n b\u00e0\"]]],\"common_errors\":[],\"special_objectives\":[],\"objectives\":[],\"normal_question_audio\":\"http://api.memo.edu.vn/static/1.1/sentence_sounds/normal_659b8d6a-ab4b-409b-884f-3871b41fd4de.mp3\",\"question_log_id\":\"544524a02d917169a4b7add7\"},{\"type\":\"translate\",\"question\":\"I am a boy.\",\"translation\":\"T\u00f4i l\u00e0 m\u1ed9t c\u1eadu b\u00e9.\",\"compact_translations\":[[\"T\u00f4i l\u00e0 m\u1ed9t c\u1eadu b\u00e9.\"],[\"T\u00f4i l\u00e0 m\u1ed9t \",[\"ch\u00fa\",\"\u0111\u1ee9a\"],\" b\u00e9.\"],[\"T\u00f4i l\u00e0 m\u1ed9t \",[\"ch\u00e0ng trai\",\"c\u1eadu b\u00e9\",\"\u0111\u1ee9a con trai\",\"c\u1eadu con trai\",\"th\u1eb1ng b\u00e9\",\"b\u00e9 trai\",\"\u0111\u1ee9a b\u00e9 trai\",\"c\u1eadu trai\",\"th\u1eb1ng con trai\",\"ng\u01b0\u1eddi con trai\",\"c\u1eadu nh\u00f3c\",\"c\u1eadu b\u00e9 trai\"],\".\"]],\"common_errors\":[],\"special_objectives\":[],\"objectives\":[\"boy\"],\"normal_question_audio\":\"http://api.memo.edu.vn/static/1.1/sentence_sounds/normal_a1f9b7ad-dfac-4629-854a-a7a14d8557cd.mp3\",\"question_log_id\":\"544524a02d917169a4b7add8\"}],\"max_hearts_count\":3,\"available_items\":[]}";
  NSDictionary *json = [response objectFromJSONString];
  NSArray *arr = [MBaseQuestion modelsFromArr:json[kParamQuestions]];
  handler(json[kParamExamToken],
          [json[kParamMaxHeartsCount] integerValue],
          json[kParamAvailableItems],
          arr,
          nil);
  return;
  
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
  paramsDict[kParamDevice] = @"ios";
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
    [UIAlertView showWithError:error];
    return;
  }
  
  if (handler != NULL)
    handler();
}

@end
