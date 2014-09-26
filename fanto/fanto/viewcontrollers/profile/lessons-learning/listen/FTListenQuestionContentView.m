//
//  FTListenQuestionContentView.m
//  fanto
//
//  Created by Ethan Nguyen on 9/26/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "FTListenQuestionContentView.h"

@interface FTListenQuestionContentView () {
  CGFloat _originalAnswerFieldOriginY;
}

- (void)animateAnswerFieldSlideUp:(BOOL)isUp;

@end

@implementation FTListenQuestionContentView

- (void)setupViews {
  _lblQuestionTitle.font = [UIFont fontWithName:@"ClearSans-Bold" size:17];
  _imgAnswerFieldBg.image = [[UIImage imageNamed:@"img-popup-bg.png"]
                             resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)
                             resizingMode:UIImageResizingModeStretch];
  
  _txtAnswerField.font = [UIFont fontWithName:@"ClearSans" size:17];
  
  if (!DeviceScreenIsRetina4Inch()) {
    CGRect frame = _vAnswerField.frame;
    frame.origin.y -= 20;
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
  if ([self.delegate respondsToSelector:@selector(questionContentViewDidEnterEditingMode)])
    [self.delegate questionContentViewDidEnterEditingMode];
  
  [self animateAnswerFieldSlideUp:YES];
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
  if ([self.delegate respondsToSelector:@selector(questionContentViewDidUpdateAnswer:)])
    [self.delegate questionContentViewDidUpdateAnswer:textView.text.length > 0];
  
  return YES;
}

#pragma mark - Private methods
- (void)animateAnswerFieldSlideUp:(BOOL)isUp {
  [UIView
   animateWithDuration:kDefaultAnimationDuration
   delay:0
   options:UIViewAnimationOptionCurveEaseInOut
   animations:^{
     CGRect frame = _vAnswerField.frame;
     frame.origin.y = isUp ? [UIScreen mainScreen].bounds.size.height - kHeightKeyboard - frame.size.height - 86 : _originalAnswerFieldOriginY;
     _vAnswerField.frame = frame;
   }
   completion:^(BOOL finished) {
   }];
}

@end
