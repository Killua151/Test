//
//  FTListenQuestionContentView.m
//  fanto
//
//  Created by Ethan Nguyen on 9/26/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "MMListenQuestionContentView.h"
#import "MListenQuestion.h"

@interface MMListenQuestionContentView () {
  NSMutableDictionary *_originalSubviewsOrigin;
  NSMutableDictionary *_originalSubviewsSize;
}

- (void)animateAnswerFieldSlideUp:(BOOL)isUp;

@end

@implementation MMListenQuestionContentView

- (void)setupViews {
  _lblQuestionTitle.font = [UIFont fontWithName:@"ClearSans-Bold" size:17];
  _lblQuestionTitle.text = MMLocalizedString(@"Type what you listen");
  
  _txtAnswerPlaceholder.font = [UIFont fontWithName:@"ClearSans" size:17];
  _txtAnswerPlaceholder.placeholder = MMLocalizedString(@"Your answer...");
  
  _txtAnswerField.delegate = self;
  _txtAnswerField.font = [UIFont fontWithName:@"ClearSans" size:17];
  
  _imgAnswerFieldBg.image = [[UIImage imageNamed:@"img-popup-bg.png"]
                             resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)
                             resizingMode:UIImageResizingModeStretch];
  
  if (!DeviceScreenIsRetina4Inch()) {
    CGRect frame = _vAnswerField.frame;
    frame.origin.y -= 20;
    _vAnswerField.frame = frame;
  }
  
  _originalSubviewsOrigin = [NSMutableDictionary dictionary];
  _originalSubviewsSize = [NSMutableDictionary dictionary];
  
  for (UIView *subview in self.subviews) {
    NSString *subviewKey = [NSString stringWithFormat:@"%p", subview];
    
    _originalSubviewsOrigin[subviewKey] = [NSValue valueWithCGPoint:subview.frame.origin];
    _originalSubviewsSize[subviewKey] = [NSValue valueWithCGSize:subview.frame.size];
  }
  
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    [self btnNormalAudioPressed:nil];
  });
}

- (void)gestureLayerDidTap {
  [super gestureLayerDidTap];
  
  [_txtAnswerField resignFirstResponder];
  [self animateAnswerFieldSlideUp:NO];
}

- (IBAction)btnNormalAudioPressed:(UIButton *)sender {
  MListenQuestion *questionData = (MListenQuestion *)self.questionData;
  
#if kTestTranslateQuestions
  [Utils showToastWithMessage:questionData.question];
#endif
  
  [Utils playAudioWithUrl:questionData.normal_question_audio];
}

- (IBAction)btnSlowAudioPressed:(UIButton *)sender {
  [Utils playAudioWithUrl:[(MListenQuestion *)self.questionData slow_question_audio]];
}

#pragma mark - UITextViewDelegate methods
- (void)textViewDidBeginEditing:(UITextView *)textView {
  _txtAnswerPlaceholder.hidden = YES;
  
  if ([self.delegate respondsToSelector:@selector(questionContentViewDidEnterEditingMode:)])
    [self.delegate questionContentViewDidEnterEditingMode:YES];
  
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
     
     for (UIView *subview in self.subviews) {
       NSString *subviewKey = [NSString stringWithFormat:@"%p", subview];
       
       CGRect frame = subview.frame;
       CGPoint originalOrigin = [_originalSubviewsOrigin[subviewKey] CGPointValue];
       CGSize originalSize = [_originalSubviewsSize[subviewKey] CGSizeValue];
       
       if (!isUp) {
         frame.origin = originalOrigin;
         frame.size = originalSize;
       } else {
         if ([subview isKindOfClass:[UIButton class]]) {
           frame.size.width = originalSize.width * ratio;
           frame.size.height = originalSize.height * ratio;
           
           // Maintain original center X
           frame.origin.x = originalOrigin.x + originalSize.width/2 - frame.size.width/2;
           frame.origin.y = (originalOrigin.y + frame.size.height) * ratio - frame.size.height -
           (DeviceScreenIsRetina4Inch() ? 0 : 5);
         } else
           frame.origin.y = (originalOrigin.y + frame.size.height) * ratio - frame.size.height -
           (DeviceScreenIsRetina4Inch() ? 10 : 5);
       }
       
       subview.frame = frame;
     }
   }
   completion:^(BOOL finished) {
   }];
}

@end
