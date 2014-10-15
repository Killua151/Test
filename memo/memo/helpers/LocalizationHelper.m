//
//  LocalizationHelper.m
//  memo
//
//  Created by Ethan Nguyen on 10/15/14.
//  Copyright (c) 2014 Topica. All rights reserved.
//

#import "LocalizationHelper.h"

@interface LocalizationHelper () {
  NSDictionary *_localizedStringsData;
}

@end

@implementation LocalizationHelper

+ (instancetype)sharedHelper {
  static LocalizationHelper *_sharedHelper = nil;
  
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    _sharedHelper = [LocalizationHelper new];
  });
  
  return _sharedHelper;
}

- (void)loadLocalizationForLanguage:(NSString *)language {
  NSString *stringsFilePath = [[NSBundle mainBundle] pathForResource:language ofType:@"strings"];
  _localizedStringsData = [NSDictionary dictionaryWithContentsOfFile:stringsFilePath];
}

- (NSString *)localizedStringForString:(NSString *)string {
  if (_localizedStringsData == nil ||
      ![_localizedStringsData isKindOfClass:[NSDictionary class]] ||
      _localizedStringsData[string] == nil)
    return string;
  
  return _localizedStringsData[string];
}

@end
