//
//  FTFormQuestionContentView.m
//  fanto
//
//  Created by Ethan Nguyen on 9/27/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "MMSortQuestionContentView.h"
#import "MMSortQuestionAnswerTokenButton.h"
#import "MSortQuestion.h"

@interface MMSortQuestionContentView () {
  NSMutableArray *_btnAnsweredTokens;
  NSMutableArray *_btnAvailableTokens;
}

- (void)setupTokenButtonsForView:(UIView *)parentView
                  withDataSource:(NSArray *)tokensData
                          saveIn:(NSMutableArray *)buttonsArray;
- (void)animateSortButtons:(NSArray *)buttonsArray inView:(UIView *)parentView;
- (void)animateMoveButton:(MMSortQuestionAnswerTokenButton *)button
                 fromView:(UIView *)fromView
                  inArray:(NSMutableArray *)sourceButtons
                   toView:(UIView *)toView
                  inArray:(NSMutableArray *)destinationButtons;

@end

@implementation MMSortQuestionContentView

- (void)setupViews {
  MSortQuestion *questionData = (MSortQuestion *)self.questionData;
  
  _lblQuestionTitle.font = [UIFont fontWithName:@"ClearSans-Bold" size:17];
  _lblQuestionTitle.text = MMLocalizedString(@"Translate this sentence:");
  
  _lblQuestion.font = [UIFont fontWithName:@"ClearSans" size:17];
  _lblQuestion.text = questionData.question;
  [_lblQuestion adjustToFitHeightAndConstrainsToHeight:_btnAnswerAudio.frame.size.height];
  
  CGPoint center = _lblQuestion.center;
  center.y = _btnAnswerAudio.center.y + kFontClearSansMarginTop;
  _lblQuestion.center = center;
  
  _txtAnswerPlaceholder.font = [UIFont fontWithName:@"ClearSans" size:17];
  _txtAnswerPlaceholder.placeholder = MMLocalizedString(@"Your answer...");
  
  _imgAnswerFieldBg.image = [[UIImage imageNamed:@"img-popup-bg.png"]
                             resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)
                             resizingMode:UIImageResizingModeStretch];
  
  if (!DeviceScreenIsRetina4Inch()) {
    CGRect frame = _lblQuestionTitle.frame;
    frame.origin.y -= DeviceSystemIsOS7() ? 10 : 10;
    _lblQuestionTitle.frame = frame;
    
    frame = _btnAnswerAudio.frame;
    frame.origin.y -= DeviceSystemIsOS7() ? 15 : 25;
    _btnAnswerAudio.frame = frame;
    
    frame = _lblQuestion.frame;
    frame.origin.y -= DeviceSystemIsOS7() ? 15 : 25;
    _lblQuestion.frame = frame;
    
    frame = _vAnsweredTokens.frame;
    frame.origin.y -= DeviceSystemIsOS7() ? 25 : 30;
    frame.size.height = 110;
    _vAnsweredTokens.frame = frame;
    
    frame = _vAvailableTokens.frame;
    frame.origin.y -= DeviceSystemIsOS7() ? 30 : 40;
    frame.size.height -= DeviceSystemIsOS7() ? 45 : 45;
    _vAvailableTokens.frame = frame;
  }
  
  _btnAnsweredTokens = [NSMutableArray new];
  
  NSMutableArray *availableTokens = [NSMutableArray arrayWithArray:questionData.tokens];
  [availableTokens addObjectsFromArray:questionData.wrong_tokens];
  [availableTokens shuffle];
  
  _btnAvailableTokens = [NSMutableArray new];
  [self setupTokenButtonsForView:_vAvailableTokens withDataSource:availableTokens saveIn:_btnAvailableTokens];
  
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    [self btnAnswerAudioPressed:nil];
  });
}

- (IBAction)btnAnswerAudioPressed:(UIButton *)sender {
  MSortQuestion *questionData = (MSortQuestion *)self.questionData;
  
#if kTestTranslateQuestions
  [Utils showToastWithMessage:[questionData.tokens componentsJoinedByString:@" "]];
#endif
  
  [Utils playAudioWithUrl:questionData.normal_answer_audio];
}

#pragma mark - MMQuestionContentDelegate methods
- (void)formTokenButtonDidSelect:(MMSortQuestionAnswerTokenButton *)button {
  if (button.status == FormAnswerTokenAvailable)
    [self animateMoveButton:button
                   fromView:_vAvailableTokens
                    inArray:_btnAvailableTokens
                     toView:_vAnsweredTokens
                    inArray:_btnAnsweredTokens];
  else
    [self animateMoveButton:button
                   fromView:_vAnsweredTokens
                    inArray:_btnAnsweredTokens
                     toView:_vAvailableTokens
                    inArray:_btnAvailableTokens];
}

