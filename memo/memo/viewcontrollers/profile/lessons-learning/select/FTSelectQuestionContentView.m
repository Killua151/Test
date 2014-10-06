//
//  FTJudgeQuestionView.m
//  fanto
//
//  Created by Ethan Nguyen on 9/25/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "FTSelectQuestionContentView.h"
#import "FTSelectQuestionButton.h"
#import "MSelectQuestion.h"
#import "MSelectQuestionOption.h"

@interface FTSelectQuestionContentView () {
  NSMutableArray *_btnOptions;
  NSMutableArray *_optionsData;
}

@end

@implementation FTSelectQuestionContentView

- (void)setupViews {
  MSelectQuestion *questionData = (MSelectQuestion *)self.questionData;
  
  _btnOptions = [NSMutableArray new];
  _lblQuestion.font = [UIFont fontWithName:@"ClearSans-Bold" size:17];
  _lblQuestion.text = [NSString stringWithFormat:NSLocalizedString(@"Translate \"%@\"", nil), questionData.question];
  
  if (!DeviceScreenIsRetina4Inch()) {
    CGRect frame = _lblQuestion.frame;
    frame.origin.y -= 10;
    _lblQuestion.frame = frame;
  }
  
  CGFloat buttonsTopMargin = DeviceScreenIsRetina4Inch() ? 60 : 48;
  CGFloat buttonsBottomMargin = DeviceScreenIsRetina4Inch() ? 35 : 28;
  CGFloat buttonsHeight = (self.frame.size.height - buttonsTopMargin - buttonsBottomMargin - 15)/2;
  
  _optionsData = [NSMutableArray arrayWithArray:questionData.options];
  [_optionsData shuffle];
  
  for (NSInteger i = 0; i < 2; i++)
    for (NSInteger j = 0; j < 2; j++) {
      NSInteger index = i*2+j;
      
      if (index >= [_optionsData count])
        break;
      
      FTSelectQuestionButton *button = [[FTSelectQuestionButton alloc] initWithOption:_optionsData[index] atIndex:index];
      
      button.frame = CGRectMake(15 + j*(button.frame.size.width + 15),
                                buttonsTopMargin + i*(buttonsHeight + 15), button.frame.size.width, buttonsHeight);
      button.delegate = self;
      [_btnOptions addObject:button];
      [self addSubview:button];
    }
}

#pragma mark - FTQuestionContentDelegate methods
- (void)selectQuestionButtonDidChanged:(BOOL)selected atIndex:(NSInteger)index {
  if (selected) {
    for (FTSelectQuestionButton *button in _btnOptions)
      if (button.tag != index)
        [button setSelected:NO];    
  }
  
  if ([self.delegate respondsToSelector:@selector(questionContentViewDidUpdateAnswer:withValue:)])
    [self.delegate questionContentViewDidUpdateAnswer:selected withValue:[_optionsData[index] text]];
}

@end
