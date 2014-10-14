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
             kParamCorrectAnswer : self.question,
             kParamUnderlineRange : [NSValue valueWithRange:NSMakeRange(NSNotFound, 0)]
             };
  
  NSString *normalizedAnswer = [answerValue stringByRemovingAllNonLetterCharacters];
  NSString *normalizedQuestion = [self.question stringByRemovingAllNonLetterCharacters];
  
  if ([normalizedAnswer compare:normalizedQuestion options:NSCaseInsensitiveSearch] != NSOrderedSame)
    return @{
             kParamAnswerResult : @(NO),
             kParamCorrectAnswer : self.question,
             kParamUnderlineRange : [NSValue valueWithRange:NSMakeRange(NSNotFound, 0)]
             };
  
  return @{
           kParamAnswerResult : @(YES),
           kParamCorrectAnswer : self.question,
           kParamUnderlineRange : [NSValue valueWithRange:NSMakeRange(NSNotFound, 0)]
           };
}

@end
