//
//  MJudgeQuestion.m
//  fanto
//
//  Created by Ethan Nguyen on 10/2/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "MJudgeQuestion.h"

@implementation MJudgeQuestion

- (id)checkAnswer:(id)answerValue {
  if (answerValue == nil || ![answerValue isKindOfClass:[NSArray class]])
    return nil;
  
  NSArray *usersAnsers = [answerValue sortedArrayUsingSelector:@selector(compare:)];
  NSArray *correctAnswers = [@[_hint] sortedArrayUsingSelector:@selector(compare:)];
  
  if ([correctAnswers isEqualToArray:usersAnsers])
    return nil;
  
  return [correctAnswers componentsJoinedByString:@" / "];
}

@end
