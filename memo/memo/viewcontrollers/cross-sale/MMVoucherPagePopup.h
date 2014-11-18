//
//  MMVoucherPagePopup.h
//  memo
//
//  Created by Ethan Nguyen on 11/18/14.
//  Copyright (c) 2014 Topica. All rights reserved.
//

#import "UAModalPanel.h"

@class MAdsConfig;

@interface MMVoucherPagePopup : UAModalPanel <UIWebViewDelegate>

- (id)initWithAds:(MAdsConfig *)adsConfig;

@end
