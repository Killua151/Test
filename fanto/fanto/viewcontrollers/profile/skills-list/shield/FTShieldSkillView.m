//
//  FTShieldSkillView.m
//  fanto
//
//  Created by Ethan on 9/15/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "FTShieldSkillView.h"
#import "MSkill.h"

@interface FTShieldSkillView () {
  MSkill *_skillData;
}

@end

@implementation FTShieldSkillView

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
}

@end
