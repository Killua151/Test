//
//  FTHexagonSkillView.m
//  fanto
//
//  Created by Ethan Nguyen on 9/13/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "FTHexagonSkillView.h"
#import "MSkill.h"

@interface FTHexagonSkillView () {
  MSkill *_skillData;
}

- (void)populateData;

@end

@implementation FTHexagonSkillView

- (id)initWithSkill:(MSkill *)skill andTarget:(id<FTSkillViewDelegate>)target {
  if (self = [super init]) {
    LoadXibWithSameClass();
    _skillData = skill;
    _delegate = target;
  }
  
  return self;
}

- (void)populateData {
  DLog(@"populateData");
}

- (IBAction)btnSkillPressed:(UIButton *)sender {
  if ([_delegate respondsToSelector:@selector(skillViewDidSelectSkill:)])
    [_delegate skillViewDidSelectSkill:_skillData];
}

#pragma mark - Private methods

@end
