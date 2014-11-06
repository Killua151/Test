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
             kParamCorrectAnswer : correctAnswer,
             };
  
  NSMutableArray *correctAnswers = [NSMutableArray arrayWithObject:correctAnswer];
  [correctAnswers addObjectsFromArray:_alternative_answers];
  
  NSString *usersAnswer = [answerValue componentsJoinedByString:@" "];
  
  // V1.0 - Compare case sensitively
//  BOOL answerResult = [usersAnswer isEqualToString:correctAnswer];
  
  // V1.1 - Crowdsourcing comparision: reuse code snippet
  NSDictionary *result = [self checkUserAnswer:usersAnswer
                            withCorrectAnswers:correctAnswers
                               andCommonErrors:_common_errors
                              shouldCheckTypos:NO];
  
  if (result != nil)
    return result;
  
  return @{
           kParamAnswerResult : @(NO),
           kParamCorrectAnswer : correctAnswer,
           kParamUserAnswer : answerValue
           };
}

@end
