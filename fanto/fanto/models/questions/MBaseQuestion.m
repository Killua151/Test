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

#pragma mark - Private methods
+ (Class)questionKlassByType:(NSString *)type {
  return NSClassFromString([NSString stringWithFormat:@"M%@Question", [type capitalizedString]]);
}

@end
