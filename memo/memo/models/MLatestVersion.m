//
//  MLatestVersion.m
//  memo
//
//  Created by Ethan Nguyen on 12/2/14.
//  Copyright (c) 2014 Topica. All rights reserved.
//

#import "MLatestVersion.h"

static MLatestVersion *_version = nil;

@implementation MLatestVersion

+ (instancetype)version {
  return _version;
}

+ (void)loadVersionData:(NSDictionary *)versionData {
  _version = [MLatestVersion modelFromDict:versionData];
}

@end
