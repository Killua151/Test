//
//  MBase.m
//  fanto
//
//  Created by Ethan Nguyen on 9/13/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "MBase.h"

@interface MBase ()

@end

@implementation MBase

+ (instancetype)sharedModel {
  static NSMutableDictionary *_sharedModels = nil;
  
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    _sharedModels = [NSMutableDictionary new];
  });
  
  NSString *klass = NSStringFromClass([self class]);
  
  if (_sharedModels[klass] == nil)
    _sharedModels[klass] = [[self class] new];
  
  return _sharedModels[NSStringFromClass([self class])];
}

+ (instancetype)modelFromDict:(NSDictionary *)modelDict {
  if (modelDict == nil || ![modelDict isKindOfClass:[NSDictionary class]])
    return nil;
  
  DCKeyValueObjectMapping *parser = [[self class] modelMappingParser];
  return [parser parseDictionary:modelDict];
}

+ (NSArray *)modelsFromArr:(NSArray *)modelsArr {
  if (modelsArr == nil || ![modelsArr isKindOfClass:[NSArray class]])
    return nil;
  
  DCKeyValueObjectMapping *parser = [[self class] modelMappingParser];
  return [parser parseArray:modelsArr];
}

+ (DCKeyValueObjectMapping *)modelMappingParser {
  // Default parser
  return [DCKeyValueObjectMapping mapperForClass:[self class]];
}

@end
