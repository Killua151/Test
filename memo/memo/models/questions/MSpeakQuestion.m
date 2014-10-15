//
//  MSpeakQuestion.m
//  fanto
//
//  Created by Ethan Nguyen on 10/2/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "MSpeakQuestion.h"

@implementation MSpeakQuestion

- (id)checkAnswer:(id)answerValue {
  DLog(@"%@ %@", answerValue, self.question);
  
  return @{
           kParamAnswerResult : @(YES),
           kParamCorrectAnswer : self.question
           };
}

@end
