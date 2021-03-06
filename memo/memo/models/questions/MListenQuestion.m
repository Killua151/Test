//
//  MListenQuestion.m
//  fanto
//
//  Created by Ethan Nguyen on 10/2/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "MListenQuestion.h"

@implementation MListenQuestion

- (id)checkAnswer:(id)answerValue {
  if (answerValue == nil || ![answerValue isKindOfClass:[NSString class]])
    return @{
             kParamAnswerResult : @(NO),
             kParamCorrectAnswer : self.question
             };
  
  // V1.0: Check typos
//  if ([answerValue wordsCount] != [self.question wordsCount])
//    return @{
//             kParamAnswerResult : @(NO),
//             kParamCorrectAnswer : self.question
//             };
//  
//  NSArray *typos = [self.question checkTyposOnString:answerValue];
//  
//  if (typos == nil)
//    return @{
//             kParamAnswerResult : @(NO),
//             kParamCorrectAnswer : self.question
//             };
//  
//  return @{
//           kParamAnswerResult : @(YES),
//           kParamCorrectAnswer : self.question,
//           kParamUnderlineRanges : typos
//           };

  // V1.1: Check typos with reused code
  NSDictionary *result = [self checkUserAnswer:answerValue
                            withCorrectAnswers:@[self.question]
                               andCommonErrors:nil
                              shouldCheckTypos:YES];
  
  if (result != nil)
    return result;
  
  return @{
           kParamAnswerResult : @(NO),
           kParamCorrectAnswer : self.question,
           kParamUserAnswer : answerValue
           };
}

@end
