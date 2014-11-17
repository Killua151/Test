//
//  MMAdsBannerCell.m
//  memo
//
//  Created by Ethan Nguyen on 11/17/14.
//  Copyright (c) 2014 Topica. All rights reserved.
//

#import "MMAdsBannerCell.h"
#import "MMAdsBannerView.h"
#import "MAdsConfig.h"

@implementation MMAdsBannerCell

- (void)updateCellWithData:(MAdsConfig *)data {
  if (_vAdsBanner == nil) {
    _vAdsBanner = [[MMAdsBannerView alloc] initWithAdsConfig:data];
    _vAdsBanner.delegate = _delegate;
    [self.contentView addSubview:_vAdsBanner];
  }

  [_vAdsBanner reloadAdsHtml];
}

@end