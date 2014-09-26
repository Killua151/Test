//
//  FTNameQuestionContentView.m
//  fanto
//
//  Created by Ethan Nguyen on 9/26/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "FTNameQuestionContentView.h"

@interface FTNameQuestionContentView () {
  CGFloat _originalAnswerFieldOriginY;
}

- (void)animateAnswerFieldSlideUp:(BOOL)isUp;

@end

@implementation FTNameQuestionContentView

- (void)setupViews {
  _lblQuestion.font = [UIFont fontWithName:@"ClearSans-Bold" size:17];
  
  _txtAnswerPlaceholder.font = [UIFont fontWithName:@"ClearSans" size:17];
  _txtAnswerPlaceholder.placeholder = NSLocalizedString(@"Your answer...", nil);
  
  _txtAnswerField.delegate = self;
  _txtAnswerField.font = [UIFont fontWithName:@"ClearSans" size:17];
  
  _vAnswerField.layer.cornerRadius = 3;
  _vAnswerField.layer.borderColor = [UIColorFromRGB(204, 204, 204) CGColor];
  _vAnswerField.layer.borderWidth = 1;
  
  if (!DeviceScreenIsRetina4Inch()) {
    CGRect frame = _imgQuestion.superview.frame;
    frame.size.height = self.frame.size.height - 148;
    _imgQuestion.superview.frame = frame;
    
    frame = _vAnswerField.frame;
    frame.origin.y = _imgQuestion.superview.frame.origin.y + _imgQuestion.superview.frame.size.height + 22;
    _vAnswerField.frame = frame;
  }
  
  _originalAnswerFieldOriginY = _vAnswerField.frame.origin.y;
}

- (void)gestureLayerDidTap {
  [_txtAnswerField resignFirstResponder];
  [self animateAnswerFieldSlideUp:NO];
}

#pragma mark - UITextViewDelegate methods
- (void)textViewDidBeginEditing:(UITextView *)textView {
  _txtAnswerPlaceholder.hidden = YES;
  
  if ([self.delegate respondsToSelector:@selector(questionContentViewDidEnterEditingMode)])
    [self.delegate questionContentViewDidEnterEditingMode];
  
  [self animateAnswerFieldSlideUp:YES];
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
  _txtAnswerPlaceholder.hidden = textView.text.length > 0;
  
  if ([self.delegate respondsToSelector:@selector(questionContentViewDidUpdateAnswer:)])
    [self.delegate questionContentViewDidUpdateAnswer:textView.text.length > 0];
  
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
