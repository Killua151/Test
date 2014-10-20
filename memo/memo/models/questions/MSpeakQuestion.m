//
//  MSpeakQuestion.m
//  fanto
//
//  Created by Ethan Nguyen on 10/2/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "MSpeakQuestion.h"
#import "ISSpeechRecognitionResult.h"

@implementation MSpeakQuestion

- (id)checkAnswer:(id)answerValue {
  ISSpeechRecognitionResult *answer = answerValue;
  
  if (answer.confidence < 0.2)
    return @{
             kParamAnswerResult : @(NO),
             kParamCorrectAnswer : self.question
             };
  
  DiffMatchPatch *dmp = [DiffMatchPatch new];
  NSArray *diffs = [dmp diff_mainOfOldString:self.question andNewString:answer.text];
  
  CGFloat equalCharsCount = 0;
  
  for (Diff *diff in diffs) {
    if (diff.operation != DIFF_EQUAL)
      continue;
    
    equalCharsCount += diff.text.length;
  }
  
  CGFloat rate = equalCharsCount / self.question.length;
  
  return @{
           kParamAnswerResult : @(rate >= 0.3),
           kParamCorrectAnswer : self.question
           };
}

@end
