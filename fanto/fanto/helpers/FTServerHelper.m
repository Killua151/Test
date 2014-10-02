//
//  FTServerHelper.m
//  fanto
//
//  Created by Ethan Nguyen on 9/24/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "FTServerHelper.h"
#import "FTAppDelegate.h"
#import "MUser.h"
#import "MSkill.h"
#import "MBaseQuestion.h"

@interface FTServerHelper ()

- (void)logInWithParam:(NSDictionary *)params completion:(void(^)(NSDictionary *userData, NSError *error))handler;
- (void)handleFailedOperation:(AFHTTPRequestOperation *)operation withError:(NSError *)error fallback:(void(^)())handler;

@end

@implementation FTServerHelper

+ (instancetype)sharedHelper {
  static FTServerHelper *_sharedHelper = nil;
  
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    NSString *baseUrl = [NSString stringWithFormat:@"%@/%@/", kServerApiUrl, kServerApiVersion];
    _sharedHelper = [[FTServerHelper alloc] initWithBaseURL:[NSURL URLWithString:baseUrl]];
    _sharedHelper.responseSerializer = [AFHTTPResponseSerializer serializer];
  });
  
  return _sharedHelper;
}

- (void)logInWithUsername:(NSString *)username
                 password:(NSString *)password
               completion:(void (^)(NSDictionary *, NSError *))handler {
  [self logInWithParam:@{
                         kParamUsername : [Utils normalizeString:username],
                         kParamPassword : [Utils normalizeString:password]
                         }
            completion:handler];
}

- (void)logInWithFacebookId:(NSString *)facebookId
                accessToken:(NSString *)accessToken
                 completion:(void (^)(NSDictionary *, NSError *))handler {
  [self logInWithParam:@{
                         kParamFbId : [Utils normalizeString:facebookId],
                         kParamFbAccessToken : [Utils normalizeString:accessToken]
                         }
            completion:handler];
}

- (void)logInWithGmail:(NSString *)gmail
           accessToken:(NSString *)accessToken
            completion:(void (^)(NSDictionary *, NSError *))handler {
  [self logInWithParam:@{
                         kParamGmail : [Utils normalizeString:gmail],
                         kParamGAccessToken : [Utils normalizeString:accessToken]
                         }
            completion:handler];
}

- (void)signUpWithFullName:(NSString *)fullName
                     email:(NSString *)email
                  username:(NSString *)username
                  password:(NSString *)password
                completion:(void (^)(NSDictionary *, NSError *))handler {
  NSDictionary *params = @{
                           kParamName : [Utils normalizeString:fullName],
                           kParamEmail : [Utils normalizeString:email],
                           kParamUsername : [Utils normalizeString:username],
                           kParamPassword : [Utils normalizeString:password]
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
  NSDictionary *params = @{kParamAuthToken : [Utils normalizeString:[MUser currentUser].auth_token]};
  
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
  NSDictionary *params = @{kParamAuthToken : [Utils normalizeString:[MUser currentUser].auth_token]};
  
  [self
   GET:[NSString stringWithFormat:@"users/%@", [MUser currentUser]._id]
   parameters:params
   success:^(AFHTTPRequestOperation *operation, id responseObject) {
     NSDictionary *userData = [responseObject objectFromJSONData];
     [[MUser currentUser] assignProperties:userData];
     [MUser currentUser].skills = [MSkill modelsFromArr:userData[kParamSkills]];
     handler(userData, nil);
   }
   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
     [self handleFailedOperation:operation withError:error fallback:^{
       handler(nil, error);
     }];
   }];
}

