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
  NSDictionary *params = @{
                           kParamName : [NSString normalizedString:fullName],
                           kParamEmail : [NSString normalizedString:email],
                           kParamUsername : [NSString normalizedString:username],
                           kParamPassword : [NSString normalizedString:password]
                           };
  
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

- (void)registerDeviceTokenForAPNS {
  NSString *deviceToken = [[NSUserDefaults standardUserDefaults] stringForKey:kUserDefDeviceToken];
  
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
             [MBaseQuestion modelsFromArr:responseDict[@"questions"]],
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
