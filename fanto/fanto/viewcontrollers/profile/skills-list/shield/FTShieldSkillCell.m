//
//  FTShieldSkillCell.m
//  fanto
//
//  Created by Ethan on 9/15/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "FTShieldSkillCell.h"
#import "FTShieldSkillView.h"
#import "MSkill.h"

@interface FTShieldSkillCell ()

@end

@implementation FTShieldSkillCell

- (CGFloat)yPosForSkillViews {
  return 22;
}

- (Class)skillViewClass {
  return [FTShieldSkillView class];
}

@end
