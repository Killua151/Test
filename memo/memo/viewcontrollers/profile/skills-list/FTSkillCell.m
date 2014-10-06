//
//  FTSkillCell.m
//  fanto
//
//  Created by Ethan Nguyen on 9/13/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "FTSkillCell.h"
#import "MSkill.h"
#import "FTSkillView.h"
#import "FTHexagonSkillCell.h"
#import "FTShieldSkillCell.h"

@interface FTSkillCell ()

- (void)setupSkillViewsWithTotal:(NSInteger)totalSkills;

@end

@implementation FTSkillCell

+ (Class)currentSkillCellClass {
#if kHexagonThemeTestMode
  return [FTHexagonSkillCell class];
#else
  return [FTShieldSkillCell class];
#endif
}

+ (NSString *)reuseIdentifierForSkills:(NSArray *)skills {
  if ([skills count] == 0)
    return NSStringFromClass([self class]);
  
  NSMutableString *reuseId = [NSMutableString string];
  
  for (NSObject *skill in skills)
    [reuseId appendString:NSStringFromClass([skill class])];
  
  return reuseId;
}

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
                    withTotal:(NSInteger)totalSkills
                     inTarget:(id<FTSkillViewDelegate>)target {
  if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
    LoadXibWithSameClass();
    [self setValue:reuseIdentifier forKey:@"reuseIdentifier"];
    _delegate = target;
    [self setupSkillViewsWithTotal:totalSkills];
  }
  
  return self;
}

- (void)updateCellWithSkills:(NSArray *)skills {
  [self.contentView.subviews enumerateObjectsUsingBlock:^(FTSkillView *skillView, NSUInteger index, BOOL *stop) {
    skillView.hidden = YES;
    
    if (![skillView isKindOfClass:[FTSkillView class]] ||
        index >= [skills count] || ![skills[index] isKindOfClass:[MSkill class]])
      return;
    
    skillView.hidden = NO;
    [skillView populateViewWithData:skills[index]];
  }];
}

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

- (CGFloat)yPosForSkillViews {
  // Implement in child class
  return 0;
}

#pragma mark - private methods
- (void)setupSkillViewsWithTotal:(NSInteger)totalSkills {
  for (NSInteger i = 0; i < totalSkills; i++) {
    FTSkillView *skillView = [[[FTSkillView currentSkillViewClass] alloc] initWithTarget:_delegate];
    skillView.hidden = YES;
    
    CGFloat xPos = [self xCenterForSkillAtIndex:i amongTotal:totalSkills] - skillView.frame.size.width/2;
    skillView.frame = (CGRect){CGPointMake(xPos, [self yPosForSkillViews]), skillView.frame.size};
    [self.contentView addSubview:skillView];
  }
}

@end