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

- (CGFloat)xCenterForSkillAtIndex:(NSInteger)index amongTotal:(NSInteger)total;

@end

@implementation FTShieldSkillCell

- (void)updateCellWithSkills:(NSArray *)skills {
  if ([self.contentView.subviews count] == 0) {
    NSInteger totalSkills = [skills count];
    
    [skills enumerateObjectsUsingBlock:^(MSkill *skill, NSUInteger index, BOOL *stop) {
      if (skill == nil || ![skill isKindOfClass:[MSkill class]])
        return;
      
      FTShieldSkillView *skillView = [[FTShieldSkillView alloc] initWithSkill:skill andTarget:self.delegate];
      
      CGFloat xPos = [self xCenterForSkillAtIndex:index amongTotal:totalSkills] - skillView.frame.size.width/2;
      skillView.frame = (CGRect){CGPointMake(xPos, 22), skillView.frame.size};
      [self.contentView addSubview:skillView];
    }];
  }
  
  for (FTShieldSkillView *skillView in self.contentView.subviews) {
    if (![skillView isKindOfClass:[FTShieldSkillView class]])
      continue;
    
    [skillView populateData];
  }
}

#pragma mark - Private methods
- (CGFloat)xCenterForSkillAtIndex:(NSInteger)index amongTotal:(NSInteger)total {
  switch (total) {
    case 1:
      return self.frame.size.width/2;
      
    case 2:
      switch (index) {
        case 0:
          return self.frame.size.width/2-50;
          
        case 1:
          return self.frame.size.width/2+50;
          
        default:
          return 0;
      }
      
    case 3:
      switch (index) {
        case 0:
          return self.frame.size.width/2-100;
          
        case 1:
          return self.frame.size.width/2;
          
        case 2:
          return self.frame.size.width/2+100;
          
        default:
          return 0;
      }
      
    default:
      return 0;
  }
}

@end
