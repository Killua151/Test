//
//  FTSkillView.m
//  fanto
//
//  Created by Ethan on 9/15/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "MMSkillView.h"
#import "MMHexagonSkillView.h"
#import "MMShieldSkillView.h"

@implementation MMSkillView

+ (Class)currentSkillViewClass {
#if kHexagonThemeTestMode
  return [MMHexagonSkillView class];
#else
  return [FTShieldSkillView class];
#endif
}

- (id)initWithTarget:(id<FTSkillViewDelegate>)target {
  if (self = [super init]) {
    LoadXibWithSameClass();
    _delegate = target;
  }
  
  return self;
}

- (void)populateViewWithData:(MSkill *)skill {
  _skillData = skill;
  // Implement in child class
}

- (IBAction)btnSkillPressed:(UIButton *)sender {
  if ([_delegate respondsToSelector:@selector(skillViewDidSelectSkill:)])
    [_delegate skillViewDidSelectSkill:_skillData];
}

@end
