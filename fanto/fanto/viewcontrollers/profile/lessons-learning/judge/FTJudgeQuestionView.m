//
//  FTJudgeQuestionView.m
//  fanto
//
//  Created by Ethan Nguyen on 9/25/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "FTJudgeQuestionView.h"
#import "FTJudgeButtonView.h"

@interface FTJudgeQuestionView () {
  NSMutableArray *_btnOptions;
}

- (void)setupViews;

@end

@implementation FTJudgeQuestionView

- (id)init {
  if (self = [super init]) {
    LoadXibWithSameClass();
    
    _btnOptions = [NSMutableArray new];
    [self setupViews];
  }
  
  return self;
}

#pragma mark - FTLessonLearningDelegate methods
- (void)judgeQuestionButtonDidChanged:(BOOL)selected atIndex:(NSInteger)index {
  if (selected) {
    for (FTJudgeButtonView *button in _btnOptions)
      if (button.tag != index)
        [button setSelected:NO];    
  }
  
  if ([_delegate respondsToSelector:@selector(judgeQuestionButtonDidChanged:atIndex:)])
    [_delegate judgeQuestionButtonDidChanged:selected atIndex:index];
}

#pragma mark - Private methods
- (void)setupViews {
  CGRect frame = self.frame;
  frame.size.height = DeviceScreenIsRetina4Inch() ? 430 : 342;
  self.frame = frame;
  
  _lblQuestion.font = [UIFont fontWithName:@"ClearSans-Bold" size:17];
  
  CGFloat buttonsTopMargin = DeviceScreenIsRetina4Inch() ? 60 : 48;
  CGFloat buttonsBottomMargin = DeviceScreenIsRetina4Inch() ? 35 : 28;
  CGFloat buttonsHeight = (self.frame.size.height - buttonsTopMargin - buttonsBottomMargin - 15)/2;
  
  for (NSInteger i = 0; i < 2; i++)
    for (NSInteger j = 0; j < 2; j++) {
      FTJudgeButtonView *button = [[FTJudgeButtonView alloc] initWithIndex:i*2+j];
      button.frame = CGRectMake(15 + j*(button.frame.size.width + 15), buttonsTopMargin + i*(buttonsHeight + 15), button.frame.size.width, buttonsHeight);
      button.delegate = self;
      [_btnOptions addObject:button];
      [self addSubview:button];
    }
}

@end
