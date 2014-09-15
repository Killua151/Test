//
//  FTHexagonSkillView.m
//  fanto
//
//  Created by Ethan Nguyen on 9/13/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "FTHexagonSkillView.h"
#import "MSkill.h"

@interface FTHexagonSkillView ()

@end

@implementation FTHexagonSkillView

- (id)initWithSkill:(MSkill *)skill andTarget:(id<FTSkillViewDelegate>)target {
  if (self = [super initWithSkill:skill andTarget:target]) {
    _lblSkillName.font = [UIFont fontWithName:@"ClearSans-Bold" size:14];
    _lblLessonsProgress.font = [UIFont fontWithName:@"ClearSans" size:14];
  }
  
  return self;
}

@end
