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
  _lblSkillName.text = _skillData.slug;
  
  NSString *suffix = skill.unlocked ? @"unlocked" : @"locked";
  _imgSkillIcon.image = [UIImage imageNamed:[NSString stringWithFormat:@"img-skill_icon-%@-%@", _skillData._id, suffix]];
}

@end
