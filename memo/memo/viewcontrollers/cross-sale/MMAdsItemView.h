//
//  MMAdsBannerView.h
//  memo
//
//  Created by Ethan Nguyen on 11/17/14.
//  Copyright (c) 2014 Topica. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MAdsConfig;

@interface MMAdsItemView : UIView <UIWebViewDelegate>

@property (nonatomic, assign) id<MMCrossSaleAdsDelegate> delegate;

- (id)initWithAds:(MAdsConfig *)adsConfig;
- (void)reloadAdsHtml;

@end
