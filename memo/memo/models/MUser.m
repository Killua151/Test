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
#import "MCheckpoint.h"
#import "MSettings.h"

@interface MUser () {
  NSMutableDictionary *_skillsById;
  NSMutableDictionary *_remainingSkillsMapper;
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

- (void)setFollowings_leaderboard_all_time:(NSArray *)followings_leaderboard_all_time {
  _followings_leaderboard_all_time = [MLeaderboardData modelsFromArr:followings_leaderboard_all_time];
}

- (void)setLastReceivedBonuses:(NSDictionary *)lastReceivedBonuses {
  if (lastReceivedBonuses == nil || ![lastReceivedBonuses isKindOfClass:[NSDictionary class]])
    return;

  [self assignProperties:lastReceivedBonuses];
  
  NSMutableDictionary *receivedBonus = [NSMutableDictionary dictionary];
  
  MSkill *affectedSkill = [MSkill modelFromDict:lastReceivedBonuses[kParamAffectedSkill]];
  
  if (affectedSkill != nil)
    receivedBonus[kParamAffectedSkill] = affectedSkill;
  
  for (NSString *key in @[kParamBonusMoney, kParamFinishExamBonusExp, kParamHeartBonusExp,
                          kParamLeveledUp, kParamLevel, kParamCurrentCourseName, kParamNumAffectedSkills])
    if (lastReceivedBonuses[key] != nil && ![lastReceivedBonuses[key] isKindOfClass:[NSNull class]])
      receivedBonus[key] = lastReceivedBonuses[key];
  
  _lastReceivedBonuses = [NSDictionary dictionaryWithDictionary:receivedBonus];
}

- (void)assignProperties:(NSDictionary *)dict {
  [super assignProperties:dict];
  
  if (dict[kParamSettings] != nil && [dict[kParamSettings] isKindOfClass:[NSArray class]])
    _settings = [MSettings modelsFromArr:dict[kParamSettings]];
}

- (void)updateAttributesFromProfileData:(NSDictionary *)userData {
  [self assignProperties:userData[kParamUserInfo]];
  _checkpoints = [MCheckpoint modelsFromArr:userData[kParamCheckpoints]];
  _skills_tree = userData[kParamSkillsTree];
  _skills = [MSkill modelsFromArr:userData[kParamSkills]];
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
  lineChart.emptyChartText = MMLocalizedString(@"The chart is empty.");
  
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

- (MSkill *)firstSkill {
  for (MSkill *skill in _skills)
    if (skill.order == 0)
      return skill;
  
  return [_skills firstObject];
}

- (NSInteger)numberOfLockedSkillsForCheckpoint:(NSInteger)checkpointRow {
  return [_remainingSkillsMapper[@(checkpointRow)] integerValue];
}

- (NSInteger)checkpointOrderForCheckpoint:(NSInteger)checkpointRow {
  MCheckpoint *checkpoint = _checkpointsMapper[@(checkpointRow)];
  __block NSInteger order = 0;
  
  [_checkpoints enumerateObjectsUsingBlock:^(MCheckpoint *chkpnt, NSUInteger index, BOOL *stop) {
    if (checkpoint.row == chkpnt.row) {
      order = index;
      *stop = YES;
    }
  }];
  
  return order+1;
}

- (MCheckpoint *)checkpointForPosition:(NSInteger)checkpointRow {
  return _checkpointsMapper[@(checkpointRow)];
}

- (MSkill *)finishExamAffectedSkill {
  MSkill *affectedSkill = _lastReceivedBonuses[kParamAffectedSkill];
  
  if (affectedSkill == nil || ![affectedSkill isKindOfClass:[MSkill class]])
    return 0;
  
  return affectedSkill;
}

- (NSInteger)finishExamBonusMoney {
  NSNumber *bonusMoney = _lastReceivedBonuses[kParamBonusMoney];
  
  if (bonusMoney == nil || ![bonusMoney isKindOfClass:[NSNumber class]])
    return 0;
  
  return [bonusMoney integerValue];
}

- (NSInteger)finishExamBonusExp {
  NSNumber *bonusExp = _lastReceivedBonuses[kParamFinishExamBonusExp];
  
  if (bonusExp == nil || ![bonusExp isKindOfClass:[NSNumber class]])
    return 0;
  
  return [bonusExp integerValue];
}

- (NSInteger)finishExamHeartBonusExp {
  NSNumber *bonusExp = _lastReceivedBonuses[kParamHeartBonusExp];
  
  if (bonusExp == nil || ![bonusExp isKindOfClass:[NSNumber class]])
    return 0;
  
  return [bonusExp integerValue];
}

- (BOOL)finishExamLeveledUp {
  NSNumber *leveledUp = _lastReceivedBonuses[kParamLeveledUp];
  
  if (leveledUp == nil || ![leveledUp isKindOfClass:[NSNumber class]])
    return NO;
  
  return [leveledUp boolValue];
}

- (NSInteger)finishExamLevel {
  if (![self finishExamLeveledUp])
    return -1;
  
  NSNumber *level = [MUser currentUser].lastReceivedBonuses[kParamLevel];
  
  if (level == nil || ![level isKindOfClass:[NSNumber class]])
    return -1;
  
  return [level integerValue];
}

- (NSString *)finishExamCurrentCourseName {
  NSString *currentCourseName = _lastReceivedBonuses[kParamCurrentCourseName];
  
  if (currentCourseName == nil || ![currentCourseName isKindOfClass:[NSString class]])
    return @"";
  
  return currentCourseName;
}

- (NSInteger)finishExamNumAffectedSkills {
  NSNumber *numAffectedSkills = _lastReceivedBonuses[kParamNumAffectedSkills];
  
  if (numAffectedSkills == nil || ![numAffectedSkills isKindOfClass:[NSNumber class]])
    return 0;
  
  return [numAffectedSkills integerValue];
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
  if (_remainingSkillsMapper == nil) {
    _remainingSkillsMapper = [NSMutableDictionary new];
    _checkpointsMapper = [NSMutableDictionary new];
  }
  
  [_remainingSkillsMapper removeAllObjects];
  [_checkpointsMapper removeAllObjects];
  
  __block NSInteger checkpointsCount = 0;
  
  [_skills_tree enumerateObjectsUsingBlock:^(id row, NSUInteger index, BOOL *stop) {
    if (![row isKindOfClass:[NSString class]])
      return;
    
    _remainingSkillsMapper[@(index)] = @0;
    
    if (_checkpoints[checkpointsCount] != nil)
      _checkpointsMapper[@(index)] = _checkpoints[checkpointsCount];
    else
      _checkpointsMapper[@(index)] = @0;
    
    checkpointsCount++;
  }];
  
  for (NSNumber *rowIndex in [_remainingSkillsMapper allKeys]) {
    for (NSInteger i = 0; i < [rowIndex integerValue]; i++) {
      id rowData = _skills_tree[i];
      
      if (![rowData isKindOfClass:[NSArray class]])
        continue;
      
      for (NSString *skillId in rowData) {
        if ([skillId isEqualToString:@"null"])
          continue;
        
        if (![_skillsById[skillId] unlocked]) {
          NSInteger count = [_remainingSkillsMapper[rowIndex] integerValue];
          _remainingSkillsMapper[rowIndex] = @(count+1);
        }
      }
    }
  }
}

@end