- (void)startLesson:(NSInteger)lessonNumber inSkill:(NSString *)skillId completion:(void (^)(NSArray *, NSError *))handler {
  NSString *json = @"[{\"question\":\"am\",\"type\":\"listen\",\"question_log_id\":\"542cc5b749af5580708b4577\"},{\"question\":\"T\u00f4i nh\u1ea3y.\",\"translation\":\"I jump.\",\"type\":\"translate\",\"question_log_id\":\"542cc5b749af5580708b4568\",\"compact_translations\":[[\"I jump.\"]]},{\"question\":\"Ch\u00fang t\u00f4i s\u1eed d\u1ee5ng m\u1ed9t h\u1ec7 th\u1ed1ng kh\u00e1c.\",\"hint\":\"We use a different system.\",\"option\":[\"We use a different system.\",\"I am a very sad person.\",\"The enemy of an enemy is a friend.\"],\"type\":\"judge\",\"question_log_id\":\"542cc5e449af5580708b4ca5\"},{\"question\":\"T\u00f4i s\u1ebd t\u00ecm th\u1ea5y m\u1ed9t gi\u1ea3i ph\u00e1p cho v\u1ea5n \u0111\u1ec1.\",\"tokens\":[\"I\",\"am\",\"going\",\"to\",\"find\",\"a\",\"solution\",\"to\",\"the\",\"problem.\"],\"wrong_tokens\":[\"faith\",\"hearts\",\"pants\"],\"type\":\"form\",\"question_log_id\":\"542cc5b749af5580708b457e\"},{\"question\":\"man\",\"hint\":\"man\",\"type\":\"select\",\"options\":[{\"text\":\"man\",\"image_files\":[\"8957c06d1fd5c12d5d4cb98e4afaaca2\",null,null]},{\"text\":\"previous\",\"image_files\":[null,null,null]},{\"text\":\"about\",\"image_files\":[null,null,null]},{\"text\":\"tell\",\"image_files\":[null,null,null]}],\"question_log_id\":\"542cc5b749af5580708b456a\"},{\"question\":\"am\",\"hint\":\"am\",\"question_image\":[null,null,null],\"type\":\"name\",\"question_log_id\":\"542cc5b749af5580708b456e\"},{\"question\":\"C\u00f4 g\u00e1i \u0111\u1ecdc v\u1ec1 nh\u1eefng \u0111\u1ed9ng c\u01a1.\",\"hint\":\"The girl reads about motors.\",\"option\":[\"The girl heard a dog in your house.\",\"The girl reads about motors.\",\"The girl answered the phone.\"],\"type\":\"judge\",\"question_log_id\":\"542cc5b749af5580708b4589\"},{\"question\":\"a\",\"hint\":\"a\",\"question_image\":[null,null,null],\"type\":\"name\",\"question_log_id\":\"542cc5b749af5580708b456f\"},{\"question\":\"C\u1eadu b\u00e9 c\u00f3 m\u1ed9t c\u00e1i \u0111i\u1ec7n tho\u1ea1i di \u0111\u1ed9ng hi\u1ec7n \u0111\u1ea1i.\",\"hint\":\"The boy has a modern cellphone.\",\"option\":[\"The boy has a modern cellphone.\",\"The boy is touching the sand.\",\"The boy walks near the girl.\"],\"type\":\"judge\",\"question_log_id\":\"542cc5d449af5580708b4a65\"},{\"question\":\"I see a turtle on the beach.\",\"question_audio\":\"normal_364e62b304c781cab43e20e97866fe22\",\"type\":\"speak\",\"question_log_id\":\"542cc5b749af5580708b4575\"},{\"question\":\"T\u00f4i c\u00f3 m\u1ed9t c\u00e2u h\u1ecfi.\",\"tokens\":[\"I\",\"have\",\"a\",\"question.\"],\"wrong_tokens\":[\"days\",\"meat\",\"fairs\"],\"type\":\"form\",\"question_log_id\":\"542cc5b749af5580708b457d\"},{\"question\":\"Ng\u01b0\u1eddi ph\u1ee5 n\u1eef \u0111i ra.\",\"hint\":\"The woman goes out.\",\"option\":[\"That is a woman who has a strong personality.\",\"The woman has to appear on television tomorrow.\",\"The woman goes out.\"],\"type\":\"judge\",\"question_log_id\":\"542cc5d449af5580708b4a5c\"},{\"question\":\"woman\",\"question_audio\":\"w8ting for db\",\"type\":\"speak\",\"question_log_id\":\"542cc5b749af5580708b4571\"},{\"question\":\"man\",\"hint\":\"man\",\"question_image\":[\"8957c06d1fd5c12d5d4cb98e4afaaca2\",null,null],\"type\":\"name\",\"question_log_id\":\"542cc5b749af5580708b456d\"},{\"question\":\"B\u1ea1n \u0111\u00e3 bi\u1ebft ng\u01b0\u1eddi \u0111\u00e0n \u00f4ng trong b\u00e1o?\",\"hint\":\"Did you know the man in the newspaper?\",\"option\":[\"Did you know the man in the newspaper?\",\"The man has to choose a new lawyer.\",\"The man lets me leave.\"],\"type\":\"judge\",\"question_log_id\":\"542cc5d549af5580708b4a84\"},{\"question\":\"T\u00f4i \u0111ang t\u00ecm ki\u1ebfm th\u01b0 k\u00fd c\u1ee7a t\u00f4i.\",\"translation\":\"I am looking for my secretary.\",\"type\":\"translate\",\"question_log_id\":\"542cc5b649af5580708b4567\",\"compact_translations\":[[\"I am looking for my secretary.\"],[\"I am searching for my secretary.\"]]},{\"question\":\"I\",\"hint\":\"I\",\"type\":\"select\",\"options\":[{\"text\":\"I\",\"image_files\":[null,null,null]},{\"text\":\"attempt\",\"image_files\":[null,null,null]},{\"text\":\"should\",\"image_files\":[null,null,null]},{\"text\":\"responses\",\"image_files\":[null,null,null]}],\"question_log_id\":\"542cc5b749af5580708b456b\"},{\"question\":\"G\u1ea7n m\u1ed9t n\u1eeda\",\"translation\":\"Almost a half\",\"type\":\"translate\",\"question_log_id\":\"542cc5b749af5580708b4569\",\"compact_translations\":[[\"Almost a half\"]]},{\"question\":\"T\u00f4i kh\u00f4ng qu\u00ean t\u1ed5n h\u1ea1i nh\u01b0 th\u1ebf.\",\"tokens\":[\"I\",\"do\",\"not\",\"forget\",\"such\",\"damage.\"],\"wrong_tokens\":[\"however\",\"serious\",\"whose\"],\"type\":\"form\",\"question_log_id\":\"542cc5b749af5580708b457c\"},{\"question\":\"a\",\"hint\":\"a\",\"type\":\"select\",\"options\":[{\"text\":\"a\",\"image_files\":[null,null,null]},{\"text\":\"rooms\",\"image_files\":[null,null,null]},{\"text\":\"objective\",\"image_files\":[null,null,null]},{\"text\":\"coming\",\"image_files\":[null,null,null]}],\"question_log_id\":\"542cc5b749af5580708b456c\"},{\"question\":\"T\u00f4i kh\u00f4ng mu\u1ed1n b\u1eaft \u0111\u1ea7u m\u1ed9t cu\u1ed9c th\u1ea3o lu\u1eadn.\",\"hint\":\"I do not want to start a discussion.\",\"option\":[\"I am a very sad person.\",\"I do not want to start a discussion.\",\"I have an enemy.\"],\"type\":\"judge\",\"question_log_id\":\"542cc5d449af5580708b4a49\"},{\"question\":\"My son is a postcard.\",\"question_audio\":null,\"slow_audio_file\":null,\"type\":\"listen\",\"question_log_id\":\"542cc5b749af5580708b457b\"},{\"question\":\"T\u00f4i s\u1ebd vi\u1ebft cho b\u1ea1n m\u1ed9t l\u00e1 th\u01b0.\",\"hint\":\"I am going to write you a letter.\",\"option\":[\"I am ready to die.\",\"I am going to write you a letter.\",\"I am afraid that my son does not remember his grandmother.\"],\"type\":\"judge\",\"question_log_id\":\"542cc5bb49af5580708b462b\"},{\"question\":\"Finally he found a way to solve his problem.\",\"question_audio\":\"normal_de5ac6d3c51a76790768bdebee39bcf7\",\"slow_audio_file\":\"slow_de5ac6d3c51a76790768bdebee39bcf7\",\"type\":\"listen\",\"question_log_id\":\"542cc5b749af5580708b4579\"},{\"question\":\"I will see the police.\",\"question_audio\":null,\"type\":\"speak\",\"question_log_id\":\"542cc5b749af5580708b4574\"}]";
  
  NSArray *questions = [json objectFromJSONString];
  NSArray *questionsData = [MBaseQuestion modelsFromArr:questions];
  
  handler(questionsData, nil);
  return;
  
  NSDictionary *params = @{
                           kParamLessonNumber : @(lessonNumber),
                           kParamSkillId : [Utils normalizeString:skillId],
                           kParamAuthToken : [Utils normalizeString:[MUser currentUser].auth_token]
                           };
  
  [self
   POST:@"lessons/start"
   parameters:params
   success:^(AFHTTPRequestOperation *operation, id responseObject) {
     NSArray *questions = [responseObject objectFromJSONData];
     handler([MBaseQuestion modelsFromArr:questions], nil);
   }
   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
     [self handleFailedOperation:operation withError:error fallback:^{
       handler(nil, error);
     }];
   }];
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

- (void)handleFailedOperation:(AFHTTPRequestOperation *)operation withError:(NSError *)error fallback:(void (^)())handler {
  if ([[operation response] statusCode] == 401) {
    FTAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [MUser logOutCurrentUser];
    [appDelegate setupRootViewController];
    [Utils showAlertWithError:error];
    return;
  }
  
  if (handler != NULL)
    handler();
}

@end
