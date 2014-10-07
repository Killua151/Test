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

@interface MMServerHelper ()

- (void)logInWithParam:(NSDictionary *)params completion:(void(^)(NSDictionary *userData, NSError *error))handler;
- (void)startExamWithParam:(NSDictionary *)params
                completion:(void(^)(NSString *examToken, NSArray *questions, NSError *error))handler;
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
                accessToken:(NSString *)accessToken
                 completion:(void (^)(NSDictionary *, NSError *))handler {
  [self logInWithParam:@{
                         kParamFbId : [NSString normalizedString:facebookId],
                         kParamFbAccessToken : [NSString normalizedString:accessToken]
                         }
            completion:handler];
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

- (void)getUserProfile:(void (^)(NSDictionary *, NSError *))handler {
  NSDictionary *params = @{kParamAuthToken : [NSString normalizedString:[MUser currentUser].auth_token]};
  
  [self
   GET:[NSString stringWithFormat:@"users/%@", [MUser currentUser]._id]
   parameters:params
   success:^(AFHTTPRequestOperation *operation, id responseObject) {
     NSDictionary *userData = [responseObject objectFromJSONData];
     [[MUser currentUser] assignProperties:userData[kParamUserInfo]];
     [MUser currentUser].skills_tree = userData[kParamSkillsTree];
     [MUser currentUser].skills = [MSkill modelsFromArr:userData[kParamSkills]];
     handler(userData, nil);
   }
   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
     [self handleFailedOperation:operation withError:error fallback:^{
       handler(nil, error);
     }];
   }];
}

- (void)startLesson:(NSInteger)lessonNumber
            inSkill:(NSString *)skillId
         completion:(void (^)(NSString *, NSArray *, NSError *))handler {
  NSDictionary *params = @{
                           kParamType : @"lesson",
                           kParamLessonNumber : @(lessonNumber),
                           kParamSkillId : [NSString normalizedString:skillId],
                           kParamAuthToken : [NSString normalizedString:[MUser currentUser].auth_token]
                           };
  
  [self startExamWithParam:params completion:handler];
}

- (void)finishLesson:(NSInteger)lessonNumber
             inSkill:(NSString *)skillId
           withToken:(NSString *)examToken
          andResults:(NSDictionary *)answerResults
          completion:(void (^)(NSError *))handler {
  NSDictionary *params = @{
                           kParamType : @"lesson",
                           kParamLessonNumber : @(lessonNumber),
                           kParamSkillId : [NSString normalizedString:skillId],
                           kParamAuthToken : [NSString normalizedString:[MUser currentUser].auth_token],
                           kParamExamToken : [NSString normalizedString:examToken],
                           kParamAnswers : [answerResults JSONString]
                           };
  
  DLog(@"%@", params);
  
  [self
   POST:@"exam/finish"
   parameters:params
   success:^(AFHTTPRequestOperation *operation, id responseObject) {
     [MUser currentUser].lastReceivedBonuses = [responseObject objectFromJSONData];
     DLog(@"%@", [responseObject objectFromJSONData]);
     handler(nil);
   }
   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
     DLog(@"%@", error);
     
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

- (void)startExamWithParam:(NSDictionary *)params completion:(void (^)(NSString *, NSArray *, NSError *))handler {
  [self
   POST:@"exam/start"
   parameters:params
   success:^(AFHTTPRequestOperation *operation, id responseObject) {
     NSDictionary *responseDict = [responseObject objectFromJSONData];
     handler(responseDict[kParamExamToken], [MBaseQuestion modelsFromArr:responseDict[@"questions"]], nil);
   }
   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
     [self handleFailedOperation:operation withError:error fallback:^{
       handler(nil, nil, error);
     }];
   }];
}

- (void)handleFailedOperation:(AFHTTPRequestOperation *)operation withError:(NSError *)error fallback:(void (^)())handler {
  if ([[operation response] statusCode] == 401) {
    MMAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [MUser logOutCurrentUser];
    [appDelegate setupRootViewController];
    [Utils showAlertWithError:error];
    return;
  }
  
  if (handler != NULL)
    handler();
}

@end
