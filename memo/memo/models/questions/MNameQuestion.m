//
//  MNameQuestion.m
//  fanto
//
//  Created by Ethan Nguyen on 10/2/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "MNameQuestion.h"

@implementation MNameQuestion

- (id)checkAnswer:(id)answerValue {
  if (answerValue == nil || ![answerValue isKindOfClass:[NSString class]])
    return @{
             kParamAnswerResult : @(NO),
             kParamCorrectAnswer : _hint
             };
  
  if ([answerValue wordsCount] != [_hint wordsCount])
    return @{
             kParamAnswerResult : @(NO),
             kParamCorrectAnswer : _hint,
             kParamUserAnswer : answerValue
             };
  
  NSArray *typos = [_hint checkTyposOnString:answerValue];
  
  if (typos == nil)
    return @{
             kParamAnswerResult : @(NO),
             kParamCorrectAnswer : _hint,
             kParamUserAnswer : answerValue
             };
  
  return @{
           kParamAnswerResult : @(YES),
           kParamCorrectAnswer : _hint,
           kParamUnderlineRanges : typos,
           kParamUserAnswer : answerValue
           };
}

@end
