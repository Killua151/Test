//
//  MLeaderboardData.h
//  memo
//
//  Created by Ethan Nguyen on 10/9/14.
//  Copyright (c) 2014 Topica. All rights reserved.
//

#import "MBase.h"

@interface MLeaderboardData : MBase

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, assign) NSInteger earned_exp;

@end
