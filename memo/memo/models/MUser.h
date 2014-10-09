//
//  MUser.h
//  fanto
//
//  Created by Ethan on 9/18/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "MBase.h"

@class MMLineChart;

@interface MUser : MBase

@property (nonatomic, strong) NSString *_id;
@property (nonatomic, strong) NSString *auth_token;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *fb_Id;
@property (nonatomic, strong) NSString *gmail;
@property (nonatomic, assign) BOOL is_trial;
@property (nonatomic, assign) NSInteger level;
@property (nonatomic, strong) NSString *level_title;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *url_avatar;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, assign) NSInteger virtual_money;
@property (nonatomic, strong) NSArray *skills;
@property (nonatomic, strong) NSArray *skills_tree;
@property (nonatomic, assign) NSInteger combo_days;
@property (nonatomic, strong) NSDictionary *exp_chart;
@property (nonatomic, strong) NSArray *followings_leaderboard_by_week;
@property (nonatomic, strong) NSArray *followings_leaderboard_by_month;

@property (nonatomic, strong) NSDictionary *lastReceivedBonuses;

+ (void)loadCurrentUserFromUserDef;
+ (void)logOutCurrentUser;
+ (instancetype)currentUser;

- (MMLineChart *)graphLineChartInFrame:(CGRect)frame;
- (NSArray *)skillsTree;
- (NSInteger)numberOfLockedSkillsForCheckpoint:(NSInteger)checkpointRow;

@end
