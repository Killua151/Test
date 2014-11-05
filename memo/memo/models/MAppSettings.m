//
//  MAppSettings.m
//  memo
//
//  Created by Ethan Nguyen on 11/5/14.
//  Copyright (c) 2014 Topica. All rights reserved.
//

#import "MAppSettings.h"

static MAppSettings *_sharedSettings;

@implementation MAppSettings

+ (void)loadAppSettings:(NSDictionary *)appSettingsDict {
  _sharedSettings = [MAppSettings modelFromDict:appSettingsDict];
}

+ (instancetype)sharedSettings {
  NSAssert(_sharedSettings != nil, @"AppSettings not set up");
  return _sharedSettings;
}

@end
