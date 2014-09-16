//
//  MABaseTableViewCell.m
//  medicine-alert
//
//  Created by Ethan Nguyen on 7/1/14.
//  Copyright (c) 2014 Volcano. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface BaseTableViewCell ()

+ (instancetype)sharedCell;

@end

@implementation BaseTableViewCell

- (id)init {
  if (self = [super init]) {
    LoadXibWithSameClass();
  }
  
  return self;
}

+ (CGFloat)heightToFitWithData:(MBase *)data {
  [[[self class] sharedCell] updateCellWithData:data];
  return [[[self class] sharedCell] heightToFit];
}

- (void)updateCellWithData:(MBase *)data {
  // Implement in child class
}

- (void)updateCellWithData:(MBase *)data atIndex:(NSInteger)cellIndex {
  _cellIndex = cellIndex;
  [self updateCellWithData:data];
}

- (void)updateCellWithData:(NSString *)data shouldShowSeparator:(BOOL)shouldShowSeparator {
  // Implement in child class
}

+ (instancetype)sharedCell {
  static NSMutableDictionary *_sharedCells = nil;
  
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    _sharedCells = [NSMutableDictionary new];
  });
  
  NSString *klass = NSStringFromClass([self class]);
  
  if (_sharedCells[klass] == nil)
    _sharedCells[klass] = [[self class] new];
  
  return _sharedCells[NSStringFromClass([self class])];
}

- (CGFloat)heightToFit {
  // Override in child class
  NSArray *nib = LoadNibNameWithSameClass();
  UIView *view = nib[0];
  
  return view.frame.size.height;
}

@end
