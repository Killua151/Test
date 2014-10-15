//
//  LocalizationHelper.h
//  memo
//
//  Created by Ethan Nguyen on 10/15/14.
//  Copyright (c) 2014 Topica. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalizationHelper : NSObject

+ (instancetype)sharedHelper;
- (void)loadLocalizationForLanguage:(NSString *)language;
- (NSString *)localizedStringForString:(NSString *)string;

@end
