//
//  MLeaderboardData.h
//  memo
//
//  Created by Ethan Nguyen on 10/9/14.
//  Copyright (c) 2014 Topica. All rights reserved.
//

#import "MBase.h"

@interface MLeaderboardData : MBase

@property (nonatomic, assign) NSInteger earned_exp;
@property (nonatomic, strong) NSString *url_avatar;
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString *username;

@end
