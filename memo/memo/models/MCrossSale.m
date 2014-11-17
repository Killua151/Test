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
  NSMutableDictionary *_preloadWebViewsData;
  void(^_htmlLoadingHandler)(NSString *key, BOOL success);
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

- (void)tryToLoadHtmlForAds:(MAdsConfig *)adsConfig
                     forKey:(NSString *)key
             withCompletion:(void (^)(NSString*, BOOL))handler {
  _htmlLoadingHandler = handler;
  
  adsConfig.loaded = NO;
  
  if (_preloadWebViewsData == nil)
    _preloadWebViewsData = [NSMutableDictionary new];
  
  UIWebView *webView = [[UIWebView alloc] init];
  webView.delegate = self;
  [webView loadHTMLString:adsConfig.html baseURL:nil];
  _preloadWebViewsData[[NSString stringWithFormat:@"%p", webView]] = @{
                                                                       @"key" : [NSString normalizedString:key],
                                                                       @"webview" : webView
                                                                       };
}

#pragma mark - UIWebViewDelegate methods
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
  NSString *key = [NSString stringWithFormat:@"%p", webView];
  NSDictionary *data = _preloadWebViewsData[key];
  
  if (_htmlLoadingHandler != NULL)
    _htmlLoadingHandler(data[@"key"], NO);
  
  [_preloadWebViewsData removeObjectForKey:key];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
  NSString *key = [NSString stringWithFormat:@"%p", webView];
  NSDictionary *data = _preloadWebViewsData[key];
  
  if (_htmlLoadingHandler != NULL)
    _htmlLoadingHandler(data[@"key"], YES);
  
  [_preloadWebViewsData removeObjectForKey:key];
}

@end
