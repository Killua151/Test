//
//  MUser.h
//  fanto
//
//  Created by Ethan on 9/18/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "MBase.h"

@class MMLineChart, MCheckpoint;

@interface MUser : MBase

@property (nonatomic, strong) NSString *_id;
@property (nonatomic, strong) NSString *auth_token;
@property (nonatomic, strong) NSArray *checkpoints;
@property (nonatomic, assign) NSInteger combo_days;
@property (nonatomic, strong) NSString *current_course_id;
@property (nonatomic, strong) NSString *current_course_name;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSDictionary *exp_chart;
@property (nonatomic, strong) NSString *fb_Id;
@property (nonatomic, strong) NSArray *follower_user_ids;
@property (nonatomic, strong) NSArray *following_user_ids;
@property (nonatomic, strong) NSArray *followings_leaderboard_by_week;
@property (nonatomic, strong) NSArray *followings_leaderboard_by_month;
@property (nonatomic, strong) NSArray *followings_leaderboard_all_time;
@property (nonatomic, strong) NSString *gmail;
@property (nonatomic, assign) BOOL is_beginner;
@property (nonatomic, assign) BOOL is_trial;
@property (nonatomic, assign) NSInteger level;
@property (nonatomic, strong) NSString *level_title;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray *skills;
@property (nonatomic, strong) NSArray *skills_tree;
@property (nonatomic, strong) NSArray *settings;
@property (nonatomic, strong) NSString *url_avatar;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, assign) NSInteger virtual_money;

@property (nonatomic, strong) NSDictionary *lastReceivedBonuses;

+ (void)loadCurrentUserFromUserDef;
+ (void)logOutCurrentUser;
+ (instancetype)currentUser;

- (void)updateAttributesFromProfileData:(NSDictionary *)userData;
- (MMLineChart *)graphLineChartInFrame:(CGRect)frame;
- (NSArray *)skillsTree;
- (NSInteger)numberOfLockedSkillsForCheckpoint:(NSInteger)checkpointRow;
- (NSInteger)checkpointPositionForCheckpoint:(NSInteger)checkpointRow;
- (MCheckpoint *)checkpointForPosition:(NSInteger)checkpointRow;

- (MSkill *)finishExamAffectedSkill;
- (NSInteger)finishExamBonusExp;
- (NSInteger)finishExamBonusMoney;
- (NSString *)finishExamCurrentCourseName;
- (NSInteger)finishExamHeartBonusExp;
- (NSInteger)finishExamLevel;
- (BOOL)finishExamLeveledUp;
- (NSInteger)finishExamNumAffectedSkills;

@end
