//
//  FTJudgeQuestionView.m
//  fanto
//
//  Created by Ethan Nguyen on 9/25/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "FTSelectQuestionContentView.h"
#import "FTSelectQuestionButton.h"

@interface FTSelectQuestionContentView () {
  NSMutableArray *_btnOptions;
}

@end

@implementation FTSelectQuestionContentView

- (void)setupViews {
  _btnOptions = [NSMutableArray new];
  
  _lblQuestion.font = [UIFont fontWithName:@"ClearSans-Bold" size:17];
  
  CGFloat buttonsTopMargin = DeviceScreenIsRetina4Inch() ? 60 : 48;
  CGFloat buttonsBottomMargin = DeviceScreenIsRetina4Inch() ? 35 : 28;
  CGFloat buttonsHeight = (self.frame.size.height - buttonsTopMargin - buttonsBottomMargin - 15)/2;
  
  for (NSInteger i = 0; i < 2; i++)
    for (NSInteger j = 0; j < 2; j++) {
      FTSelectQuestionButton *button = [[FTSelectQuestionButton alloc] initWithIndex:i*2+j];
      button.frame = CGRectMake(15 + j*(button.frame.size.width + 15), buttonsTopMargin + i*(buttonsHeight + 15), button.frame.size.width, buttonsHeight);
      button.delegate = self;
      [_btnOptions addObject:button];
      [self addSubview:button];
    }
}

#pragma mark - FTLessonLearningDelegate methods
- (void)judgeQuestionButtonDidChanged:(BOOL)selected atIndex:(NSInteger)index {
  if (selected) {
    for (FTSelectQuestionButton *button in _btnOptions)
      if (button.tag != index)
        [button setSelected:NO];    
  }
  
  if ([self.delegate respondsToSelector:@selector(judgeQuestionButtonDidChanged:atIndex:)])
    [self.delegate judgeQuestionButtonDidChanged:selected atIndex:index];
}

@end
