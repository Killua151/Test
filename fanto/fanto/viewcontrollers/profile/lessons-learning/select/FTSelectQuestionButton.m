//
//  FTJudgeButtonView.m
//  fanto
//
//  Created by Ethan Nguyen on 9/25/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "FTSelectQuestionButton.h"

@interface FTSelectQuestionButton () {
  NSInteger _index;
}

- (void)highlightView:(BOOL)highlighted;

@end

@implementation FTSelectQuestionButton

- (id)initWithTitle:(NSString *)title atIndex:(NSInteger)index {
  if (self = [super init]) {
    LoadXibWithSameClass();
    
    _index = index;
    self.tag = index;
    self.layer.cornerRadius = 3;
    _lblOptionTitle.font = [UIFont fontWithName:@"ClearSans" size:17];
    _lblOptionTitle.text = title;
  }
  
  return self;
}

- (void)setSelected:(BOOL)selected {
  [self highlightView:selected];
  _btnGesture.selected = selected;
}

- (IBAction)btnGestureTouchedDown:(UIButton *)sender {
  [self highlightView:sender.highlighted];
}

- (IBAction)btnGesturePressed:(UIButton *)sender {
  sender.selected = !sender.selected;
  [self highlightView:sender.selected];
  
  if ([_delegate respondsToSelector:@selector(selectQuestionButtonDidChanged:atIndex:)])
    [_delegate selectQuestionButtonDidChanged:sender.selected atIndex:_index];
}

- (IBAction)btnGestureTouchedUpOutside:(UIButton *)sender {
  [self highlightView:sender.highlighted];
}

#pragma mark - Private methods
- (void)highlightView:(BOOL)highlighted {
  self.backgroundColor = highlighted ? UIColorFromRGB(129, 12, 21) : UIColorFromRGB(219, 219, 219);
  _imgRadio.image = [UIImage imageNamed:[NSString stringWithFormat:@"img-judge_question-radio%@.png",
                                         highlighted ? @"_selected" : @""]];
  _lblOptionTitle.textColor = highlighted ? [UIColor whiteColor] : UIColorFromRGB(102, 102, 102);
}

@end
