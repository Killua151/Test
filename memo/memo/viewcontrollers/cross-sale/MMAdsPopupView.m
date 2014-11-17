//
//  MMAdsPopupView.m
//  memo
//
//  Created by Ethan Nguyen on 11/17/14.
//  Copyright (c) 2014 Topica. All rights reserved.
//

#import "MMAdsPopupView.h"
#import "MMAdsItemView.h"
#import "MAdsConfig.h"

@interface MMAdsPopupView () {
  MMAdsItemView *_vAdsItem;
}

- (void)setupAds:(MAdsConfig *)ads;

@end

@implementation MMAdsPopupView

- (id)initWithAds:(MAdsConfig *)ads {
  if (self = [super init]) {
    LoadXibWithSameClass();
    [self setupAds:ads];
  }
  
  return self;
}

- (IBAction)btnClosePressed:(UIButton *)sender {
  [self removeFromSuperview];
}

#pragma mark - Private methods
- (void)setupAds:(MAdsConfig *)ads {
  if (_vAdsItem == nil)
    _vAdsItem = [[MMAdsItemView alloc] initWithAdsConfig:ads];
  
  self.frame = [UIScreen mainScreen].bounds;
  
  CGRect frame = _vAdsItem.frame;
  
  if ([ads.display_type isEqualToString:kValueAdsDisplayTypeFullScreen])
    frame = self.frame;
  else {
    frame.origin.x = (self.frame.size.width - ads.width)/2;
    frame.origin.y = (self.frame.size.height - ads.height)/2;
    frame.size = CGSizeMake(ads.width, ads.height);
  }
  
  _vAdsItem.frame = frame;
  [self addSubview:_vAdsItem];
  
  frame = _btnClose.frame;
  frame.origin.x = _vAdsItem.frame.origin.x + _vAdsItem.frame.size.width - 10 - frame.size.width;
  frame.origin.y = _vAdsItem.frame.origin.y + 10;
  _btnClose.frame = frame;
  
  [self bringSubviewToFront:_btnClose];
}

@end
