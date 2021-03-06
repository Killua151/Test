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

- (NSInteger)strength {
  if (_strength <= 0 || _strength > 4)
    return 4;
  
  return _strength;
}

- (UIColor *)themeColor {
  if (_theme_color == nil || !self.unlocked || !_enabled)
    return UIColorFromRGB(221, 221, 221);
  
  if ([self isFinished])
    return UIColorFromRGB(255, 187, 51);
  
  return [UIColor colorWithHexString:_theme_color];
}

//- (BOOL)unlocked {
//  return YES;
//}

- (BOOL)isFinished {
  return _finished_lesson >= [_lessons count];
}

@end
