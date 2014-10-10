//
//  UIDevice+DeviceHelpers.h
//  memo
//
//  Created by Ethan Nguyen on 10/10/14.
//  Copyright (c) 2014 Topica. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (DeviceHelpers)

+ (NSString *)trimmedDeviceToken:(NSData *)deviceToken;
- (NSString *)deviceModel;
- (NSString *)uniqueDeviceIdentifier;
- (BOOL)isCapableForRealTimeSearch;

@end
