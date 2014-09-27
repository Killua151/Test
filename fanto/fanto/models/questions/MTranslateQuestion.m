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
  [correctAnswers addObjectsFromArray:_translations_group2];
  
  for (NSString *correctAnswer in correctAnswers)
    if ([correctAnswer compare:answerValue options:NSCaseInsensitiveSearch] == NSOrderedSame)
      return nil;
  
  return _translation;
}

@end
