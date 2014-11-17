//
//  MMAdsBannerView.h
//  memo
//
//  Created by Ethan Nguyen on 11/17/14.
//  Copyright (c) 2014 Topica. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MAdsConfig;

@interface MMAdsBannerView : UIView <UIWebViewDelegate> {
  IBOutlet UIWebView *_webAdsContent;
}

@property (nonatomic, assign) id<MMCrossSaleAdsDelegate> delegate;

- (id)initWithAdsConfig:(MAdsConfig *)adsConfig;
- (void)reloadAdsHtml;

@end
