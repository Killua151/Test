//
//  FTHexagonSkillCell.m
//  fanto
//
//  Created by Ethan Nguyen on 9/13/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "MMHexagonSkillCell.h"
#import "MMHexagonSkillView.h"
#import "MSkill.h"

@interface MMHexagonSkillCell ()

@end

@implementation MMHexagonSkillCell

- (CGFloat)yPosForSkillViews {
  return 8;
}

- (Class)skillViewClass {
  return [MMHexagonSkillView class];
}

@end
