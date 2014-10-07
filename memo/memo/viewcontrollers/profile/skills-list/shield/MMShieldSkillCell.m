//
//  FTShieldSkillCell.m
//  fanto
//
//  Created by Ethan on 9/15/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "MMShieldSkillCell.h"
#import "MMShieldSkillView.h"
#import "MSkill.h"

@interface MMShieldSkillCell ()

@end

@implementation MMShieldSkillCell

- (CGFloat)yPosForSkillViews {
  return 22;
}

- (Class)skillViewClass {
  return [MMShieldSkillView class];
}

@end
