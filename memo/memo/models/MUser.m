//
//  MUser.m
//  fanto
//
//  Created by Ethan on 9/18/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "MUser.h"
#import <FacebookSDK/FacebookSDK.h>
#import <GooglePlus/GooglePlus.h>
#import "MSkill.h"

@interface MUser () {
  NSMutableDictionary *_skillsById;
  NSMutableDictionary *_checkpointsMapper;
}

- (void)mapSkillsById;
- (void)updateCheckpointsMapper;

@end

@implementation MUser

static MUser *_currentUser = nil;

+ (void)loadCurrentUserFromUserDef {
  NSDictionary *savedUser = [[NSUserDefaults standardUserDefaults] dictionaryForKey:kUserDefSavedUser];
  
  if (savedUser == nil || ![savedUser isKindOfClass:[NSDictionary class]] || [savedUser count] == 0)
    return;
  
  _currentUser = [MUser modelFromDict:savedUser];
}

+ (void)logOutCurrentUser {
  _currentUser = nil;
  [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserDefSavedUser];
  [[NSUserDefaults standardUserDefaults] synchronize];
  
  [[GPPSignIn sharedInstance] disconnect];
  [[FBSession activeSession] closeAndClearTokenInformation];
}

+ (instancetype)currentUser {
  return _currentUser;
}

- (MMLineChart *)graphLineChartInFrame:(CGRect)frame {
  MMLineChart *lineChart = [[MMLineChart alloc] initWithFrame:frame];
  
  UIEdgeInsets margin = lineChart.chartMargin;
  margin.left += 20;
  lineChart.chartMargin = margin;
  
  lineChart.labelFont = [UIFont fontWithName:@"ClearSans" size:17];
  lineChart.labelTextColor = UIColorFromRGB(102, 102, 102);
  lineChart.yLabelSuffix = @"XP";
  lineChart.yLabelCount = 5;
  
  MMLineChartData *chartData = [MMLineChartData dataWithValues:@[@9, @6, @11, @14, @8, @5]
                                                         color:[UIColor blackColor]
                                                    pointStyle:SPLineChartPointStyleCycle];
  chartData.pointColor = [UIColor redColor];
  chartData.pointWidth = 12;
  chartData.lineWidth = 1;
  
  [lineChart setDatas:@[chartData] forXValues:@[@"T2", @"T3", @"T4", @"T5", @"T6", @"T7"]];
  lineChart.emptyChartText = NSLocalizedString(@"The chart is empty.", nil);
  
  return lineChart;
}

- (NSArray *)skillsTree {
//  NSMutableDictionary *skillsByCoordinate = [NSMutableDictionary dictionary];
//  NSMutableDictionary *coordinatesMapping = [NSMutableDictionary dictionary];
//  
//  for (MSkill *skill in _skills) {
//    NSArray *coordinate = skill.coordinate;
//    skillsByCoordinate[[coordinate componentsJoinedByString:@"-"]] = skill;
//    
//    NSNumber *row = [coordinate firstObject];
//    
//    if (coordinatesMapping[row] == nil)
//      coordinatesMapping[row] = [NSMutableArray array];
//    
//    [coordinatesMapping[row] addObject:[coordinate lastObject]];
//    [(NSMutableArray *)coordinatesMapping[row] sortUsingSelector:@selector(compare:)];
//  }
//  
//  NSInteger maxRowIndex =
//  [[[[coordinatesMapping allKeys] sortedArrayUsingSelector:@selector(compare:)] lastObject] integerValue];
//  
//  NSMutableArray *skillsTree = [NSMutableArray arrayWithCapacity:maxRowIndex];
//  
//  for (NSInteger row = 0; row <= maxRowIndex; row++) {
//    NSArray *columns = coordinatesMapping[@(row)];
//    
//    if (columns == nil) {
//      // Checkpoint test
//      [skillsTree addObject:[NSNull null]];
//      continue;
//    }
//    
//    NSInteger maxColumnIndex = [[columns lastObject] integerValue];
//    skillsTree[row] = [NSMutableArray array];
//    
//    for (NSInteger column = 0; column <= maxColumnIndex; column++) {
//      if (![columns containsObject:@(column)])
//        [skillsTree[row] addObject:[NSNull null]];
//      else
//        [skillsTree[row] addObject:skillsByCoordinate[[NSString stringWithFormat:@"%ld-%ld", (long)row, (long)column]]];
//    }
//    
//    // Odd row, ensure it has 3 elements
//    if (row % 2 == 1 && [skillsTree[row] count] < 3)
//      for (NSInteger i = [skillsTree[row] count]; i < 3; i++)
//        [skillsTree[row] addObject:[NSNull null]];
//  }
//  
//  return skillsTree;
  
  [self mapSkillsById];
  [self updateCheckpointsMapper];
  
  NSMutableArray *fullTree = [NSMutableArray array];
  
  for (NSArray *row in _skills_tree) {
    if (![row isKindOfClass:[NSArray class]]) {
      [fullTree addObject:[NSNull null]];
      continue;
    }
  
    NSMutableArray *fullRow = [NSMutableArray array];
    
    for (NSString *skillId in row) {
      if (_skillsById[skillId] == nil || ![_skillsById[skillId] isKindOfClass:[MSkill class]]) {
        [fullRow addObject:[NSNull null]];
        continue;
      }
      
      [fullRow addObject:_skillsById[skillId]];
    }
    
    [fullTree addObject:fullRow];
  }
  
  return fullTree;
}

- (NSInteger)numberOfLockedSkillsForCheckpoint:(NSInteger)checkpointRow {
  return [_checkpointsMapper[@(checkpointRow)] integerValue];
}

#pragma mark - Private methods
- (void)mapSkillsById {
  if (_skillsById == nil)
    _skillsById = [NSMutableDictionary new];
  
  [_skillsById removeAllObjects];
  
  for (MSkill *skill in _skills)
    _skillsById[skill._id] = skill;
}

- (void)updateCheckpointsMapper {
  if (_checkpointsMapper == nil)
    _checkpointsMapper = [NSMutableDictionary new];
  
  [_checkpointsMapper removeAllObjects];
  
  [_skills_tree enumerateObjectsUsingBlock:^(id row, NSUInteger index, BOOL *stop) {
    if (![row isKindOfClass:[NSString class]])
      return;
    
    _checkpointsMapper[@(index)] = @0;
  }];
  
  for (NSNumber *rowIndex in [_checkpointsMapper allKeys]) {
    for (NSInteger i = 0; i < [rowIndex integerValue]; i++) {
      id rowData = _skills_tree[i];
      
      if (![rowData isKindOfClass:[NSArray class]])
        continue;
      
      for (NSString *skillId in rowData) {
        if ([skillId isEqualToString:@"null"])
          continue;
        
        if (![_skillsById[skillId] unlocked]) {
          NSInteger count = [_checkpointsMapper[rowIndex] integerValue];
          _checkpointsMapper[rowIndex] = @(count+1);
        }
      }
    }
  }
}

@end
