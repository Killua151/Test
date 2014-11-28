//
//  FTHexagonSkillView.m
//  fanto
//
//  Created by Ethan Nguyen on 9/13/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "MMHexagonSkillView.h"
#import "MSkill.h"

@interface MMHexagonSkillView ()

@end

@implementation MMHexagonSkillView

- (id)initWithTarget:(id<MMSkillViewDelegate>)target {
  if (self = [super initWithTarget:target]) {
    UIImage *maskingImage = _imgSkillBg.image;
    CALayer *maskingLayer = [CALayer layer];
    maskingLayer.frame = self.bounds;
    [maskingLayer setContents:(id)[maskingImage CGImage]];
    [self.layer setMask:maskingLayer];
    
    _lblSkillName.font = [UIFont fontWithName:@"ClearSans-Bold" size:14];
    _lblLessonsProgress.font = [UIFont fontWithName:@"ClearSans" size:14];
  }
  
  return self;
}

- (void)populateViewWithData:(MSkill *)skill {
  _skillData = skill;
  
  self.backgroundColor = [_skillData themeColor];
  
  if (!_skillData.enabled) {
    _lblSkillName.text = MMLocalizedString(@"Coming soon");
    _imgLaurea.hidden = _imgSkillStrength.hidden = YES;
    _lblLessonsProgress.text = @"";
    return;
  }
  
  _lblSkillName.text = _skillData.slug;
  _imgLaurea.hidden = _imgSkillStrength.hidden = ![_skillData isFinished];
  _lblLessonsProgress.hidden = [_skillData isFinished];
  
  if ([_skillData isFinished])
    _imgSkillStrength.image = [UIImage imageNamed:
                               [NSString stringWithFormat:@"img-hexagon_skill-strength-%ld", (long)_skillData.strength]];
  else
    _lblLessonsProgress.text = [NSString stringWithFormat:@"%ld/%lu",
                                (long)_skillData.finished_lesson, (unsigned long)[_skillData.lessons count]];
  
  NSString *suffix = skill.unlocked ? @"unlocked" : @"locked";
  _imgSkillIcon.image = [UIImage imageNamed:[NSString stringWithFormat:@"img-skill_icon-%@-%@", _skillData._id, suffix]];
}

@end
