//
//  MFormQuestion.m
//  fanto
//
//  Created by Ethan Nguyen on 10/2/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "MFormQuestion.h"

@implementation MFormQuestion

- (id)checkAnswer:(NSArray *)answerValue {
  NSString *correctAnswer = [_tokens componentsJoinedByString:@" "];
  
  if (answerValue == nil || ![answerValue isKindOfClass:[NSArray class]])
    return correctAnswer;
  
  NSString *usersAnswer = [answerValue componentsJoinedByString:@" "];
  
  if ([usersAnswer isEqualToString:correctAnswer])
    return nil;
  
  return correctAnswer;
}

@end
