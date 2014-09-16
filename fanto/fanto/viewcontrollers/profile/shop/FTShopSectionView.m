//
//  FTShopSectionView.m
//  fanto
//
//  Created by Ethan on 9/16/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "FTShopSectionView.h"

@interface FTShopSectionView ()

+ (instancetype)sharedSectionView;
- (CGFloat)heightToFit;

@end

@implementation FTShopSectionView

+ (CGFloat)heightToFithWithData:(NSString *)data {
  [[[self class] sharedSectionView] updateViewWithData:data];
  return [[[self class] sharedSectionView] heightToFit];
}

- (id)init {
  if (self = [super init]) {
    LoadXibWithSameClass();
  }
  
  return self;
}

- (void)updateViewWithData:(NSString *)data {
  _lblSectionName.text = data;
  [Utils adjustLabelToFitHeight:_lblSectionName];
}

#pragma mark - Private methods
+ (instancetype)sharedSectionView {
  static FTShopSectionView *_sharedSectionView = nil;
  
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    _sharedSectionView = [FTShopSectionView new];
  });
  
  return _sharedSectionView;
}

- (CGFloat)heightToFit {
  return _lblSectionName.frame.origin.y + _lblSectionName.frame.size.height + 12;
}

@end
