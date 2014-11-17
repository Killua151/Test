//
//  MCrossSale.m
//  memo
//
//  Created by Ethan Nguyen on 11/15/14.
//  Copyright (c) 2014 Topica. All rights reserved.
//

#import "MCrossSale.h"
#import "MAdsConfig.h"

@interface MCrossSale () {
  void(^_htmlLoadingHandler)(BOOL success);
}

@end

@implementation MCrossSale

- (void)loadRunningAds:(NSDictionary *)runningAdsData {
  if (runningAdsData == nil || ![runningAdsData isKindOfClass:[NSDictionary class]])
    return;
  
  __block NSMutableDictionary *runningAds = [NSMutableDictionary new];
  
  [runningAdsData enumerateKeysAndObjectsUsingBlock:^(NSString *screen, NSDictionary *positionsConfig, BOOL *stop) {
    if (positionsConfig == nil || ![positionsConfig isKindOfClass:[NSDictionary class]])
      return;
    
    if (runningAds[screen] == nil)
      runningAds[screen] = [NSMutableDictionary dictionary];
    
    [positionsConfig enumerateKeysAndObjectsUsingBlock:^(NSString *position, NSDictionary *adsConfig, BOOL *stop) {
      if (runningAds[screen][position] == nil)
        runningAds[screen][position] = [MAdsConfig modelFromDict:adsConfig];
    }];
  }];
  
  _runningAds = runningAds;
}

- (void)tryToLoadHtmlForAds:(MAdsConfig *)adsConfig withCompletion:(void (^)(BOOL))handler {
  _htmlLoadingHandler = handler;
  
  adsConfig.loaded = NO;
  
  UIWebView *webView = [[UIWebView alloc] init];
  webView.delegate = self;
  [webView loadHTMLString:adsConfig.html baseURL:nil];
  [webView setNeedsDisplay];
}

#pragma mark - UIWebViewDelegate methods
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
  DLog("invoke");
  
  if (_htmlLoadingHandler != NULL)
    _htmlLoadingHandler(NO);
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
  DLog("invoke");
  
  if (_htmlLoadingHandler != NULL)
    _htmlLoadingHandler(YES);
}

@end
