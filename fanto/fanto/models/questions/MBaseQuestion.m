//
//  MBaseQuestion.m
//  fanto
//
//  Created by Ethan Nguyen on 9/27/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "MBaseQuestion.h"

@interface MBaseQuestion ()

+ (Class)questionKlassByType:(NSString *)type;

@end

@implementation MBaseQuestion

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
  
  return models;
}

// Check if answer value is correct
// If nil: answer is correct
// Else: returned value is correct answer
- (id)checkAnswer:(id)answerValue {
  // Implement in child class
  return nil;
}

#pragma mark - Private methods
+ (Class)questionKlassByType:(NSString *)type {
  if (![type isEqualToString:@"judge"])
    return nil;
  
  return NSClassFromString([NSString stringWithFormat:@"M%@Question", [type capitalizedString]]);
}

@end
