//
//  FTSkillCell.m
//  fanto
//
//  Created by Ethan Nguyen on 9/13/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "MMSkillCell.h"
#import "MSkill.h"
#import "MMSkillView.h"
#import "MMHexagonSkillCell.h"
#import "MMShieldSkillCell.h"

@interface MMSkillCell ()

- (void)setupSkillViewsWithTotal:(NSInteger)totalSkills;

@end

@implementation MMSkillCell

+ (Class)currentSkillCellClass {
#if kHexagonThemeDisplayMode
  return [MMHexagonSkillCell class];
#else
  return [MMShieldSkillCell class];
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
                     inTarget:(id<MMSkillViewDelegate>)target {
  if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
    LoadXibWithSameClass();
    [self setValue:reuseIdentifier forKey:@"reuseIdentifier"];
    _delegate = target;
    [self setupSkillViewsWithTotal:totalSkills];
  }
  
  return self;
}

- (void)updateCellWithSkills:(NSArray *)skills {
  [self.contentView.subviews enumerateObjectsUsingBlock:^(MMSkillView *skillView, NSUInteger index, BOOL *stop) {
    skillView.hidden = YES;
    
    if (![skillView isKindOfClass:[MMSkillView class]] ||
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
    MMSkillView *skillView = [[[MMSkillView currentSkillViewClass] alloc] initWithTarget:_delegate];
    skillView.hidden = YES;
    
    CGFloat xPos = [self xCenterForSkillAtIndex:i amongTotal:totalSkills] - skillView.frame.size.width/2;
    skillView.frame = (CGRect){CGPointMake(xPos, [self yPosForSkillViews]), skillView.frame.size};
    [self.contentView addSubview:skillView];
  }
}

@end
