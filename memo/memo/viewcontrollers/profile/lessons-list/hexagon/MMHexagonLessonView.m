//
//  FTHexagonLessonView.m
//  fanto
//
//  Created by Ethan on 9/15/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "MMHexagonLessonView.h"
#import "MSkill.h"
#import "MLesson.h"

@interface MMHexagonLessonView () {
  MSkill *_skillData;
  MLesson *_lessonData;
  UIColor *_themeColor;
}

- (void)setupViews;

@end

@implementation MMHexagonLessonView

- (id)initWithLessonNumber:(NSInteger)lessonNumber inSkill:(MSkill *)skill forTarget:(id)target {
  if (self = [super init]) {
    LoadXibWithSameClass();
    _skillData = skill;
    _index = lessonNumber-1;
    _lessonData = _skillData.lessons[_index];
    _delegate = target;
    _themeColor = [_skillData themeColor];
    
    [self setupViews];
  }
  
  return self;
}

- (void)refreshView {
  return;
  
  CGSize sizeThatFits = [_lblObjectives sizeThatFits:CGSizeMake(self.frame.size.width * 0.7, MAXFLOAT)];
  sizeThatFits.height = MAX(sizeThatFits.height, 50);
  _lblObjectives.frame = (CGRect){CGPointZero, sizeThatFits};
  _lblObjectives.center = CGPointMake(self.frame.size.width/2, self.frame.size.height*0.45);
}

- (IBAction)btnRetakePressed:(UIButton *)sender {
  if ([_delegate respondsToSelector:@selector(lessonViewDidSelectLesson:)])
    [_delegate lessonViewDidSelectLesson:_lessonData];
}

#pragma mark - Private methods
- (void)setupViews {
  _lblLessonTitle.font = [UIFont fontWithName:@"ClearSans-Bold" size:17];
  _lblLessonTitle.text = [NSString stringWithFormat:MMLocalizedString(@"Lesson %d/%d"),
                          _lessonData.lesson_number, [_skillData.lessons count]];
  _imgPassed.hidden = _lessonData.lesson_number > _skillData.finished_lesson;
  
  _lblObjectives.font = [UIFont fontWithName:@"ClearSans" size:14];
  _lblObjectives.text = [_lessonData.objectives componentsJoinedByString:@", "];
  [Utils adjustLabelToFitHeight:_lblObjectives];
  
  _lblObjectives.center = CGPointMake(_lblObjectives.center.x, self.center.y);
  
  // Default is passed & user can retake the lesson
  NSString *btnRetakeTitle = MMLocalizedString(@"RETAKE");
  
  if (!_skillData.unlocked || _lessonData.lesson_number > _skillData.finished_lesson+1) {
    btnRetakeTitle = MMLocalizedString(@"LOCKED");
    _btnRetake.enabled = NO;
  } else if (_lessonData.lesson_number == _skillData.finished_lesson+1)
    // Unlocked but not passed
    btnRetakeTitle = MMLocalizedString(@"START");
  
  _btnRetake.titleLabel.font = [UIFont fontWithName:@"ClearSans-Bold" size:14];
  [_btnRetake setTitle:btnRetakeTitle forState:UIControlStateNormal];
  
  UIImage *maskingImage = [UIImage imageNamed:@"btn-hexagon_lesson-retake.png"];
  CALayer *maskingLayer = [CALayer layer];
  maskingLayer.frame = _btnRetake.bounds;
  [maskingLayer setContents:(id)[maskingImage CGImage]];
  [_btnRetake.layer setMask:maskingLayer];
  
  [_btnRetake setBackgroundImage:[UIImage imageFromColor:_themeColor] forState:UIControlStateNormal];
  [_btnRetake setBackgroundImage:[UIImage imageFromColor:UIColorFromRGB(102, 102, 102)] forState:UIControlStateDisabled];
}

@end
