//
//  MBaseQuestion.m
//  fanto
//
//  Created by Ethan Nguyen on 9/27/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "MBaseQuestion.h"
#import "MListenQuestion.h"
#import "MTranslateQuestion.h"
#import "MSortQuestion.h"
#import "MWord.h"

@interface MBaseQuestion ()

+ (Class)questionKlassByType:(NSString *)type;

@end

@implementation MBaseQuestion

+ (instancetype)modelFromDict:(NSDictionary *)modelDict {
  if (modelDict == nil || ![modelDict isKindOfClass:[NSDictionary class]])
    return nil;
  
  Class questionKlass = [[self class] questionKlassByType:modelDict[kParamType]];
  return [[questionKlass modelMappingParser] parseDictionary:modelDict];
}

+ (NSArray *)modelsFromArr:(NSArray *)modelsArr {
  if (modelsArr == nil || ![modelsArr isKindOfClass:[NSArray class]])
    return nil;
  
  NSMutableArray *models = [NSMutableArray array];
  
  for (NSDictionary *modelDict in modelsArr) {
    if (![modelDict isKindOfClass:[NSDictionary class]] ||
        modelDict[kParamType] == nil || ![modelDict[kParamType] isKindOfClass:[NSString class]])
      continue;
    
    Class questionKlass = [[self class] questionKlassByType:modelDict[kParamType]];
    
    if (questionKlass == nil)
      continue;
    
    [models addObject:[[questionKlass modelMappingParser] parseDictionary:modelDict]];
  }
  
#if kTestQuickExam
  [models removeObjectsInRange:NSMakeRange(2, [models count]-2)];
#endif
  
  return models;
}

+ (NSArray *)audioUrlsFromQuestions:(NSArray *)questions {
  NSMutableArray *audioUrls = [NSMutableArray array];
  
  for (MBaseQuestion *question in questions) {
    if (![question isKindOfClass:[MBaseQuestion class]] ||
        ![question respondsToSelector:@selector(normal_question_audio)])
      continue;
    
    NSString *audioUrl = [question performSelector:@selector(normal_question_audio)];
    
    if (audioUrl != nil && [audioUrl isKindOfClass:[NSString class]])
      [audioUrls addObject:audioUrl];

    if ([question respondsToSelector:@selector(slow_question_audio)]) {
      audioUrl = [question performSelector:@selector(slow_question_audio)];
      
      if (audioUrl != nil && [audioUrl isKindOfClass:[NSString class]])
        [audioUrls addObject:audioUrl];
    }
    
//    if ([question isKindOfClass:[MListenQuestion class]]) {
//      if ([(MListenQuestion *)question normal_question_audio] != nil)
//        [audioUrls addObject:[(MListenQuestion *)question normal_question_audio]];
//      
//      if ([(MListenQuestion *)question slow_question_audio])
//        [audioUrls addObject:[(MListenQuestion *)question slow_question_audio]];
//    }
//    
//    if ([question isKindOfClass:[MTranslateQuestion class]])
//      if ([(MTranslateQuestion *)question normal_question_audio] != nil)
//        [audioUrls addObject:[(MTranslateQuestion *)question normal_question_audio]];
//    
//    if ([question isKindOfClass:[MSortQuestion class]])
//      if ([(MSortQuestion *)question normal_question_audio] != nil)
//        [audioUrls addObject:[(MSortQuestion *)question normal_question_audio]];
  }
  
  return audioUrls;
}

// Check if answer value is correct
- (NSDictionary *)checkAnswer:(id)answerValue {
  // Implement in child class
  return nil;
}

- (NSDictionary *)checkUserAnswer:(NSString *)userAnswer
               withCorrectAnswers:(NSArray *)correctAnswers
                  andCommonErrors:(NSArray *)commonErrors
                 shouldCheckTypos:(BOOL)checkTypos {
  //  V1.2 - Crowdsourcing comparison: be able to check common errors
  NSString *normalizedAnswerValue = [userAnswer stringByRemovingAllNonLetterCharacters];
  
  // Group 1 & 2 - check case insensitively
  for (NSString *correctAnswer in correctAnswers) {
    NSString *normalizedCorrectAnswer = [correctAnswer stringByRemovingAllNonLetterCharacters];
    
    if ([normalizedCorrectAnswer compare:normalizedAnswerValue options:NSCaseInsensitiveSearch] == NSOrderedSame)
      return @{
               kParamAnswerResult : @(YES),
               kParamCorrectAnswer : correctAnswers[0],
               kParamUserAnswer : userAnswer
               };
  }
  
  // Group 3 - check case insensitively
  for (NSString *wrongAnswer in commonErrors) {
    NSString *normalizedWrongAnswer = [wrongAnswer stringByRemovingAllNonLetterCharacters];
    
    if ([normalizedWrongAnswer compare:normalizedAnswerValue options:NSCaseInsensitiveSearch] == NSOrderedSame)
      return @{
               kParamAnswerResult : @(NO),
               kParamCorrectAnswer : correctAnswers[0],
               kParamUserAnswer : userAnswer
               };
  }
  
  // Not checking typos, nothing to do here
  if (!checkTypos)
    return nil;
  
  // Group 2 - check typos
  for (NSString *correctAnswer in correctAnswers) {
    if ([userAnswer wordsCount] != [correctAnswer wordsCount])
      continue;
    
    NSArray *typos = [correctAnswer checkTyposOnString:userAnswer];
    
    if (typos == nil)
      continue;
    
    return @{
             kParamAnswerResult : @(YES),
             kParamCorrectAnswer : correctAnswer,
             kParamUnderlineRanges : typos,
             kParamUserAnswer : userAnswer
             };
  }
  
  return nil;
}

#pragma mark - Private methods
+ (Class)questionKlassByType:(NSString *)type {
  if (kTestQuestionType != nil && ![type isEqualToString:kTestQuestionType])
    return nil;
  
  return NSClassFromString([NSString stringWithFormat:@"M%@Question", [type capitalizedString]]);
}

@end
