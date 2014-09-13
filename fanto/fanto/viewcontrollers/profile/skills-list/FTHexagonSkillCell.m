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

- (CGFloat)xCenterForSkillAtIndex:(NSInteger)index amongTotal:(NSInteger)total;

@end

@implementation FTHexagonSkillCell

+ (NSString *)reuseIdentifierForSkills:(NSArray *)skills {
  if ([skills count] == 0)
    return NSStringFromClass([self class]);
  
  NSMutableString *reuseId = [NSMutableString string];
  
  for (NSObject *skill in skills)
    [reuseId appendString:NSStringFromClass([skill class])];
  
  return reuseId;
}

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier {
  if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
    LoadXibWithSameClass();
    [self setValue:reuseIdentifier forKey:@"reuseIdentifier"];
  }
  
  return self;
}

- (void)updateCellWithSkills:(NSArray *)skills {
  if ([self.contentView.subviews count] == 0) {
    NSInteger totalSkills = [skills count];
    
    [skills enumerateObjectsUsingBlock:^(MSkill *skill, NSUInteger index, BOOL *stop) {
      if (skill == nil || ![skill isKindOfClass:[MSkill class]])
        return;
      
      FTHexagonSkillView *skillView = [[FTHexagonSkillView alloc] initWithSkill:skill andTarget:_delegate];
      
      CGFloat xPos = [self xCenterForSkillAtIndex:index amongTotal:totalSkills] - skillView.frame.size.width/2;
      skillView.frame = (CGRect){CGPointMake(xPos, 8), skillView.frame.size};
      [self.contentView addSubview:skillView];
    }];
  }
  
  for (FTHexagonSkillView *skillView in self.contentView.subviews) {
    if (![skillView isKindOfClass:[FTHexagonSkillView class]])
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