#pragma mark - Private methods
- (void)setupTokenButtonsForView:(UIView *)parentView
                  withDataSource:(NSArray *)tokensData
                          saveIn:(NSMutableArray *)buttonsArray {
  for (UIView *subview in parentView.subviews)
    if ([subview isKindOfClass:[MMSortQuestionAnswerTokenButton class]])
      [subview removeFromSuperview];
  
  [buttonsArray removeAllObjects];
  
  [tokensData enumerateObjectsUsingBlock:^(NSString *token, NSUInteger index, BOOL *stop) {
    MMSortQuestionAnswerTokenButton *button = [[MMSortQuestionAnswerTokenButton alloc] initWithToken:token atIndex:index];
    button.delegate = self;
    button.status = parentView == _vAvailableTokens ? FormAnswerTokenAvailable : FormAnswerTokenAnswered;
    
    [buttonsArray addObject:button];
    [parentView addSubview:button];
  }];
  
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    [self animateSortButtons:buttonsArray inView:parentView];
  });
}

- (void)animateSortButtons:(NSArray *)buttonsArray inView:(UIView *)parentView {
  CGPoint origin = CGPointMake(3, 3);
  CGFloat buttonsGap = 10;
  
  [UIView
   animateWithDuration:kDefaultAnimationDuration
   delay:0
   options:UIViewAnimationOptionCurveEaseInOut
   animations:^{
     CGFloat currentOffsetX = 0;
     CGFloat currentOffsetY = 0;
     CGRect frame = CGRectZero;
     
     for (MMSortQuestionAnswerTokenButton *button in buttonsArray) {
       frame = button.frame;
       
       if (origin.x + currentOffsetX + frame.size.width > parentView.frame.size.width) {
         currentOffsetX = 0;
         currentOffsetY += (frame.size.height + buttonsGap);
       }
       
       frame.origin.x = origin.x + currentOffsetX;
       frame.origin.y = origin.y + currentOffsetY;
       button.frame = frame;
       
       currentOffsetX += (frame.size.width + buttonsGap);
     }
   }
   completion:^(BOOL finished) {
   }];
}

- (void)animateMoveButton:(MMSortQuestionAnswerTokenButton *)button
                 fromView:(UIView *)fromView
                  inArray:(NSMutableArray *)sourceButtons
                   toView:(UIView *)toView
                  inArray:(NSMutableArray *)destinationButtons {
  CGPoint origin = CGPointMake(3, 3);
  CGFloat buttonsGap = 10;
  
  CGPoint destButtonOrigin = CGPointMake(0, 3);
  
  if ([destinationButtons count] > 0) {
    MMSortQuestionAnswerTokenButton *lastDestButton = [destinationButtons lastObject];
    destButtonOrigin.x = lastDestButton.frame.origin.x + lastDestButton.frame.size.width + buttonsGap;
    destButtonOrigin.y = lastDestButton.frame.origin.y;
  }
  
  CGRect frame = button.frame;
  
  if (origin.x + destButtonOrigin.x + frame.size.width > toView.frame.size.width) {
    destButtonOrigin.x = 0;
    destButtonOrigin.y += (frame.size.height + buttonsGap);
  }
  
  frame.origin.x = origin.x + destButtonOrigin.x;
  frame.origin.y = destButtonOrigin.y;
  
  [sourceButtons removeObject:button];
  [self animateSortButtons:sourceButtons inView:fromView];
  
  CGRect newFrame = [self convertRect:[self convertRect:frame fromView:toView] toView:fromView];
  
  [UIView
   animateWithDuration:kDefaultAnimationDuration
   animations:^{
     button.frame = newFrame;
   }
   completion:^(BOOL finished) {
     [button removeFromSuperview];
     button.frame = frame;
     [destinationButtons addObject:button];
     [toView addSubview:button];
     
     button.status = (button.status+1)%2;
     
     if ([self.delegate respondsToSelector:@selector(questionContentViewDidUpdateAnswer:withValue:)])
       [self.delegate questionContentViewDidUpdateAnswer:[_btnAnsweredTokens count] > 0
                                               withValue:[_btnAnsweredTokens valueForKey:@"token"]];
   }];
}

@end
