//
//  NSError+ErrorHelpers.m
//  memo
//
//  Created by Ethan Nguyen on 10/14/14.
//  Copyright (c) 2014 Topica. All rights reserved.
//

#import "NSError+ErrorHelpers.h"

@implementation NSError (ErrorHelpers)

- (NSString *)errorMessage {
  if (self.userInfo == nil || ![self.userInfo isKindOfClass:[NSDictionary class]] ||
      self.userInfo[kServerResponseDataKey] == nil || self.userInfo[kServerResponseDataKey] == NULL ||
      [self.userInfo[kServerResponseDataKey] isEqualToData:[NSData data]])     // Empty data
    return [self localizedDescription];
  
  NSDictionary *errorDict = [self.userInfo[kServerResponseDataKey] objectFromJSONData];
  
  if (errorDict == nil || ![errorDict isKindOfClass:[NSDictionary class]] ||
      errorDict[kParamError] == nil || ![errorDict[kParamError] isKindOfClass:[NSString class]])
    return [self localizedDescription];
  
  return NSLocalizedString(errorDict[kParamError], nil);
}

- (NSInteger)errorCode {
  if (self.userInfo == nil || ![self.userInfo isKindOfClass:[NSDictionary class]] ||
      self.userInfo[kServerResponseDataKey] == nil || self.userInfo[kServerResponseDataKey] == NULL ||
      [self.userInfo[kServerResponseDataKey] isEqualToData:[NSData data]])     // Empty data
    return [self code];
  
  NSDictionary *errorDict = [self.userInfo[kServerResponseDataKey] objectFromJSONData];
  
  if (errorDict == nil || ![errorDict isKindOfClass:[NSDictionary class]] ||
      errorDict[kParamResponseCode] == nil || ![errorDict[kParamResponseCode] isKindOfClass:[NSNumber class]])
    return [self code];
  
  return [errorDict[kParamResponseCode] integerValue];
}

@end
