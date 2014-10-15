//
//  MCheckpoint.h
//  memo
//
//  Created by Ethan Nguyen on 10/15/14.
//  Copyright (c) 2014 Topica. All rights reserved.
//

#import "MBase.h"

@interface MCheckpoint : MBase

@property (nonatomic, assign) NSInteger row;
@property (nonatomic, strong) NSString *highest_skill_id;
@property (nonatomic, assign) NSInteger remaining_test_times;

@end
