//
//  FTQuestionContentView.m
//  fanto
//
//  Created by Ethan on 9/26/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "FTQuestionContentView.h"

@interface FTQuestionContentView ()

- (void)setupViewFrame;

@end

@implementation FTQuestionContentView

- (id)initWithQuestion:(MBaseQuestion *)question {
  if (self = [super init]) {
    LoadXibWithSameClass();
    _questionData = question;
    
    [self setupViewFrame];
    [self setupViews];
  }
  
  return self;
}

- (void)setupViews {
  // Implement in child class
}

- (void)gestureLayerDidTap {
  // Implement in child class
}

#pragma mark - Private methods
- (void)setupViewFrame {
  CGRect frame = self.frame;
  frame.size.height = DeviceScreenIsRetina4Inch() ? 430 : 342;
  self.frame = frame;
}

@end
