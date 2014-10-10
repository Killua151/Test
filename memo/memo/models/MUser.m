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
#import "MLeaderboardData.h"

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

- (void)setFollowings_leaderboard_by_month:(NSArray *)followings_leaderboard_by_month {
  _followings_leaderboard_by_month = [MLeaderboardData modelsFromArr:followings_leaderboard_by_month];
}

- (void)setFollowings_leaderboard_by_week:(NSArray *)followings_leaderboard_by_week {
  _followings_leaderboard_by_week = [MLeaderboardData modelsFromArr:followings_leaderboard_by_week];
}

- (void)setLastReceivedBonuses:(NSDictionary *)lastReceivedBonuses {
  if (lastReceivedBonuses == nil || ![lastReceivedBonuses isKindOfClass:[NSDictionary class]])
    return;

  [self assignProperties:lastReceivedBonuses];
  
  NSMutableDictionary *receivedBonus = [NSMutableDictionary dictionary];
  
  MSkill *affectedSkill = [MSkill modelFromDict:lastReceivedBonuses[kParamAffectedSkill]];
  
  if (affectedSkill != nil)
    receivedBonus[kParamAffectedSkill] = affectedSkill;
  
  for (NSString *key in @[kParamBonusMoney, kParamFinishExamBonusExp, kParamHeartBonusExp, kParamLeveledUp])
    if (lastReceivedBonuses[key] != nil && ![lastReceivedBonuses[key] isKindOfClass:[NSNull class]])
      receivedBonus[key] = lastReceivedBonuses[key];
  
  _lastReceivedBonuses = [NSDictionary dictionaryWithDictionary:receivedBonus];
}

- (MMLineChart *)graphLineChartInFrame:(CGRect)frame {
  NSArray *expData = nil;
  NSArray *daysData = nil;
  
  if (_exp_chart != nil && [_exp_chart isKindOfClass:[NSDictionary class]] &&
      _exp_chart[@"days"] != nil && [_exp_chart[@"days"] isKindOfClass:[NSArray class]] &&
      _exp_chart[@"exp"] != nil && [_exp_chart[@"exp"] isKindOfClass:[NSArray class]]) {
    daysData = _exp_chart[@"days"];
    expData = _exp_chart[@"exp"];
  }
  
  MMLineChart *lineChart = [[MMLineChart alloc] initWithFrame:frame];
  
  UIEdgeInsets margin = lineChart.chartMargin;
  margin.left += 20;
  lineChart.chartMargin = margin;
  
  lineChart.labelFont = [UIFont fontWithName:@"ClearSans" size:13];
  lineChart.labelTextColor = UIColorFromRGB(102, 102, 102);
  lineChart.yLabelSuffix = @"EXP";
  lineChart.yLabelCount = 5;
  
  MMLineChartData *chartData = [MMLineChartData dataWithValues:expData
                                                         color:[UIColor blackColor]
                                                    pointStyle:SPLineChartPointStyleCycle];
  chartData.pointColor = [UIColor redColor];
  chartData.pointWidth = 12;
  chartData.lineWidth = 1;
  
  [lineChart setDatas:@[chartData] forXValues:daysData];
  lineChart.emptyChartText = NSLocalizedString(@"The chart is empty.", nil);
  
  return lineChart;
}

- (NSArray *)skillsTree {
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
