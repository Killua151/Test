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

- (id)initWithLesson:(MLesson *)lesson atIndex:(NSInteger)index withThemeColor:(UIColor *)themeColor forTarget:(id)target {
  if (self = [super init]) {
    LoadXibWithSameClass();
    _lessonData = lesson;
    _index = index;
    _delegate = target;
    
    _lblLessonTitle.font = [UIFont fontWithName:@"ClearSans-Bold" size:17];
    _lblObjectives.font = [UIFont fontWithName:@"ClearSans" size:14];
    _btnRetake.titleLabel.font = [UIFont fontWithName:@"ClearSans-Bold" size:14];
    
    UIImage *maskingImage = [UIImage imageNamed:@"btn-hexagon_lesson-retake.png"];
    CALayer *maskingLayer = [CALayer layer];
    maskingLayer.frame = _btnRetake.bounds;
    [maskingLayer setContents:(id)[maskingImage CGImage]];
    [_btnRetake.layer setMask:maskingLayer];
    
    [_btnRetake setBackgroundColor:themeColor];
  }
  
  return self;
}

- (void)refreshView {
  CGSize sizeThatFits = [_lblObjectives sizeThatFits:CGSizeMake(self.frame.size.width * 0.7, MAXFLOAT)];
  sizeThatFits.height = MAX(sizeThatFits.height, 50);
  _lblObjectives.frame = (CGRect){CGPointZero, sizeThatFits};
  _lblObjectives.center = CGPointMake(self.frame.size.width/2, self.frame.size.height*0.45);
}

- (IBAction)btnRetakePressed:(UIButton *)sender {
  if ([_delegate respondsToSelector:@selector(lessonViewDidSelectLesson:)])
    [_delegate lessonViewDidSelectLesson:_lessonData];
}

@end
