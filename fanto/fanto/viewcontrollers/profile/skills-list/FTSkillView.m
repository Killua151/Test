//
//  FTSkillView.m
//  fanto
//
//  Created by Ethan on 9/15/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "FTSkillView.h"
#import "FTHexagonSkillView.h"
#import "FTShieldSkillView.h"

@implementation FTSkillView

+ (Class)currentSkillViewClass {
#if kHexagonThemeTestMode
  return [FTHexagonSkillView class];
#else
  return [FTShieldSkillView class];
#endif
}

- (id)initWithSkill:(MSkill *)skill andTarget:(id<FTSkillViewDelegate>)target {
  if (self = [super init]) {
    LoadXibWithSameClass();
    
    _skillData = skill;
    _delegate = target;
  }
  
  return self;
}

- (void)populateData {
}

- (IBAction)btnSkillPressed:(UIButton *)sender {
  if ([_delegate respondsToSelector:@selector(skillViewDidSelectSkill:)])
    [_delegate skillViewDidSelectSkill:_skillData];
}

@end
