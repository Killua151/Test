//
//  MCrossSale.h
//  memo
//
//  Created by Ethan Nguyen on 11/15/14.
//  Copyright (c) 2014 Topica. All rights reserved.
//

#import "MBase.h"

@class MAdsConfig;

@interface MCrossSale : MBase <UIWebViewDelegate>

@property (nonatomic, strong) NSDictionary *runningAds;

- (void)loadRunningAds:(NSDictionary *)runningAdsData;
- (void)tryToLoadHtmlForAds:(MAdsConfig *)adsConfig withCompletion:(void(^)(BOOL success))handler;

@end
