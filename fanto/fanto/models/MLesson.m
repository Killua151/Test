//
//  MLessons.m
//  fanto
//
//  Created by Ethan on 9/15/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "MLesson.h"

@implementation MLesson

- (NSString *)description {
  return [NSString stringWithFormat:@"<MLesson - Lesson number: %ld - Objectives: %@>", (long)_lesson_number, _objectives];
}

@end
