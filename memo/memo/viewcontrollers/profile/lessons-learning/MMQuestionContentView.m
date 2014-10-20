//
//  FTQuestionContentView.m
//  fanto
//
//  Created by Ethan on 9/26/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "MMQuestionContentView.h"
#import "MMExamViewController.h"
#import "MBaseQuestion.h"
#import "MWord.h"
#import "MMWordDefinitionsView.h"

@interface MMQuestionContentView () {
  MMWordDefinitionsView *_vWordDefinitions;
}

- (void)setupViewFrame;
- (void)showWordDefinitions:(NSArray *)wordDefinitions inFrame:(CGRect)displayingFrame fromLabel:(UILabel *)label;

@end

@implementation MMQuestionContentView

- (id)initWithQuestion:(MBaseQuestion *)question {
  if (self = [super init]) {
    LoadXibWithSameClass();
    _questionData = question;
    
    [self setupViewFrame];
    [self setupViews];
  }
  
  return self;
}

- (void)setupViews {
  // Implement in child class
}

- (void)gestureLayerDidTap {
  if ([_delegate respondsToSelector:@selector(questionContentViewGestureLayerDidTap)])
    [_delegate performSelector:@selector(questionContentViewGestureLayerDidTap)];
  
  [_vWordDefinitions removeFromSuperview];
}

- (TTTAttributedLabel *)cloneStyledQuestionLabelAs:(UILabel *)originalQuestionLabel {
  if ([_questionData.objectives count] == 0 && [_questionData.special_objectives count] == 0)
    return nil;
  
  TTTAttributedLabel *styledQuestionLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
  styledQuestionLabel.font = originalQuestionLabel.font;
  styledQuestionLabel.textColor = originalQuestionLabel.textColor;
  styledQuestionLabel.lineBreakMode = originalQuestionLabel.lineBreakMode;
  styledQuestionLabel.numberOfLines = originalQuestionLabel.numberOfLines;
  styledQuestionLabel.delegate = self;
  styledQuestionLabel.text = _questionData.question;
  [styledQuestionLabel applyWordDefinitions:_questionData.objectives withSpecialWords:_questionData.special_objectives];

  return styledQuestionLabel;
}

#pragma mark - TTTAttributedLabelDelegate methods
- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithAddress:(NSDictionary *)addressComponents {
  NSRange wordRange = [addressComponents[kParamWordRange] rangeValue];
  
  MWord *word = [MWord sharedModel].dictionary[addressComponents[kParamWord]];
  [Utils playAudioWithUrl:word.sound];

  if ([_delegate respondsToSelector:@selector(questionContentViewDidEnterEditingMode:)])
    [_delegate questionContentViewDidEnterEditingMode:NO];
  
  CGRect displayingFrame = [label boundingRectForCharacterRange:wordRange];
  [self showWordDefinitions:word.definitions inFrame:displayingFrame fromLabel:label];
}

#pragma mark - Private methods
- (void)setupViewFrame {
  CGRect frame = self.frame;
  frame.size.height = DeviceScreenIsRetina4Inch() ? 430 : 342;
  self.frame = frame;
}

- (void)showWordDefinitions:(NSArray *)wordDefinitions inFrame:(CGRect)displayingFrame fromLabel:(UILabel *)label {
  UIView *questionView = label.superview;
  
  if (questionView == nil)
    return;
  
  if (_vWordDefinitions == nil)
    _vWordDefinitions = [MMWordDefinitionsView new];
  
  [_vWordDefinitions reloadContentsWithData:wordDefinitions];
  
  CGRect converted = [questionView convertRect:displayingFrame fromView:label];
  converted = [questionView convertRect:converted toView:self];
  
  converted.origin.x = converted.origin.x + displayingFrame.size.width/2 - _vWordDefinitions.frame.size.width/2;
  converted.origin.y += displayingFrame.size.height + 10;
  
  CGRect frame = _vWordDefinitions.frame;
  frame.origin = converted.origin;
  _vWordDefinitions.frame = frame;
  
  [self addSubview:_vWordDefinitions];
}

@end
