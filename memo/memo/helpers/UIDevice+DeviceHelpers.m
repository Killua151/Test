//
//  UIDevice+DeviceHelpers.m
//  memo
//
//  Created by Ethan Nguyen on 10/10/14.
//  Copyright (c) 2014 Topica. All rights reserved.
//

#import "UIDevice+DeviceHelpers.h"
#include <sys/types.h>
#include <sys/sysctl.h>

@implementation UIDevice (DeviceHelpers)

+ (NSString*)trimmedDeviceToken:(NSData*)token {
  NSString *trimmedToken = [token description];
  trimmedToken = [trimmedToken stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
  trimmedToken = [trimmedToken stringByReplacingOccurrencesOfString:@" " withString:@""];
  return trimmedToken;
}

- (NSString *)uniqueDeviceIdentifier {
  NSString *uniqueIdentifier = nil;
  
  // iOS 6+
  if ([UIDevice instancesRespondToSelector:@selector(identifierForVendor)])
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
  
  // before iOS 6
  
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  uniqueIdentifier = [userDefaults objectForKey:kUserDefUDID];
  
  if (uniqueIdentifier == nil) {
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    uniqueIdentifier = (NSString*)CFBridgingRelease(CFUUIDCreateString(NULL, uuid));
    CFRelease(uuid);
    
    [userDefaults setObject:uniqueIdentifier forKey:kUserDefUDID];
    [userDefaults synchronize];
  }
  
  return uniqueIdentifier;
}

- (NSString *)deviceModel {
  size_t size;
  sysctlbyname("hw.machine", NULL, &size, NULL, 0);
  char *model = malloc(size);
  sysctlbyname("hw.machine", model, &size, NULL, 0);
  NSString *deviceModel = [NSString stringWithCString:model encoding:NSUTF8StringEncoding];
  free(model);
  
  if ([deviceModel isEqualToString:@"i386"] || [deviceModel isEqualToString:@"x86_64"])
    return nil;
  
  return deviceModel;
}

- (BOOL)isCapableForRealTimeSearch {
  NSString *deviceModel = [self deviceModel];
  
  if (deviceModel == nil)
    return YES;
  
  if ([deviceModel rangeOfString:@"iPod"].location != NSNotFound)
    return NO;
  
  if ([deviceModel rangeOfString:@"iPad"].location != NSNotFound) {
    CGFloat version = [[[deviceModel stringByReplacingOccurrencesOfString:@"iPad" withString:@""]
                        stringByReplacingOccurrencesOfString:@"," withString:@"."]
                       floatValue];
    
    return version >= 2.5;
  }
  
  if ([deviceModel rangeOfString:@"iPhone"].location != NSNotFound) {
    CGFloat version = [[[deviceModel stringByReplacingOccurrencesOfString:@"iPhone" withString:@""]
                        stringByReplacingOccurrencesOfString:@"," withString:@"."]
                       floatValue];
    
    return version >= 5;
  }
  
  return NO;
}

@end
