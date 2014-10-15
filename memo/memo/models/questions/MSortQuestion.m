//
//  MFormQuestion.m
//  fanto
//
//  Created by Ethan Nguyen on 10/2/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "MSortQuestion.h"

@implementation MSortQuestion

- (id)checkAnswer:(NSArray *)answerValue {
  NSString *correctAnswer = [_tokens componentsJoinedByString:@" "];
  
  if (answerValue == nil || ![answerValue isKindOfClass:[NSArray class]])
    return @{
             kParamAnswerResult : @(NO),
             kParamCorrectAnswer : correctAnswer
             };
  
  NSString *usersAnswer = [answerValue componentsJoinedByString:@" "];
  
  BOOL answerResult = [usersAnswer isEqualToString:correctAnswer];
  
  return @{
           kParamAnswerResult : @(answerResult),
           kParamCorrectAnswer : correctAnswer
           };
}

@end
