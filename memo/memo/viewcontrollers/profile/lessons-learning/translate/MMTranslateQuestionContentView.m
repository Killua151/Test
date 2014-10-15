//
//  FTTranslateQuestionContentView.m
//  fanto
//
//  Created by Ethan Nguyen on 9/26/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "MMTranslateQuestionContentView.h"
#import "MTranslateQuestion.h"
#import "MMExamViewController.h"

@interface MMTranslateQuestionContentView () {
  NSMutableDictionary *_originalSubviewsOriginY;
}

- (void)animateAnswerFieldSlideUp:(BOOL)isUp;

@end

@implementation MMTranslateQuestionContentView

- (void)setupViews {
  MTranslateQuestion *questionData = (MTranslateQuestion *)self.questionData;
  
  _lblQuestionTitle.font = [UIFont fontWithName:@"ClearSans-Bold" size:17];
  _lblQuestionTitle.text = MMLocalizedString(@"Translate this sentence:");
  
  _lblQuestion.font = [UIFont fontWithName:@"ClearSans" size:17];
  _lblQuestion.text = questionData.question;
  [_lblQuestion adjustToFitHeightAndConstrainsToHeight:_btnQuestionAudio.frame.size.height];
  
  CGPoint center = _lblQuestion.center;
  center.y = _btnQuestionAudio.center.y + kFontClearSansMarginTop;
  _lblQuestion.center = center;
  
  _txtAnswerPlaceholder.font = [UIFont fontWithName:@"ClearSans" size:17];
  _txtAnswerPlaceholder.placeholder = MMLocalizedString(@"Your answer...");
  
  _txtAnswerField.delegate = self;
  _txtAnswerField.font = [UIFont fontWithName:@"ClearSans" size:17];
  
  _imgAnswerFieldBg.image = [[UIImage imageNamed:@"img-popup-bg.png"]
                             resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)
                             resizingMode:UIImageResizingModeStretch];
  
  _originalSubviewsOriginY = [NSMutableDictionary dictionary];
  
  for (UIView *subview in self.subviews)
    _originalSubviewsOriginY[[NSString stringWithFormat:@"%p", subview]] = @(subview.frame.origin.y);
}

- (void)gestureLayerDidTap {
  if ([self.delegate respondsToSelector:@selector(questionContentViewGestureLayerDidTap)])
    [self.delegate performSelector:@selector(questionContentViewGestureLayerDidTap)];
  
  [_txtAnswerField resignFirstResponder];
  
  if (!DeviceScreenIsRetina4Inch())
    [self animateAnswerFieldSlideUp:NO];
}

- (IBAction)btnQuestionAudioPressed:(UIButton *)sender {
  MTranslateQuestion *questionData = (MTranslateQuestion *)self.questionData;
  
#if kTestTranslateQuestions
  [Utils showToastWithMessage:questionData.translation];
#endif
  
  [Utils playAudioWithUrl:questionData.normal_question_audio];
}

#pragma mark - UITextViewDelegate methods
- (void)textViewDidBeginEditing:(UITextView *)textView {
  _txtAnswerPlaceholder.hidden = YES;
  
  if ([self.delegate respondsToSelector:@selector(questionContentViewDidEnterEditingMode)])
    [self.delegate questionContentViewDidEnterEditingMode];
  
  if (!DeviceScreenIsRetina4Inch())
    [self animateAnswerFieldSlideUp:YES];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
  _txtAnswerPlaceholder.hidden = textView.text.length > 0;
  
  if ([self.delegate respondsToSelector:@selector(questionContentViewDidUpdateAnswer:withValue:)])
    [self.delegate questionContentViewDidUpdateAnswer:textView.text.length > 0 withValue:textView.text];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
  if ([text isEqualToString:@"\n"]) {
    [self gestureLayerDidTap];
    return NO;
  }
  
  return YES;
}

#pragma mark - Private methods
- (void)animateAnswerFieldSlideUp:(BOOL)isUp {
  CGFloat ratio = [Utils keyboardShrinkRatioForView:self];
  
  [UIView
   animateWithDuration:kDefaultAnimationDuration
   delay:0
   options:UIViewAnimationOptionCurveEaseInOut
   animations:^{
     _lblQuestionTitle.alpha = 1 - isUp;
     
     CGRect frame = _lblQuestionTitle.frame;
     CGFloat originalOriginY = [_originalSubviewsOriginY[[NSString stringWithFormat:@"%p", _lblQuestionTitle]] floatValue];
     frame.origin.y = isUp ? 0 : originalOriginY;
     _lblQuestionTitle.frame = frame;
     
     frame = _lblQuestion.superview.frame;
     originalOriginY = [_originalSubviewsOriginY[[NSString stringWithFormat:@"%p", _lblQuestion.superview]] floatValue];
     frame.origin.y = isUp ? 10 : originalOriginY;
     _lblQuestion.superview.frame = frame;
     
     frame = _vAnswerField.frame;
     originalOriginY = [_originalSubviewsOriginY[[NSString stringWithFormat:@"%p", _vAnswerField]] floatValue];
     frame.origin.y = isUp ? (originalOriginY + frame.size.height) * ratio - frame.size.height - 10 : originalOriginY;
     _vAnswerField.frame = frame;
   }
   completion:^(BOOL finished) {
   }];
}

@end
