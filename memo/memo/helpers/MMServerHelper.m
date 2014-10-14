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

@interface MMServerHelper ()

- (void)logInWithParam:(NSDictionary *)params completion:(void(^)(NSDictionary *userData, NSError *error))handler;
- (void)startExamWithParam:(NSDictionary *)params
                completion:(void(^)(NSString *examToken, NSArray *questions, NSError *error))handler;
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

- (void)getUserProfile:(void (^)(NSDictionary *, NSError *))handler {
  NSDictionary *params = @{kParamAuthToken : [NSString normalizedString:[MUser currentUser].auth_token]};
  
  [self
   GET:[NSString stringWithFormat:@"users/%@", [MUser currentUser]._id]
   parameters:params
   success:^(AFHTTPRequestOperation *operation, id responseObject) {
     NSDictionary *userData = [responseObject objectFromJSONData];
     MUser *currentUser = [MUser currentUser];
     [currentUser assignProperties:userData[kParamUserInfo]];
     currentUser.skills_tree = userData[kParamSkillsTree];
     currentUser.skills = [MSkill modelsFromArr:userData[kParamSkills]];
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
  handler(@"Invite email sent successfully", nil);
}

- (void)startLesson:(NSInteger)lessonNumber
            inSkill:(NSString *)skillId
         completion:(void (^)(NSString *, NSArray *, NSError *))handler {
  NSString *response = @"{\"exam_token\":\"Ethan Nguyen_543d02354a8b7\",\"questions\":[{\"type\":\"sort\",\"question\":\"T\u00f4i l\u00e0 m\u1ed9t c\u1eadu b\u00e9 v\u00e0 t\u00f4i \u0103n m\u1ed9t tr\u00e1i t\u00e1o.\",\"tokens\":[\"I\",\"am\",\"a\",\"boy\",\"and\",\"I\",\"eat\",\"an\",\"apple.\"],\"wrong_tokens\":[\"true\",\"pays\",\"minutes\",\"museums\",\"an\"],\"normal_answer_audio\":\"http://api.memo.edu.vn/static/sentence_sounds/normal_e78c275918bae4b7aaaa1616427c2e9f.mp3\",\"question_log_id\":\"543d023448177e98088b52c7\"},{\"type\":\"translate\",\"question\":\"An apple\",\"translation\":\"M\u1ed9t qu\u1ea3 t\u00e1o\",\"compact_translations\":[[\"M\u1ed9t qu\u1ea3 t\u00e1o\"],[\"M\u1ed9t tr\u00e1i t\u00e1o\"],[\"M\u1ed9t \",[\"tr\u00e1i\",\"qu\u1ea3\"],\" bom\"]],\"normal_question_audio\":\"http://api.memo.edu.vn/static/sentence_sounds/normal_9ad8094c40a0b38008947dd69030f0a6.mp3\",\"question_log_id\":\"543d023448177e98088b52bf\"},{\"type\":\"sort\",\"question\":\"M\u1ed9t ng\u01b0\u1eddi \u0111\u00e0n \u00f4ng v\u00e0 m\u1ed9t qu\u1ea3 t\u00e1o\",\"tokens\":[\"A\",\"man\",\"and\",\"an\",\"apple\"],\"wrong_tokens\":[\"beaches\",\"telephone\",\"sent\"],\"normal_answer_audio\":\"http://api.memo.edu.vn/static/sentence_sounds/normal_aeacdf0f8532daf4e1f5bf27dd4328e8.mp3\",\"question_log_id\":\"543d023548177e98088b52c9\"},{\"type\":\"translate\",\"question\":\"I eat.\",\"translation\":\"T\u00f4i \u0103n.\",\"compact_translations\":[[\"T\u00f4i \u0103n.\"]],\"normal_question_audio\":\"http://api.memo.edu.vn/static/sentence_sounds/normal_9c9bad349a6131e47613764ce1afe07e.mp3\",\"question_log_id\":\"543d023448177e98088b52bd\"},{\"type\":\"sort\",\"question\":\"T\u00f4i \u0103n.\",\"tokens\":[\"I\",\"eat.\"],\"wrong_tokens\":[\"pair\"],\"normal_answer_audio\":\"http://api.memo.edu.vn/static/sentence_sounds/normal_9c9bad349a6131e47613764ce1afe07e.mp3\",\"question_log_id\":\"543d023548177e98088b52ca\"},{\"type\":\"sort\",\"question\":\"Anh \u1ea5y l\u00e0 m\u1ed9t ng\u01b0\u1eddi \u0111\u00e0n \u00f4ng.\",\"tokens\":[\"He\",\"is\",\"a\",\"man.\"],\"wrong_tokens\":[\"shirts\",\"fashion\"],\"normal_answer_audio\":\"http://api.memo.edu.vn/static/sentence_sounds/normal_2fc8ae48a83a2c78e3517d1bf65e6143.mp3\",\"question_log_id\":\"543d023548177e98088b52cb\"},{\"type\":\"translate\",\"question\":\"I am a man and she is a woman.\",\"translation\":\"T\u00f4i l\u00e0 m\u1ed9t ng\u01b0\u1eddi \u0111\u00e0n \u00f4ng v\u00e0 c\u00f4 \u1ea5y l\u00e0 m\u1ed9t ng\u01b0\u1eddi ph\u1ee5 n\u1eef.\",\"compact_translations\":[[\"T\u00f4i l\u00e0 m\u1ed9t ng\u01b0\u1eddi \u0111\u00e0n \u00f4ng v\u00e0 c\u00f4 \u1ea5y l\u00e0 m\u1ed9t ng\u01b0\u1eddi ph\u1ee5 n\u1eef.\"]],\"normal_question_audio\":\"http://api.memo.edu.vn/static/sentence_sounds/normal_dbc26d3234edcf7b23b5e750e303e169.mp3\",\"question_log_id\":\"543d023448177e98088b52bb\"},{\"type\":\"translate\",\"question\":\"He is a man.\",\"translation\":\"Anh \u1ea5y l\u00e0 m\u1ed9t ng\u01b0\u1eddi \u0111\u00e0n \u00f4ng.\",\"compact_translations\":[[\"Anh \u1ea5y l\u00e0 m\u1ed9t ng\u01b0\u1eddi \u0111\u00e0n \u00f4ng.\"],[[\"Anh\",\"C\u1eadu\"],\" \",[\"\u1ea5y\",\"ta\"],\" l\u00e0 m\u1ed9t ng\u01b0\u1eddi \u0111\u00e0n \u00f4ng.\"],[\"\u00d4ng \",[\"\u1ea5y\",\"ta\"],\" l\u00e0 m\u1ed9t ng\u01b0\u1eddi \u0111\u00e0n \u00f4ng.\"],[[\"Anh\",\"C\u1eadu\"],\" \",[\"\u1ea5y\",\"ta\"],\" l\u00e0 m\u1ed9t \",[\"ng\u01b0\u1eddi nam\",\"ch\u00e0ng trai\"],\".\"]],\"normal_question_audio\":\"http://api.memo.edu.vn/static/sentence_sounds/normal_2fc8ae48a83a2c78e3517d1bf65e6143.mp3\",\"question_log_id\":\"543d023448177e98088b52c1\"},{\"type\":\"translate\",\"question\":\"She is a girl.\",\"translation\":\"C\u00f4 \u1ea5y l\u00e0 m\u1ed9t c\u00f4 g\u00e1i.\",\"compact_translations\":[[\"C\u00f4 \u1ea5y l\u00e0 m\u1ed9t c\u00f4 g\u00e1i.\"],[[\"C\u00f4\",\"Ch\u1ecb\",\"Em\"],\" \",[\"\u1ea5y\",\"ta\"],\" l\u00e0 m\u1ed9t \",[\"c\u00f4 g\u00e1i\",\"c\u00f4 b\u00e9\",\"b\u00e9 g\u00e1i\",\"ng\u01b0\u1eddi con g\u00e1i\",\"\u0111\u1ee9a con g\u00e1i\",\"c\u00f4 b\u00e9 g\u00e1i\"],\".\"]],\"normal_question_audio\":\"http://api.memo.edu.vn/static/sentence_sounds/normal_f235aa6c091f9a874bd29ae964900941.mp3\",\"question_log_id\":\"543d023448177e98088b52ba\"},{\"type\":\"speak\",\"question\":\"I am a man and she is a woman.\",\"question_log_id\":\"543d023548177e98088b52cd\"},{\"type\":\"translate\",\"question\":\"C\u00f4 \u1ea5y l\u00e0 m\u1ed9t c\u00f4 b\u00e9 v\u00e0 t\u00f4i l\u00e0 m\u1ed9t c\u1eadu b\u00e9.\",\"translation\":\"She is a girl and I am a boy.\",\"compact_translations\":[[\"She is a girl and I am a boy.\"]],\"normal_question_audio\":\"http://api.memo.edu.vn/static/sentence_sounds/normal_36c748b3c088528e0f9da26bfa951a39.mp3\",\"question_log_id\":\"543d023448177e98088b52c4\"},{\"type\":\"translate\",\"question\":\"M\u1ed9t b\u00e9 trai v\u00e0 m\u1ed9t b\u00e9 g\u00e1i\",\"translation\":\"A boy and a girl\",\"compact_translations\":[[\"A boy and a girl\"]],\"normal_question_audio\":\"http://api.memo.edu.vn/static/sentence_sounds/normal_f0d0e1da929126b8531548923b1497c9.mp3\",\"question_log_id\":\"543d023448177e98088b52c2\"},{\"type\":\"translate\",\"question\":\"Anh \u1ea5y l\u00e0 m\u1ed9t c\u1eadu b\u00e9.\",\"translation\":\"He is a boy.\",\"compact_translations\":[[\"He is a boy.\"]],\"normal_question_audio\":\"http://api.memo.edu.vn/static/sentence_sounds/normal_bea5bff609375da60d753e033371bc6a.mp3\",\"question_log_id\":\"543d023448177e98088b52c3\"},{\"type\":\"translate\",\"question\":\"M\u1ed9t ng\u01b0\u1eddi \u0111\u00e0n \u00f4ng v\u00e0 m\u1ed9t qu\u1ea3 t\u00e1o\",\"translation\":\"A man and an apple\",\"compact_translations\":[[\"A man and an apple\"]],\"normal_question_audio\":\"http://api.memo.edu.vn/static/sentence_sounds/normal_aeacdf0f8532daf4e1f5bf27dd4328e8.mp3\",\"question_log_id\":\"543d023448177e98088b52b9\"},{\"type\":\"judge\",\"question\":\"T\u00f4i \u0103n.\",\"hints\":[\"I eat.\"],\"options\":[\"He is a man and I am a boy.\",\"I am a man and she is a woman.\",\"I eat.\"],\"question_log_id\":\"543d023448177e98088b52c6\"},{\"type\":\"judge\",\"question\":\"C\u00f4 \u1ea5y l\u00e0 m\u1ed9t c\u00f4 b\u00e9 v\u00e0 t\u00f4i l\u00e0 m\u1ed9t c\u1eadu b\u00e9.\",\"hints\":[\"She is a girl and I am a boy.\"],\"options\":[\"He is a boy.\",\"I am a man and she is a woman.\",\"She is a girl and I am a boy.\"],\"question_log_id\":\"543d023448177e98088b52c5\"},{\"type\":\"sort\",\"question\":\"M\u1ed9t b\u00e9 trai v\u00e0 m\u1ed9t b\u00e9 g\u00e1i\",\"tokens\":[\"A\",\"boy\",\"and\",\"a\",\"girl\"],\"wrong_tokens\":[\"lamp\",\"which\",\"election\"],\"normal_answer_audio\":\"http://api.memo.edu.vn/static/sentence_sounds/normal_f0d0e1da929126b8531548923b1497c9.mp3\",\"question_log_id\":\"543d023448177e98088b52c8\"},{\"type\":\"sort\",\"question\":\"C\u00f4 \u1ea5y l\u00e0 m\u1ed9t c\u00f4 g\u00e1i.\",\"tokens\":[\"She\",\"is\",\"a\",\"girl.\"],\"wrong_tokens\":[],\"normal_answer_audio\":\"http://api.memo.edu.vn/static/sentence_sounds/normal_f235aa6c091f9a874bd29ae964900941.mp3\",\"question_log_id\":\"543d023548177e98088b52cc\"},{\"type\":\"translate\",\"question\":\"Ng\u01b0\u1eddi \u0111\u00e0n \u00f4ng v\u00e0 ng\u01b0\u1eddi ph\u1ee5 n\u1eef\",\"translation\":\"Man and woman\",\"compact_translations\":[[\"Man and woman\"]],\"normal_question_audio\":\"http://api.memo.edu.vn/static/sentence_sounds/normal_790c2c9d9a543228d1154a7075de609d.mp3\",\"question_log_id\":\"543d023448177e98088b52be\"},{\"type\":\"translate\",\"question\":\"The man and the woman\",\"translation\":\"Ng\u01b0\u1eddi \u0111\u00e0n \u00f4ng v\u00e0 ng\u01b0\u1eddi ph\u1ee5 n\u1eef\",\"compact_translations\":[[\"Ng\u01b0\u1eddi \u0111\u00e0n \u00f4ng v\u00e0 ng\u01b0\u1eddi ph\u1ee5 n\u1eef\"]],\"normal_question_audio\":\"http://api.memo.edu.vn/static/sentence_sounds/normal_d6564ceff5e3054cd9b20bb62c89c93a.mp3\",\"question_log_id\":\"543d023448177e98088b52c0\"},{\"type\":\"translate\",\"question\":\"C\u00f4 \u1ea5y l\u00e0 m\u1ed9t ng\u01b0\u1eddi ph\u1ee5 n\u1eef.\",\"translation\":\"She is a woman.\",\"compact_translations\":[[\"She is a woman.\"]],\"normal_question_audio\":\"http://api.memo.edu.vn/static/sentence_sounds/normal_6a72df672a5e91278e109f8d59e26ef5.mp3\",\"question_log_id\":\"543d023448177e98088b52bc\"}]}";
  NSDictionary *responseDict = [response objectFromJSONString];
  handler(responseDict[kParamExamToken], [MBaseQuestion modelsFromArr:responseDict[@"questions"]], nil);
  return;
  
  NSDictionary *params = @{
                           kParamType : kValueExamTypeLesson,
                           kParamLessonNumber : @(lessonNumber),
                           kParamSkillId : [NSString normalizedString:skillId],
                           kParamAuthToken : [NSString normalizedString:[MUser currentUser].auth_token]
                           };
  
  [self startExamWithParam:params completion:handler];
}

- (void)startShortcutTest:(NSString *)skillId completion:(void (^)(NSString *, NSArray *, NSError *))handler {
  handler(nil, nil, [NSError errorWithDomain:@"Chức năng chưa hoạt động" code:-1 userInfo:nil]);
  return;
  
  NSDictionary *params = @{
                           kParamType : kValueExamTypeShortcut,
                           kParamSkillId : [NSString normalizedString:skillId],
                           kParamAuthToken : [NSString normalizedString:[MUser currentUser].auth_token]
                           };
  
  [self startExamWithParam:params completion:handler];
}

- (void)startCheckpointTestAtPosition:(NSInteger)checkpointPosition
                           completion:(void (^)(NSString *, NSArray *, NSError *))handler {
  handler(nil, nil, [NSError errorWithDomain:@"Chức năng chưa hoạt động" code:-1 userInfo:nil]);
  return;
  
  NSDictionary *params = @{
                           kParamType : kValueExamTypeCheckpoint,
                           kParamCheckpointPosition : @(checkpointPosition),
                           kParamAuthToken : [NSString normalizedString:[MUser currentUser].auth_token]
                           };
  
  [self startExamWithParam:params completion:handler];
}

- (void)startStrengthenSkill:(NSString *)skillId completion:(void (^)(NSString *, NSArray *, NSError *))handler {
  handler(nil, nil, [NSError errorWithDomain:@"Chức năng chưa hoạt động" code:-1 userInfo:nil]);
  return;
  
  NSDictionary *params = @{
                           kParamType : kValueExamTypeStrengthenSkill,
                           kParamSkillId : [NSString normalizedString:skillId],
                           kParamAuthToken : [NSString normalizedString:[MUser currentUser].auth_token]
                           };
  
  [self startExamWithParam:params completion:handler];
}

- (void)startStrengthenAll:(void (^)(NSString *, NSArray *, NSError *))handler {
  handler(nil, nil, [NSError errorWithDomain:@"Chức năng chưa hoạt động" code:-1 userInfo:nil]);
  return;
  
  NSDictionary *params = @{
                           kParamType : kValueExamTypeStrengthenAll,
                           kParamAuthToken : [NSString normalizedString:[MUser currentUser].auth_token]
                           };
  
  [self startExamWithParam:params completion:handler];
}

- (void)startPlacementTest:(void (^)(NSString *, NSArray *, NSError *))handler {
  handler(nil, nil, [NSError errorWithDomain:@"Chức năng chưa hoạt động" code:-1 userInfo:nil]);
  return;
  
  NSDictionary *params = @{
                           kParamType : kValueExamTypePlacementTest,
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
    [Utils showAlertWithError:error];
    return;
  }
  
  if (handler != NULL)
    handler();
}

@end
