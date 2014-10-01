//
//  MSkill.m
//  fanto
//
//  Created by Ethan Nguyen on 9/13/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "MSkill.h"
#import "MLesson.h"
#import "DCParserConfiguration.h"
#import "DCArrayMapping.h"

@implementation MSkill

+ (DCKeyValueObjectMapping *)modelMappingParser {
  DCParserConfiguration *config = [DCParserConfiguration configuration];
  
  DCArrayMapping *lessonsMapping = [DCArrayMapping mapperForClassElements:[MLesson class]
                                                             forAttribute:@"lessons"
                                                                  onClass:[MSkill class]];

  [config addArrayMapper:lessonsMapping];  
  return [DCKeyValueObjectMapping mapperForClass:[MSkill class] andConfiguration:config];
}

- (NSString *)description {
  return [NSString stringWithFormat:@"<MSkill - Id: %@ - Name: %@ - Lessons: %@>", __id, _name, _lessons];
}

- (UIColor *)themeColor {
//  return [UIColor colorWithHexString:@"#33b5e5"];
//  return UIColorFromRGB(255, 187, 51);
  
  if (_theme_color == nil || !_unlocked)
    return UIColorFromRGB(221, 221, 221);
  
  return [UIColor colorWithHexString:_theme_color];
}

@end
