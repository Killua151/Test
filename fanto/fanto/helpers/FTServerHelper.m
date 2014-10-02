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
  NSString *json = @"[{\"question\":\"Ng\u01b0\u1eddi \u0111\u00e0n \u00f4ng c\u00f3 m\u1ed9t c\u00e1i v\u00ed ti\u1ec1n.\",\"hint\":\"The man has a wallet.\",\"option\":[\"The man lets me leave.\",\"The man has a wallet.\",\"The man has to choose a new lawyer.\"],\"type\":\"judge\",\"question_log_id\":\"542cb3e349af55226b8b45d6\"},{\"question\":\"girl\",\"type\":\"listen\",\"question_log_id\":\"542cb3e149af55226b8b45b1\"},{\"question\":\"Ng\u01b0\u1eddi \u0111\u00e0n \u00f4ng \u0111\u00f3 l\u00e0 m\u1ed9t b\u00e1c s\u0129.\",\"translation\":\"That man is a doctor.\",\"type\":\"translate\",\"question_log_id\":\"542cb3e149af55226b8b45a0\",\"compact_translations\":[[\"That man is a doctor.\"]]},{\"question\":\"I am brown.\",\"question_audio\":null,\"slow_audio_file\":null,\"type\":\"listen\",\"question_log_id\":\"542cb3e149af55226b8b45b4\"},{\"question\":\"man\",\"hint\":\"man\",\"type\":\"select\",\"options\":[{\"text\":\"man\",\"image_files\":[\"8957c06d1fd5c12d5d4cb98e4afaaca2\",null,null]},{\"text\":\"grass\",\"image_files\":[\"c8672d8378eab796d3524fc28e4a2dca\",null,null]},{\"text\":\"fault\",\"image_files\":[null,null,null]},{\"text\":\"walls\",\"image_files\":[null,null,null]}],\"question_log_id\":\"542cb3e149af55226b8b45a3\"},{\"question\":\"man\",\"type\":\"listen\",\"question_log_id\":\"542cb3e149af55226b8b45af\"},{\"question\":\"C\u00f4 ta hi\u1ec7n gi\u1edd l\u00e0 m\u1ed9t ng\u01b0\u1eddi m\u1eabu.\",\"hint\":\"She is currently a model.\",\"option\":[\"She is currently a model.\",\"I am a very sad person.\",\"The enemy of an enemy is a friend.\"],\"type\":\"judge\",\"question_log_id\":\"542cb41649af55226b8b4c29\"},{\"question\":\"am\",\"question_audio\":\"w8ting for db\",\"type\":\"speak\",\"question_log_id\":\"542cb3e149af55226b8b45ab\"},{\"question\":\"Ng\u00e0y mai t\u00f4i s\u1ebd ng\u1ee7 \u1edf nh\u00e0 c\u1ee7a b\u1ed1 m\u1eb9 t\u00f4i.\",\"tokens\":[\"Tomorrow\",\"i\",\"am\",\"going\",\"to\",\"sleep\",\"in\",\"my\",\"parents'\",\"house.\"],\"wrong_tokens\":[\"includes\",\"roof\",\"sitting\"],\"type\":\"form\",\"question_log_id\":\"542cb3e249af55226b8b45b7\"},{\"question\":\"I am in her yard.\",\"question_audio\":\"normal_388ba68e5b6c7d2dfb60ad379cfd7dab\",\"type\":\"speak\",\"question_log_id\":\"542cb3e149af55226b8b45ac\"},{\"question\":\"I\",\"hint\":\"I\",\"type\":\"select\",\"options\":[{\"text\":\"I\",\"image_files\":[null,null,null]},{\"text\":\"valleys\",\"image_files\":[null,null,null]},{\"text\":\"hairs\",\"image_files\":[null,null,null]},{\"text\":\"same\",\"image_files\":[null,null,null]}],\"question_log_id\":\"542cb3e149af55226b8b45a5\"},{\"question\":\"T\u00f4i c\u00f3 m\u1ed9t gia \u0111\u00ecnh.\",\"translation\":\"I have a family.\",\"type\":\"translate\",\"question_log_id\":\"542cb3e149af55226b8b45a2\",\"compact_translations\":[[\"I have a family.\"]]},{\"question\":\"T\u00f4i \u0111\u00e3 \u0111\u1ebfn \u0111\u00e2y r\u1ed3i.\",\"tokens\":[\"I\",\"have\",\"already\",\"come\",\"here.\"],\"wrong_tokens\":[\"actors\",\"even\",\"old\"],\"type\":\"form\",\"question_log_id\":\"542cb3e149af55226b8b45b5\"},{\"question\":\"T\u00f4i kh\u00f4ng mu\u1ed1n l\u00e0m n\u00f3.\",\"translation\":\"I do not feel like doing it.\",\"type\":\"translate\",\"question_log_id\":\"542cb3e149af55226b8b45a1\",\"compact_translations\":[[\"I do not feel like doing it.\"]]},{\"question\":\"man\",\"hint\":\"man\",\"question_image\":[\"8957c06d1fd5c12d5d4cb98e4afaaca2\",null,null],\"type\":\"name\",\"question_log_id\":\"542cb3e149af55226b8b45a6\"},{\"question\":\"T\u00f4i s\u1ebd g\u1eb7p b\u00e1c s\u0129.\",\"hint\":\"I am going to see the doctor.\",\"option\":[\"I am afraid that my son does not remember his grandmother.\",\"I am going to see the doctor.\",\"I am ready to die.\"],\"type\":\"judge\",\"question_log_id\":\"542cb41c49af55226b8b4cde\"},{\"question\":\"I\",\"hint\":\"I\",\"question_image\":[null,null,null],\"type\":\"name\",\"question_log_id\":\"542cb3e149af55226b8b45a7\"},{\"question\":\"C\u00f4 \u1ea5y l\u00e0 ng\u01b0\u1eddi ph\u1ee5 n\u1eef c\u1ee7a th\u1ebf k\u1ef7.\",\"hint\":\"She is the woman of the century.\",\"option\":[\"The woman has to appear on television tomorrow.\",\"That is a woman who has a strong personality.\",\"She is the woman of the century.\"],\"type\":\"judge\",\"question_log_id\":\"542cb41749af55226b8b4c3c\"},{\"question\":\"C\u00f4 g\u00e1i \u0111ang ch\u1ea1m nh\u1eefng b\u00f4ng hoa.\",\"hint\":\"The girl is touching the flowers.\",\"option\":[\"The girl is touching the flowers.\",\"The girl heard a dog in your house.\",\"The girl answered the phone.\"],\"type\":\"judge\",\"question_log_id\":\"542cb3e449af55226b8b45ea\"},{\"question\":\"C\u1eadu b\u00e9 vi\u1ebft l\u00ean m\u1eb7t \u0111\u1ea5t.\",\"hint\":\"The boy writes on the ground.\",\"option\":[\"The boy walks near the girl.\",\"The boy is touching the sand.\",\"The boy writes on the ground.\"],\"type\":\"judge\",\"question_log_id\":\"542cb3e349af55226b8b45df\"},{\"question\":\"man\",\"question_audio\":\"w8ting for db\",\"type\":\"speak\",\"question_log_id\":\"542cb3e149af55226b8b45a9\"},{\"question\":\"woman\",\"hint\":\"woman\",\"type\":\"select\",\"options\":[{\"text\":\"woman\",\"image_files\":[null,null,null]},{\"text\":\"dogs\",\"image_files\":[null,null,null]},{\"text\":\"free\",\"image_files\":[null,null,null]},{\"text\":\"it\",\"image_files\":[null,null,null]}],\"question_log_id\":\"542cb3e149af55226b8b45a4\"},{\"question\":\"B\u1ed1 c\u1ee7a b\u1ea1n l\u00e0 m\u1ed9t ng\u01b0\u1eddi \u0111\u00e0n \u00f4ng c\u00f4ng b\u1eb1ng.\",\"tokens\":[\"Your\",\"father\",\"is\",\"a\",\"fair\",\"man.\"],\"wrong_tokens\":[\"bodies\",\"air\",\"prettier\"],\"type\":\"form\",\"question_log_id\":\"542cb3e249af55226b8b45b6\"},{\"question\":\"T\u00f4i gh\u00e9t c\u00e0 ph\u00ea.\",\"hint\":\"I hate coffee.\",\"option\":[\"I have an enemy.\",\"I am a very sad person.\",\"I hate coffee.\"],\"type\":\"judge\",\"question_log_id\":\"542cb40749af55226b8b4a08\"},{\"question\":\"am\",\"hint\":\"am\",\"question_image\":[null,null,null],\"type\":\"name\",\"question_log_id\":\"542cb3e149af55226b8b45a8\"}]";
  
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
