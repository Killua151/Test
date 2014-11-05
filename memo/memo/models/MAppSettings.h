//
//  MAppSettings.h
//  memo
//
//  Created by Ethan Nguyen on 11/5/14.
//  Copyright (c) 2014 Topica. All rights reserved.
//

#import "MBase.h"

@interface MAppSettings : MBase

@property (nonatomic, strong) NSString *api_version;
@property (nonatomic, strong) NSArray *auto_feedback_types;
@property (nonatomic, strong) NSArray *feedback_types;

+ (void)loadAppSettings:(NSDictionary *)appSettingsDict;
+ (instancetype)sharedSettings;

@end
