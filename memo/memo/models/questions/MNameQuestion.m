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
             kParamCorrectAnswer : _hint,
             kParamUnderlineRange : [NSValue valueWithRange:NSMakeRange(NSNotFound, 0)]
             };
  
  NSString *normalizedAnswer = [answerValue stringByRemovingAllNonLetterCharacters];
  NSString *normalizedHint = [_hint stringByRemovingAllNonLetterCharacters];
  
  if ([normalizedAnswer compare:normalizedHint options:NSCaseInsensitiveSearch] != NSOrderedSame)
    return @{
             kParamAnswerResult : @(NO),
             kParamCorrectAnswer : _hint,
             kParamUnderlineRange : [NSValue valueWithRange:NSMakeRange(NSNotFound, 0)]
             };
  
  return @{
           kParamAnswerResult : @(YES),
           kParamCorrectAnswer : _hint,
           kParamUnderlineRange : [NSValue valueWithRange:NSMakeRange(NSNotFound, 0)]
           };
}

@end
