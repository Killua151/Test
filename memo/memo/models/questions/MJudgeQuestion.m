//
//  MJudgeQuestion.m
//  fanto
//
//  Created by Ethan Nguyen on 10/2/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "MJudgeQuestion.h"

@implementation MJudgeQuestion

- (id)checkAnswer:(NSArray *)answerValue {
  NSArray *correctAnswers = [_hints sortedArrayUsingSelector:@selector(compare:)];
  
  if (answerValue == nil || ![answerValue isKindOfClass:[NSArray class]])
    return @{
             kParamAnswerResult : @(NO),
             kParamCorrectAnswer : [correctAnswers componentsJoinedByString:@" / "],
             };
  
  NSArray *usersAnsers = [answerValue sortedArrayUsingSelector:@selector(compare:)];
  
  if (![correctAnswers isEqualToArray:usersAnsers])
    return @{
             kParamAnswerResult : @(NO),
             kParamCorrectAnswer : [correctAnswers componentsJoinedByString:@" / "]
             };
  
  return @{
           kParamAnswerResult : @(YES),
           kParamCorrectAnswer : [correctAnswers componentsJoinedByString:@" / "]
           };
}

@end
