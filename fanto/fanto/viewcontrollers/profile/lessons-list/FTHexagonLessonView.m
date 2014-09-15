//
//  FTHexagonLessonView.m
//  fanto
//
//  Created by Ethan on 9/15/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "FTHexagonLessonView.h"
#import "MLesson.h"

@interface FTHexagonLessonView () {
  MLesson *_lessonData;
}

@end

@implementation FTHexagonLessonView

- (id)initWithLesson:(MLesson *)lesson atIndex:(NSInteger)index forTarget:(id)target {
  if (self = [super init]) {
    LoadXibWithSameClass();
    _lessonData = lesson;
    _index = index;
    _delegate = target;
  }
  
  return self;
}

@end
