//
//  MSelectQuestion.m
//  fanto
//
//  Created by Ethan Nguyen on 9/27/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "MSelectQuestion.h"
#import "MSelectQuestionOption.h"
#import "DCParserConfiguration.h"
#import "DCArrayMapping.h"

@implementation MSelectQuestion

+ (DCKeyValueObjectMapping *)modelMappingParser {
  DCParserConfiguration *config = [DCParserConfiguration configuration];
  
  DCArrayMapping *lessonsMapping = [DCArrayMapping mapperForClassElements:[MSelectQuestionOption class]
                                                             forAttribute:@"options"
                                                                  onClass:[MSelectQuestion class]];
  
  [config addArrayMapper:lessonsMapping];
  return [DCKeyValueObjectMapping mapperForClass:[MSelectQuestion class] andConfiguration:config];
}

@end
