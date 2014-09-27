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
