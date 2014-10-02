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
  NSString *json = @"[{\"question\":\"I had taken very cold that night.\",\"type\":\"speak\",\"question_log_id\":\"542cdb368b6295e41b00000e\"},{\"question\":\"am\",\"hint\":\"am\",\"question_images\":[null,null,null],\"type\":\"name\",\"question_log_id\":\"542cdb368b6295e41b000007\"},{\"question\":\"L\u1ea7n n\u00e0y ch\u00fang t\u00f4i s\u1ebd d\u00f9ng m\u1ed9t ph\u01b0\u01a1ng ph\u00e1p kh\u00e1c.\",\"hints\":[\"This time we will use a different method.\"],\"options\":[\"I am a very sad person.\",\"The enemy of an enemy is a friend.\",\"This time we will use a different method.\"],\"type\":\"judge\",\"question_log_id\":\"542cdb638b6295e41b00072c\"},{\"question\":\"boy\",\"type\":\"listen\",\"question_log_id\":\"542cdb368b6295e41b000010\"},{\"question\":\"I like that failure.\",\"normal_question_audio\":null,\"slow_audio_file\":null,\"type\":\"listen\",\"question_log_id\":\"542cdb368b6295e41b000012\"},{\"question\":\"Ng\u01b0\u1eddi ph\u1ee5 n\u1eef \u0111i ra.\",\"hints\":[\"The woman goes out.\"],\"options\":[\"The woman goes out.\",\"The woman has to appear on television tomorrow.\",\"That is a woman who has a strong personality.\"],\"type\":\"judge\",\"question_log_id\":\"542cdb638b6295e41b00073f\"},{\"question\":\"T\u00f4i c\u1ea7n m\u1ed9t s\u1ef1 gi\u00fap \u0111\u1ee1.\",\"hints\":[\"I need a favor.\"],\"options\":[\"I have an enemy.\",\"I am a very sad person.\",\"I need a favor.\"],\"type\":\"judge\",\"question_log_id\":\"542cdb538b6295e41b0004e3\"},{\"question\":\"\u0110\u00f3 l\u00e0 m\u1ed9t c\u00e1i t\u00ean m\u00e0 t\u00f4i ch\u01b0a t\u1eebng nghe tr\u01b0\u1edbc \u0111\u00e2y.\",\"tokens\":[\"It\",\"was\",\"a\",\"name\",\"that\",\"i\",\"had\",\"never\",\"heard\",\"before.\"],\"wrong_tokens\":[\"letter\",\"medicine\",\"opens\"],\"type\":\"form\",\"question_log_id\":\"542cdb368b6295e41b000016\"},{\"question\":\"man\",\"hint\":\"man\",\"question_images\":[\"8957c06d1fd5c12d5d4cb98e4afaaca2\",null,null],\"type\":\"name\",\"question_log_id\":\"542cdb368b6295e41b000006\"},{\"question\":\"boy\",\"hint\":\"boy\",\"question_images\":[\"f454077fd87b8f1bb679fd096e29a4ca\",null,null],\"type\":\"name\",\"question_log_id\":\"542cdb368b6295e41b000008\"},{\"question\":\"woman\",\"hint\":\"woman\",\"type\":\"select\",\"options\":[{\"text\":\"woman\",\"image_file\":null},{\"text\":\"blood\",\"image_file\":null},{\"text\":\"mistakes\",\"image_file\":null},{\"text\":\"necks\",\"image_file\":null}],\"question_log_id\":\"542cdb368b6295e41b000003\"},{\"question\":\"T\u00f4i h\u1ecdc v\u0103n ho\u00e1 trung qu\u1ed1c.\",\"tokens\":[\"I\",\"study\",\"chinese\",\"culture.\"],\"wrong_tokens\":[\"square\",\"counts\",\"for\"],\"type\":\"form\",\"question_log_id\":\"542cdb368b6295e41b000017\"},{\"question\":\"am\",\"type\":\"speak\",\"question_log_id\":\"542cdb368b6295e41b000009\"},{\"question\":\"Cu\u1ed9c ch\u1ea1y \u0111ua l\u00e0 m\u1ed9t ni\u1ec1m vui th\u00edch.\",\"tokens\":[\"Running\",\"is\",\"a\",\"pleasure.\"],\"wrong_tokens\":[\"given\",\"went\",\"delivers\"],\"type\":\"form\",\"question_log_id\":\"542cdb368b6295e41b000018\"},{\"question\":\"woman\",\"type\":\"listen\",\"question_log_id\":\"542cdb368b6295e41b00000f\"},{\"question\":\"T\u00f4i l\u1eafng nghe tr\u00e1i tim c\u1ee7a b\u1ea1n.\",\"translation\":\"I listen to your heart.\",\"type\":\"translate\",\"question_log_id\":\"542cdb368b6295e41b000000\",\"compact_translations\":[[\"I listen to your heart.\"]]},{\"question\":\"Tr\u1ebb em l\u00e0 m\u1ed9t tr\u00e1ch nhi\u1ec7m r\u1ea5t l\u1edbn.\",\"translation\":\"Children are a very big responsibility.\",\"type\":\"translate\",\"question_log_id\":\"542cdb368b6295e41b000001\",\"compact_translations\":[[\"Children are a very big responsibility.\"]]},{\"question\":\"M\u1ed9t trong nh\u1eefng l\u1ea7n th\u1eed c\u1ee7a anh ta l\u00e0 m\u1ed9t th\u00e0nh c\u00f4ng.\",\"translation\":\"One of his attempts was a success.\",\"type\":\"translate\",\"question_log_id\":\"542cdb368b6295e41b000002\",\"compact_translations\":[[\"One of his attempts was a success.\"]]},{\"question\":\"Ng\u01b0\u1eddi \u0111\u00e0n \u00f4ng c\u00f3 nh\u1eefng chi\u1ebfc \u0111\u0129a.\",\"hints\":[\"The man has the plates.\"],\"options\":[\"The man lets me leave.\",\"The man has the plates.\",\"The man has to choose a new lawyer.\"],\"type\":\"judge\",\"question_log_id\":\"542cdb548b6295e41b00050b\"},{\"question\":\"am\",\"hint\":\"am\",\"type\":\"select\",\"options\":[{\"text\":\"am\",\"image_file\":null},{\"text\":\"views\",\"image_file\":null},{\"text\":\"explained\",\"image_file\":null},{\"text\":\"blood\",\"image_file\":null}],\"question_log_id\":\"542cdb368b6295e41b000004\"},{\"question\":\"girl\",\"hint\":\"girl\",\"type\":\"select\",\"options\":[{\"text\":\"girl\",\"image_file\":\"a49d591d0f735e48ae2d42e3a2b28e0d\"},{\"text\":\"bye\",\"image_file\":null},{\"text\":\"army\",\"image_file\":\"d4c64fd8550c36fb4eeeeccfc5153c86\"},{\"text\":\"supports\",\"image_file\":null}],\"question_log_id\":\"542cdb368b6295e41b000005\"},{\"question\":\"C\u1eadu b\u00e9 h\u1ecfi.\",\"hints\":[\"The boy asks.\"],\"options\":[\"The boy is touching the sand.\",\"The boy asks.\",\"The boy walks near the girl.\"],\"type\":\"judge\",\"question_log_id\":\"542cdb538b6295e41b0004ec\"},{\"question\":\"C\u00f4 g\u00e1i \u0111ang ch\u1ea1m nh\u1eefng b\u00f4ng hoa.\",\"hints\":[\"The girl is touching the flowers.\"],\"options\":[\"The girl heard a dog in your house.\",\"The girl answered the phone.\",\"The girl is touching the flowers.\"],\"type\":\"judge\",\"question_log_id\":\"542cdb3a8b6295e41b0000c5\"},{\"question\":\"T\u00f4i s\u1ebd gi\u1edbi thi\u1ec7u b\u1ea1n v\u1edbi b\u1ea1n g\u00e1i c\u1ee7a t\u00f4i.\",\"hints\":[\"I am going to introduce you to my girlfriend.\"],\"options\":[\"I am afraid that my son does not remember his grandmother.\",\"I am going to introduce you to my girlfriend.\",\"I am ready to die.\"],\"type\":\"judge\",\"question_log_id\":\"542cdb3a8b6295e41b0000ba\"},{\"question\":\"I believe that they listen my name.\",\"type\":\"speak\",\"question_log_id\":\"542cdb368b6295e41b00000d\"}]";
  
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
