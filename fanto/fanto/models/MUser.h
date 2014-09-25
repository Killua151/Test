//
//  MUser.h
//  fanto
//
//  Created by Ethan on 9/18/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "MBase.h"

@class FTLineChart;

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

+ (void)loadCurrentUserFromUserDef;
+ (void)logOutCurrentUser;
+ (instancetype)currentUser;
- (FTLineChart *)graphLineChartInFrame:(CGRect)frame;

@end
