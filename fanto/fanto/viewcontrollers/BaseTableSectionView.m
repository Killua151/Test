//
//  BaseTableSectionView.m
//  fanto
//
//  Created by Ethan Nguyen on 9/16/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "BaseTableSectionView.h"

@interface BaseTableSectionView ()

+ (instancetype)sharedSectionView;

@end

@implementation BaseTableSectionView

- (id)init {
  if (self = [super init]) {
    LoadXibWithSameClass();
  }
  
  return self;
}

+ (CGFloat)heightToFithWithData:(id)data {
  [[[self class] sharedSectionView] updateViewWithData:data];
  return [[[self class] sharedSectionView] heightToFit];
}

- (void)updateViewWithData:(id)data {
  // Implement in child class
}

- (CGFloat)heightToFit {
  // Override in child class
  NSArray *nib = LoadNibNameWithSameClass();
  UIView *view = nib[0];
  
  return view.frame.size.height;
}

#pragma mark - Private methods
+ (instancetype)sharedSectionView {
  static NSMutableDictionary *_sharedSectionViews = nil;
  
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    _sharedSectionViews = [NSMutableDictionary new];
  });
  
  NSString *klass = NSStringFromClass([self class]);
  
  if (_sharedSectionViews[klass] == nil)
    _sharedSectionViews[klass] = [[self class] new];
  
  return _sharedSectionViews[NSStringFromClass([self class])];
}

@end
