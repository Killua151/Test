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
    return _hint;
  
  NSString *normalizedAnswer = [Utils stringByRemovingAllNonLetterCharacters:answerValue];
  NSString *normalizedHint = [Utils stringByRemovingAllNonLetterCharacters:_hint];
  
  if ([normalizedAnswer compare:normalizedHint options:NSCaseInsensitiveSearch] != NSOrderedSame)
    return _hint;
  
  return nil;
}

@end
