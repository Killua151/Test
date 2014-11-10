//
//  FTJudgeButtonView.m
//  fanto
//
//  Created by Ethan Nguyen on 9/25/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "MMSelectQuestionButton.h"
#import "MSelectQuestionOption.h"
#import "MWord.h"

@interface MMSelectQuestionButton () {
  MSelectQuestionOption *_optionData;
  NSInteger _index;
}

- (void)highlightView:(BOOL)highlighted;

@end

@implementation MMSelectQuestionButton

- (id)initWithOption:(MSelectQuestionOption *)option atIndex:(NSInteger)index {
  if (self = [super init]) {
    LoadXibWithSameClass();
    
    _optionData = option;
    _index = index;
    self.tag = index;
    self.layer.cornerRadius = 3;
    _lblOptionTitle.font = [UIFont fontWithName:@"ClearSans" size:17];
    _lblOptionTitle.text = _optionData.text;
    [_imgOptionImage sd_setImageWithURL:[NSURL URLWithString:_optionData.image_file]];
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
  
  if (sender.selected) {
    MWord *word = [[MWord sharedWordsDictionary] wordModelForText:_optionData.text];
    
    if (word != nil)
      [Utils playAudioWithUrl:word.sound];
  }
  
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
