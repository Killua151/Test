//
//  MTranslateQuestion.m
//  fanto
//
//  Created by Ethan Nguyen on 9/27/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "MTranslateQuestion.h"

@implementation MTranslateQuestion

- (id)checkAnswer:(NSString *)answerValue {
  NSMutableArray *correctAnswers = [NSMutableArray arrayWithObject:_translation];
  
  for (NSArray *tokensGroup in _compact_translations)
    [correctAnswers addObjectsFromArray:[NSString fullSentencesFromTokensGroup:tokensGroup]];

  // Default - Worst comparison
//  for (NSString *correctAnswer in correctAnswers)
//    if ([correctAnswer compare:answerValue options:NSCaseInsensitiveSearch] == NSOrderedSame)
//      return nil;
  
  // V1.0 - Better comparison: remove all punctuations & lower all characters
//  NSString *normalizedAnswerValue = [answerValue stringByRemovingAllNonLetterCharacters];
//  
//  for (NSString *correctAnswer in correctAnswers) {
//    NSString *normalizedCorrectAnswer = [correctAnswer stringByRemovingAllNonLetterCharacters];
//    
//    if ([normalizedCorrectAnswer compare:normalizedAnswerValue options:NSCaseInsensitiveSearch] == NSOrderedSame)
//      return @{
//               kParamAnswerResult : @(YES),
//               kParamCorrectAnswer : _translation
//               };
//  }
  
  // V1.1 - Better comparison: be able to check typos
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
  
  //  V1.2 - Crowdsourcing comparison: be able to check common errors
  NSString *normalizedAnswerValue = [answerValue stringByRemovingAllNonLetterCharacters];
  
  for (NSString *correctAnswer in correctAnswers) {
    NSString *normalizedCorrectAnswer = [correctAnswer stringByRemovingAllNonLetterCharacters];
    
    if ([normalizedCorrectAnswer compare:normalizedAnswerValue options:NSCaseInsensitiveSearch] == NSOrderedSame)
      return @{
               kParamAnswerResult : @(YES),
               kParamCorrectAnswer : _translation
               };
  }
  
  for (NSString *wrongAnswer in _common_errors) {
    NSString *normalizedWrongAnswer = [wrongAnswer stringByRemovingAllNonLetterCharacters];
    
    if ([normalizedWrongAnswer compare:normalizedAnswerValue options:NSCaseInsensitiveSearch] == NSOrderedSame)
      return @{
               kParamAnswerResult : @(NO),
               kParamCorrectAnswer : _translation
               };
  }
  
  for (NSString *correctAnswer in correctAnswers) {
    if ([answerValue wordsCount] != [correctAnswer wordsCount])
      continue;
    
    NSArray *typos = [correctAnswer checkTyposOnString:answerValue];
    
    if (typos == nil)
      continue;
    
    return @{
             kParamAnswerResult : @(YES),
             kParamCorrectAnswer : correctAnswer,
             kParamUnderlineRanges : typos
             };
  }
  
  return @{
           kParamAnswerResult : @(NO),
           kParamCorrectAnswer : _translation,
           kParamUserAnswer : answerValue
           };
}

@end
