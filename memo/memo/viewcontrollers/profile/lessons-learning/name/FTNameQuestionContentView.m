//
//  FTNameQuestionContentView.m
//  fanto
//
//  Created by Ethan Nguyen on 9/26/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "FTNameQuestionContentView.h"
#import "FTLessonsLearningViewController.h"
#import "MNameQuestion.h"

@interface FTNameQuestionContentView () {
  CGFloat _originalAnswerFieldOriginY;
}

- (void)animateAnswerFieldSlideUp:(BOOL)isUp;

@end

@implementation FTNameQuestionContentView

- (void)setupViews {
  MNameQuestion *questionData = (MNameQuestion *)self.questionData;
  _lblQuestion.font = [UIFont fontWithName:@"ClearSans-Bold" size:17];
  _lblQuestion.text = [NSString stringWithFormat:NSLocalizedString(@"Translate \"%@\"", nil), questionData.question];
  
  _txtAnswerField.delegate = self;
  _txtAnswerField.font = [UIFont fontWithName:@"ClearSans" size:17];
  _txtAnswerField.placeholder = NSLocalizedString(@"Your answer...", nil);
  
  _vAnswerField.layer.cornerRadius = 3;
  _vAnswerField.layer.borderColor = [UIColorFromRGB(204, 204, 204) CGColor];
  _vAnswerField.layer.borderWidth = 1;
  
  if (!DeviceScreenIsRetina4Inch()) {
    CGRect frame = _imgQuestion.superview.frame;
    frame.size.height = self.frame.size.height - 148;
    _imgQuestion.superview.frame = frame;
    
    frame = _vAnswerField.frame;
    frame.origin.y = _imgQuestion.superview.frame.origin.y + _imgQuestion.superview.frame.size.height +
    (DeviceSystemIsOS7() ? 22 : 11);
    _vAnswerField.frame = frame;
  }
  
  _originalAnswerFieldOriginY = _vAnswerField.frame.origin.y;
}

- (void)gestureLayerDidTap {
  [_txtAnswerField resignFirstResponder];
  [self animateAnswerFieldSlideUp:NO];
}

#pragma mark - UITextFieldDelegate methods
- (void)textFieldDidBeginEditing:(UITextField *)textField {
  if ([self.delegate respondsToSelector:@selector(questionContentViewDidEnterEditingMode)])
    [self.delegate questionContentViewDidEnterEditingMode];
  
  [self animateAnswerFieldSlideUp:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
  if ([self.delegate respondsToSelector:@selector(questionContentViewDidUpdateAnswer:withValue:)])
    [self.delegate questionContentViewDidUpdateAnswer:textField.text.length > 0 withValue:textField.text];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  [self gestureLayerDidTap];
  
  if ([self.delegate respondsToSelector:@selector(questionContentViewGestureLayerDidTap)])
    [self.delegate performSelector:@selector(questionContentViewGestureLayerDidTap)];
  
  return YES;
}

#pragma mark - Private methods
- (void)animateAnswerFieldSlideUp:(BOOL)isUp {
  CGFloat delta = DeviceSystemIsOS7() ? 86 : 106;
  
  [UIView
   animateWithDuration:kDefaultAnimationDuration
   delay:0
   options:UIViewAnimationOptionCurveEaseInOut
   animations:^{
     CGRect frame = _vAnswerField.frame;
     frame.origin.y = isUp ?
     [UIScreen mainScreen].bounds.size.height - kHeightKeyboard - frame.size.height - delta : _originalAnswerFieldOriginY;
     _vAnswerField.frame = frame;
   }
   completion:^(BOOL finished) {
   }];
}

@end