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
    if (![question isKindOfClass:[MBaseQuestion class]])
      continue;
    
    if ([question isKindOfClass:[MListenQuestion class]]) {
      if ([(MListenQuestion *)question normal_question_audio] != nil)
        [audioUrls addObject:[(MListenQuestion *)question normal_question_audio]];
      
      if ([(MListenQuestion *)question slow_question_audio])
        [audioUrls addObject:[(MListenQuestion *)question slow_question_audio]];
    }
    
    if ([question isKindOfClass:[MTranslateQuestion class]])
      if ([(MTranslateQuestion *)question normal_question_audio] != nil)
        [audioUrls addObject:[(MTranslateQuestion *)question normal_question_audio]];
    
    if ([question isKindOfClass:[MSortQuestion class]])
      if ([(MSortQuestion *)question normal_answer_audio] != nil)
        [audioUrls addObject:[(MSortQuestion *)question normal_answer_audio]];
  }
  
  return audioUrls;
}

// Check if answer value is correct
- (NSDictionary *)checkAnswer:(id)answerValue {
  // Implement in child class
  return nil;
}

#pragma mark - Private methods
+ (Class)questionKlassByType:(NSString *)type {
  if (![type isEqualToString:@"translate"])
    return nil;
  
  return NSClassFromString([NSString stringWithFormat:@"M%@Question", [type capitalizedString]]);
}

@end
