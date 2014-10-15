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
             kParamCorrectAnswer : _hint
             };
  
  NSArray *typos = [_hint checkTyposOnString:answerValue];
  
  if (typos == nil)
    return @{
             kParamAnswerResult : @(NO),
             kParamCorrectAnswer : self.question
             };
  
  return @{
           kParamAnswerResult : @([typos count] > 0),
           kParamCorrectAnswer : self.question,
           kParamUnderlineRanges : typos
           };
}

@end
