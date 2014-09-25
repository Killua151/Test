//
//  FTServerHelper.m
//  fanto
//
//  Created by Ethan Nguyen on 9/24/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "FTServerHelper.h"

@interface FTServerHelper ()

- (void)logInWithParam:(NSDictionary *)params completion:(void(^)(NSDictionary *userData, NSError *error))handler;

@end

@implementation FTServerHelper

+ (instancetype)sharedHelper {
  static FTServerHelper *_sharedHelper = nil;
  
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    NSString *baseUrl = [NSString stringWithFormat:@"%@/%@/", kServerApiUrl, kServerApiVersion];
    _sharedHelper = [[FTServerHelper alloc] initWithBaseURL:[NSURL URLWithString:baseUrl]];
    _sharedHelper.responseSerializer = [AFJSONResponseSerializer serializer];
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
                           kParamFullName : [Utils normalizeString:fullName],
                           kParamEmail : [Utils normalizeString:email],
                           kParamUsername : [Utils normalizeString:username],
                           kParamPassword : [Utils normalizeString:password]
                           };
  
  DLog(@"%@", params);
  
  [self
   POST:@"users"
   parameters:params
   success:^(AFHTTPRequestOperation *operation, id responseObject) {
     handler(responseObject, nil);
   }
   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
     DLog(@"%@", error);
     handler(nil, error);
   }];
}

#pragma mark - Private methods
- (void)logInWithParam:(NSDictionary *)params completion:(void (^)(NSDictionary *, NSError *))handler {
  [self
   POST:@"users/login"
   parameters:params
   success:^(AFHTTPRequestOperation *operation, id responseObject) {
     handler(responseObject, nil);
   }
   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
     handler(nil, error);
   }];
}

@end
