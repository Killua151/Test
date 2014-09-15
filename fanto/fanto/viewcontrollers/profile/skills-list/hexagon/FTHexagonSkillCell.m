//
//  FTHexagonSkillCell.m
//  fanto
//
//  Created by Ethan Nguyen on 9/13/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "FTHexagonSkillCell.h"
#import "FTHexagonSkillView.h"
#import "MSkill.h"

@interface FTHexagonSkillCell ()

@end

@implementation FTHexagonSkillCell

- (CGFloat)yPosForSkillViews {
  return 8;
}

- (Class)skillViewClass {
  return [FTHexagonSkillView class];
}

@end
