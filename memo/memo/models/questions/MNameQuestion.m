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
  
  NSMutableArray *correctAnswers = [NSMutableArray arrayWithObject:_hint];
  
  if (_definitions != nil && [_definitions isKindOfClass:[NSArray class]])
    [correctAnswers addObjectsFromArray:_definitions];
  
  // V1.0 - Crowdsourcing comparison
//  // Group 1 & 2 - case insensitively
//  NSString *normalizedAnswerValue = [answerValue stringByRemovingAllNonLetterCharacters];
//  
//  for (NSString *correctAnswer in correctAnswers) {
//    NSString *normalizedCorrectAnswer = [correctAnswer stringByRemovingAllNonLetterCharacters];
//    
//    if ([normalizedCorrectAnswer compare:normalizedAnswerValue options:NSCaseInsensitiveSearch] == NSOrderedSame)
//      return @{
//               kParamAnswerResult : @(YES),
//               kParamCorrectAnswer : _hint
//               };
//  }
//  
//  // Group 1 & 2 - check typos
//  for (NSString *correctAnswer in correctAnswers) {
//    if ([answerValue wordsCount] != [correctAnswer wordsCount])
//      continue;
//    
//    NSArray *typos = [correctAnswer checkTyposOnString:answerValue];
//    
//    if (typos == nil)
//      continue;
//    
//    return @{
//             kParamAnswerResult : @(YES),
//             kParamCorrectAnswer : correctAnswer,
//             kParamUnderlineRanges : typos
//             };
//  }
  
  // V1.1 - Crowdsourcing comparision: reuse code snippet
  NSDictionary *result = [self checkUserAnswer:answerValue
                            withCorrectAnswers:correctAnswers
                               andCommonErrors:nil
                              shouldCheckTypos:YES];
  
  if (result != nil)
    return result;
  
  return @{
           kParamAnswerResult : @(NO),
           kParamCorrectAnswer : _hint,
           kParamUserAnswer : answerValue
           };
}

@end
