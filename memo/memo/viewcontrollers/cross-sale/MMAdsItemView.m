//
//  MMAdsBannerView.m
//  memo
//
//  Created by Ethan Nguyen on 11/17/14.
//  Copyright (c) 2014 Topica. All rights reserved.
//

#import "MMAdsItemView.h"
#import "MAdsConfig.h"

@interface MMAdsItemView () {
  IBOutlet UIWebView *_webAdsContent;
  MAdsConfig *_adsConfigData;
}

- (void)setupAds;

@end

@implementation MMAdsItemView

- (id)initWithAds:(MAdsConfig *)adsConfig {
  if (self = [super init]) {
    LoadXibWithSameClass();
    _adsConfigData = adsConfig;
    [self setupAds];
  }
  
  return self;
}

- (void)reloadAdsHtml {
  [_webAdsContent reload];
}

#pragma mark - UIWebViewDelegate methods
- (void)webViewDidFinishLoad:(UIWebView *)webView {
  if ([_delegate respondsToSelector:@selector(adsWithId:didLoad:)])
    [_delegate adsWithId:_adsConfigData._id didLoad:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
  if ([_delegate respondsToSelector:@selector(adsWithId:didLoad:)])
    [_delegate adsWithId:_adsConfigData._id didLoad:NO];
}

- (BOOL)webView:(UIWebView *)webView
shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType {
  if (navigationType == UIWebViewNavigationTypeOther)
    return YES;
  [[UIApplication sharedApplication] openURL:request.URL];
  return NO;
}

#pragma mark - Private methods
- (void)setupAds {
  CGRect frame = self.frame;
  frame.size = CGSizeMake(_adsConfigData.width, _adsConfigData.height);
  self.frame = frame;
  
  _webAdsContent.scrollView.scrollEnabled = NO;
  _webAdsContent.delegate = self;
  [_webAdsContent loadHTMLString:_adsConfigData.html baseURL:nil];
}

@end
