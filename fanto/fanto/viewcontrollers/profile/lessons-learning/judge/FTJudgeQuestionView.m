//
//  FTJudgeQuestionView.m
//  fanto
//
//  Created by Ethan Nguyen on 9/25/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "FTJudgeQuestionView.h"
#import "FTJudgeButtonView.h"

@interface FTJudgeQuestionView ()

- (void)setupViews;

@end

@implementation FTJudgeQuestionView

- (id)init {
  if (self = [super init]) {
    LoadXibWithSameClass();
    [self setupViews];
  }
  
  return self;
}

#pragma mark - FTLessonLearningDelegate methods
- (void)judgeQuestionButtonDidChanged:(BOOL)selected atIndex:(NSInteger)index {
  if ([_delegate respondsToSelector:@selector(judgeQuestionButtonDidChanged:atIndex:)])
    [_delegate judgeQuestionButtonDidChanged:selected atIndex:index];
}

#pragma mark - Private methods
- (void)setupViews {
  FTJudgeButtonView *button = [[FTJudgeButtonView alloc] initWithIndex:0];
  button.delegate = self;
  [self addSubview:button];
}

@end
