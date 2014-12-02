//
//  MLatestVersion.h
//  memo
//
//  Created by Ethan Nguyen on 12/2/14.
//  Copyright (c) 2014 Topica. All rights reserved.
//

#import "MBase.h"

@interface MLatestVersion : MBase

@property (nonatomic, assign) BOOL is_latest;
@property (nonatomic, assign) BOOL allowed;
@property (nonatomic, assign) BOOL is_beta;
@property (nonatomic, assign) NSString *message;
@property (nonatomic, assign) NSString *market_url;

+ (instancetype)version;
+ (void)loadVersionData:(NSDictionary *)versionData;

@end
