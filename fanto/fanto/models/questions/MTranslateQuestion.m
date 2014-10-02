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
  [correctAnswers addObjectsFromArray:[NSString fullSentencesFromTokensGroup:_compact_translations]];

  // Default - Worst comparison
//  for (NSString *correctAnswer in correctAnswers)
//    if ([correctAnswer compare:answerValue options:NSCaseInsensitiveSearch] == NSOrderedSame)
//      return nil;
  
  // V1.0 - Better comparison: remove all punctuations & lower all characters
  NSString *normalizedAnswerValue = [Utils stringByRemovingAllNonLetterCharacters:answerValue];
  
  for (NSString *correctAnswer in correctAnswers) {
    NSString *normalizedCorrectAnswer = [Utils stringByRemovingAllNonLetterCharacters:correctAnswer];
    
    if ([normalizedCorrectAnswer compare:normalizedAnswerValue options:NSCaseInsensitiveSearch] == NSOrderedSame)
      return nil;
  }
  
  return _translation;
}

@end
