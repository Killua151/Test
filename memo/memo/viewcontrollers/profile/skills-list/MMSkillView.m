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
#import "MSkill.h"

@implementation MMSkillView

+ (Class)currentSkillViewClass {
#if kHexagonThemeDisplayMode
  return [MMHexagonSkillView class];
#else
  return [MMShieldSkillView class];
#endif
}

- (id)initWithTarget:(id<MMSkillViewDelegate>)target {
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
  if (![_skillData unlocked])
    return;
  
  if ([_delegate respondsToSelector:@selector(skillViewDidSelectSkill:)])
    [_delegate skillViewDidSelectSkill:_skillData];
}

@end
