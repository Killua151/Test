//
//  MMVoucherPagePopup.m
//  memo
//
//  Created by Ethan Nguyen on 11/18/14.
//  Copyright (c) 2014 Topica. All rights reserved.
//

#import "MMVoucherPagePopup.h"
#import "MAdsConfig.h"

@interface MMVoucherPagePopup () {
  MAdsConfig *_adsConfigData;
  NSString *_htmlData;
  UIWebView *_webView;
}

- (void)setupWebView;

@end

@implementation MMVoucherPagePopup

- (id)initWithAds:(MAdsConfig *)adsConfig {
  if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
    _adsConfigData = adsConfig;
    [self setupWebView];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_adsConfigData.url]]];
  }
  
  return self;
}

- (id)initWithHtml:(NSString *)html {
  if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
    _htmlData = html;
    [self setupWebView];
    [_webView loadHTMLString:_htmlData baseURL:nil];
  }
  
  return self;
}

#pragma mark - UIWebViewDelegate methods
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
  [UIAlertView
   showWithError:error
   cancelButtonTitle:MMLocalizedString(@"Cancel")
   otherButtonTitles:@[MMLocalizedString(@"Retry")]
   callback:^(UIAlertView *alertView, NSInteger buttonIndex) {
     if (buttonIndex == 0)
       [self hide];
     else
       [_webView reload];
   }];
}

#pragma mark - Private methods
- (void)setupWebView {
  UIWindow *topWindow = [[[UIApplication sharedApplication] windows] lastObject];
  [topWindow addSubview:self];
  
  self.margin = UIEdgeInsetsMake(30, 10, 5, 10);
  
  CGRect frame = CGRectInset(self.roundedRectFrame, self.cornerRadius, self.cornerRadius);  
  UIView *webViewContainer = [[UIView alloc] initWithFrame:frame];
  webViewContainer.backgroundColor = [UIColor clearColor];
  webViewContainer.clipsToBounds = YES;
  [self.contentContainer insertSubview:webViewContainer belowSubview:self.closeButton];
  
  frame.origin = CGPointZero;
  _webView = [[UIWebView alloc] initWithFrame:frame];
  _webView.delegate = self;
  _webView.clipsToBounds = YES;
  _webView.backgroundColor = [UIColor clearColor];
  [webViewContainer addSubview:_webView];
}

@end
